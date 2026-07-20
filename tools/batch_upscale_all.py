"""
Batch AI-upscale ALL remaining MDL skins (type-2 / RGB565) to 2x and re-embed.
Skips already-upscaled models and 8-bit (type 0) skins.
"""
import glob, os, sys, subprocess, shutil, json, struct
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

ESRGAN = os.path.join("tools", "realesrgan", "realesrgan-ncnn-vulkan.exe")
TOOL = os.path.join("tools", "mdl_tool.py")


def list_all_mdl():
    files = {}
    for p in glob.glob("MDL/*.*"):
        if p.lower().endswith(".mdl"):
            files[os.path.basename(p).lower()] = p
    return sorted(files.values(), key=lambda x: os.path.basename(x).lower())


def already_upscaled(path):
    base = os.path.basename(path)
    bp = os.path.join("_backup_mdl", base)
    if not os.path.exists(bp):
        for f in os.listdir("_backup_mdl"):
            if f.lower() == base.lower():
                bp = os.path.join("_backup_mdl", f)
                break
        else:
            return False
    try:
        return os.path.getsize(path) > os.path.getsize(bp) * 1.2
    except OSError:
        return False


def can_handle(path):
    """Return True if mdl_tool can extract (type-2 skins)."""
    try:
        subprocess.check_call(
            [sys.executable, TOOL, "info", path],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True
    except subprocess.CalledProcessError:
        return False


def upscale_folder(src_dir, dst_dir, target_w, target_h):
    tmp = "_tmp_up_batch"
    if os.path.exists(tmp):
        shutil.rmtree(tmp)
    os.makedirs(tmp)
    cmd = [ESRGAN, "-i", src_dir, "-o", tmp, "-n", "realesrgan-x4plus-anime", "-s", "4", "-f", "png"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError(f"ESRGAN failed: {(r.stderr or '')[-300:]}")
    os.makedirs(dst_dir, exist_ok=True)
    for fn in os.listdir(tmp):
        if not fn.lower().startswith("skin") or not fn.lower().endswith(".png"):
            continue
        im = Image.open(os.path.join(tmp, fn)).resize((target_w, target_h), Image.LANCZOS)
        im.save(os.path.join(dst_dir, fn))
    shutil.rmtree(tmp, ignore_errors=True)


def main():
    if not os.path.exists(ESRGAN):
        raise SystemExit(f"missing {ESRGAN}")
    models = [p for p in list_all_mdl() if not already_upscaled(p)]
    print(f"Candidates (not yet upscaled): {len(models)}")
    ok, fail, skip = [], [], []
    for i, mdl in enumerate(models, 1):
        name = os.path.splitext(os.path.basename(mdl))[0]
        print(f"\n==== [{i}/{len(models)}] {name} ====")
        if not can_handle(mdl):
            print("SKIP unsupported skin format")
            skip.append(name)
            continue
        edit = os.path.join("skins_editable", name)
        try:
            subprocess.check_call([sys.executable, TOOL, "extract", mdl, edit])
            meta = json.load(open(os.path.join(edit, "_meta.json")))
            ow, oh = meta["skin_w"], meta["skin_h"]
            # Cap extreme sizes: never exceed 2048 on a side after 2x
            tw, th = min(ow * 2, 2048), min(oh * 2, 2048)
            if (tw, th) == (ow, oh):
                print(f"SKIP already at cap {ow}x{oh}")
                skip.append(name)
                continue
            stage = edit + "_up"
            upscale_folder(edit, stage, tw, th)
            for fn in os.listdir(stage):
                if fn.startswith("skin") and fn.endswith(".png"):
                    shutil.copy2(os.path.join(stage, fn), os.path.join(edit, fn))
            shutil.rmtree(stage, ignore_errors=True)
            # copy _meta stays; import reads PNGs
            subprocess.check_call([sys.executable, TOOL, "import", mdl, edit])
            ok.append(name)
        except Exception as e:
            print(f"FAILED {name}: {e}")
            fail.append((name, str(e)))
    print(f"\n===== DONE ok={len(ok)} fail={len(fail)} skip={len(skip)} =====")
    for n, e in fail:
        print(f"  FAIL {n}: {e}")
    if skip:
        print(f"  skipped {len(skip)} (8-bit or unsupported)")


if __name__ == "__main__":
    main()
