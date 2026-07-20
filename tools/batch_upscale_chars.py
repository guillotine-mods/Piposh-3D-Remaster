"""
Batch AI-upscale all character MDL skins to 2x and re-embed.

Uses Real-ESRGAN anime model at 4x then Lanczos down to 2x (same as Piposh proof).
Skips non-character props. Safe to re-run (always rebuilds from _backup_mdl).
"""
import glob, os, sys, subprocess, shutil, json
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
os.chdir(ROOT)

ESRGAN = os.path.join("tools", "realesrgan", "realesrgan-ncnn-vulkan.exe")
TOOL = os.path.join("tools", "mdl_tool.py")

# Filename prefixes / exact names that are characters (not props/vehicles/buildings)
INCLUDE_PREFIXES = (
    "Pip", "pip", "FPip", "Poz", "Ami", "Boss", "Bad", "Nanny", "Manager",
    "Shik", "Flea", "dll", "Doc", "guard", "Guard", "Man", "Woman", "Cook",
)
SKIP_EXACT = {
    "Mill.mdl", "SaveLoad.mdl", "Mansion.mdl", "mandolin.mdl",
    "Man.MDL",  # check - Man.MDL is a character, don't skip
}
# Remove Man from skip - I mistakenly thought. Fix SKIP:
SKIP_EXACT = {
    "Mill.mdl", "SaveLoad.mdl", "Mansion.mdl", "mandolin.mdl",
}


def is_character(name):
    if name in SKIP_EXACT:
        return False
    return any(name.startswith(p) for p in INCLUDE_PREFIXES)


def list_models():
    files = {}
    for p in glob.glob("MDL/*.[Mm][Dd][Ll]"):
        base = os.path.basename(p)
        # normalize key by lower for uniqueness on case-insensitive FS
        files[base.lower()] = p
    out = []
    for p in sorted(files.values(), key=lambda x: os.path.basename(x).lower()):
        if is_character(os.path.basename(p)):
            out.append(p)
    return out


def upscale_folder(src_dir, dst_dir, target_w, target_h):
    tmp = "_tmp_up_batch"
    if os.path.exists(tmp):
        shutil.rmtree(tmp)
    os.makedirs(tmp)
    # Real-ESRGAN on the folder
    cmd = [ESRGAN, "-i", src_dir, "-o", tmp, "-n", "realesrgan-x4plus-anime", "-s", "4", "-f", "png"]
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print("ESRGAN stderr:", r.stderr[-500:] if r.stderr else "")
        raise SystemExit(f"ESRGAN failed for {src_dir}")
    os.makedirs(dst_dir, exist_ok=True)
    # Keep only skin*.png, resize to 2x original
    for fn in os.listdir(tmp):
        if not fn.lower().startswith("skin") or not fn.lower().endswith(".png"):
            continue
        im = Image.open(os.path.join(tmp, fn)).resize((target_w, target_h), Image.LANCZOS)
        im.save(os.path.join(dst_dir, fn))
    shutil.rmtree(tmp, ignore_errors=True)


def main():
    if not os.path.exists(ESRGAN):
        raise SystemExit(f"missing {ESRGAN}")
    models = list_models()
    print(f"Character models to process: {len(models)}")
    ok, fail = [], []
    for mdl in models:
        name = os.path.splitext(os.path.basename(mdl))[0]
        edit = os.path.join("skins_editable", name)
        print(f"\n==== {name} ====")
        try:
            subprocess.check_call([sys.executable, TOOL, "extract", mdl, edit])
            meta = json.load(open(os.path.join(edit, "_meta.json")))
            ow, oh = meta["skin_w"], meta["skin_h"]
            tw, th = ow * 2, oh * 2
            # Upscale into a staging folder then replace skins in edit dir
            stage = edit + "_up"
            upscale_folder(edit, stage, tw, th)
            for fn in os.listdir(stage):
                if fn.startswith("skin") and fn.endswith(".png"):
                    shutil.copy2(os.path.join(stage, fn), os.path.join(edit, fn))
            shutil.rmtree(stage, ignore_errors=True)
            subprocess.check_call([sys.executable, TOOL, "import", mdl, edit])
            ok.append(name)
        except Exception as e:
            print(f"FAILED {name}: {e}")
            fail.append((name, str(e)))
    print(f"\n===== DONE ok={len(ok)} fail={len(fail)} =====")
    for n, e in fail:
        print(f"  FAIL {n}: {e}")


if __name__ == "__main__":
    main()
