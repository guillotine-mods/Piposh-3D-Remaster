"""
Re-embed all backed-up MDLs with island-safe 2x upscaling.

AI adds detail; edge-connected black UV gutters are restored so paint does
not bleed across islands / off the mesh.
"""
import os, sys, subprocess, shutil, json, glob
import numpy as np
from PIL import Image
from collections import deque

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

ESRGAN = os.path.join("tools", "realesrgan", "realesrgan-ncnn-vulkan.exe")
TOOL = os.path.join("tools", "mdl_tool.py")


def edge_black_mask_arr(arr, thresh=18):
    """arr HxWx3 uint8 -> bool mask of border-connected near-black."""
    h, w, _ = arr.shape
    dark = arr.sum(axis=2) <= thresh
    mask = np.zeros((h, w), dtype=bool)
    q = deque()
    for x in range(w):
        for y in (0, h - 1):
            if dark[y, x]:
                mask[y, x] = True
                q.append((x, y))
    for y in range(h):
        for x in (0, w - 1):
            if dark[y, x] and not mask[y, x]:
                mask[y, x] = True
                q.append((x, y))
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and dark[ny, nx] and not mask[ny, nx]:
                mask[ny, nx] = True
                q.append((nx, ny))
    return mask


def island_safe_compose(orig_im, ai_im):
    orig = np.asarray(orig_im.convert("RGB"), dtype=np.uint8)
    ai = np.asarray(ai_im.convert("RGB"), dtype=np.uint8)
    mh, mw = orig.shape[:2]
    ah, aw = ai.shape[:2]
    mask = edge_black_mask_arr(orig)
    # nearest upsample mask
    yy = np.minimum(mh - 1, (np.arange(ah) * mh // ah))
    xx = np.minimum(mw - 1, (np.arange(aw) * mw // aw))
    mask_big = mask[yy][:, xx]
    nn = np.asarray(orig_im.convert("RGB").resize((aw, ah), Image.NEAREST), dtype=np.uint8)
    out = ai.copy()
    out[mask_big] = 0
    return Image.fromarray(out, "RGB")


def already_has_backup(path):
    base = os.path.basename(path)
    for f in os.listdir("_backup_mdl"):
        if f.lower() == base.lower():
            return os.path.join("_backup_mdl", f)
    return None


def list_backed_models():
    files = {}
    for p in glob.glob("MDL/*.*"):
        if p.lower().endswith(".mdl") and already_has_backup(p):
            files[os.path.basename(p).lower()] = p
    return sorted(files.values(), key=lambda x: os.path.basename(x).lower())


def upscale_edit_folder(edit, tw, th):
    """AI-upscale all skin*.png in edit folder in-place, island-safe."""
    skins = sorted(f for f in os.listdir(edit) if f.startswith("skin") and f.endswith(".png"))
    if not skins:
        return 0
    # stash originals
    orig_dir = os.path.join(edit, "_orig")
    if os.path.exists(orig_dir):
        shutil.rmtree(orig_dir)
    os.makedirs(orig_dir)
    for fn in skins:
        shutil.copy2(os.path.join(edit, fn), os.path.join(orig_dir, fn))

    tmp_in = os.path.join(edit, "_ai_in")
    tmp_out = os.path.join(edit, "_ai_out")
    for d in (tmp_in, tmp_out):
        if os.path.exists(d):
            shutil.rmtree(d)
        os.makedirs(d)
    for fn in skins:
        shutil.copy2(os.path.join(orig_dir, fn), os.path.join(tmp_in, fn))

    cmd = [ESRGAN, "-i", tmp_in, "-o", tmp_out, "-n", "realesrgan-x4plus-anime", "-s", "4", "-f", "png"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    use_ai = r.returncode == 0

    for fn in skins:
        orig = Image.open(os.path.join(orig_dir, fn))
        ai_path = os.path.join(tmp_out, fn)
        if use_ai and os.path.exists(ai_path):
            ai = Image.open(ai_path).resize((tw, th), Image.LANCZOS)
            island_safe_compose(orig, ai).save(os.path.join(edit, fn))
        else:
            orig.resize((tw, th), Image.LANCZOS).save(os.path.join(edit, fn))

    shutil.rmtree(tmp_in, ignore_errors=True)
    shutil.rmtree(tmp_out, ignore_errors=True)
    shutil.rmtree(orig_dir, ignore_errors=True)
    return len(skins)


def process_one(mdl):
    name = os.path.splitext(os.path.basename(mdl))[0]
    edit = os.path.join("skins_editable", name)
    bp = already_has_backup(mdl)
    shutil.copy2(bp, mdl)
    subprocess.check_call([sys.executable, TOOL, "extract", mdl, edit],
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    meta = json.load(open(os.path.join(edit, "_meta.json")))
    ow, oh = meta["skin_w"], meta["skin_h"]
    if ow <= 0 or oh <= 0:
        # MDL5 may report 0 in header meta from old extracts; read from PNG
        png0 = os.path.join(edit, "skin0.png")
        ow, oh = Image.open(png0).size
    tw, th = min(ow * 2, 2048), min(oh * 2, 2048)
    n = upscale_edit_folder(edit, tw, th)
    subprocess.check_call([sys.executable, TOOL, "import", mdl, edit],
                          stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return n


def main():
    models = list_backed_models()
    print(f"Reprocessing {len(models)} models with island-safe 2x", flush=True)
    ok, fail = 0, []
    for i, mdl in enumerate(models, 1):
        name = os.path.basename(mdl)
        print(f"[{i}/{len(models)}] {name}", flush=True)
        try:
            n = process_one(mdl)
            print(f"  ok ({n} skins)", flush=True)
            ok += 1
        except Exception as e:
            print(f"  FAIL: {e}", flush=True)
            fail.append((name, str(e)))
            bp = already_has_backup(mdl)
            if bp:
                shutil.copy2(bp, mdl)
    print(f"\nDONE ok={ok} fail={len(fail)}", flush=True)
    for n, e in fail:
        print(f"  {n}: {e}", flush=True)


if __name__ == "__main__":
    main()
