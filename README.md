# Piposh 3D Remaster

**Version 0.0.1** — initial playable remaster baseline (2026)

A preservation / enhancement project for **Piposh 3D** (official release 01/02/2003), built on **3D GameStudio A5 (Acknex 5)**. Goal: run cleanly on modern Windows, unlock engine limits that blocked mods, and open a path to a full remaster (**1.0.0**).

Original game credit: Piposh 3D v1.00. This tree adds launchers, binary patches, asset tools, and upscaled skins on top of that base.

---

## Quick start

1. Run **`Go.bat`** (or **`Launch.bat`**).
2. Do **not** rely on the old Director launcher (`Piposh3D.exe`) for remaster features — it cannot pass engine flags like `-NX`.
3. Optional Town-only test: **`TestTown.bat`**.

Requires the bundled **dgVoodoo2** wrappers (`DDraw.dll` / `D3DImm.dll` + `dgVoodoo.conf`) so DirectDraw / Direct3D 7 can run on modern GPUs.

---

## What 0.0.1 already unlocks

### Memory — “Nexus too small” / 40 MB limit

A5 uses a fixed **NEXUS** heap (default **40 MB**). Bigger models/textures hit `Nexus too small`.

| Change | Detail |
|--------|--------|
| Binary default | All module `.exe`s patched: default nexus **40 → 512 MB** |
| Override kill | Disabled an INI/app-name path that could reset nexus back to ~20–30 MB |
| Large Address Aware | PE flag set so a 32-bit process can actually allocate ~512 MB |
| Launcher | `Launch.bat` always starts modules with `-NX 512` via **full path** (avoids `cmd`’s `START` builtin eating `start.exe` args) |

Re-apply patches if needed: `tools\patch_nexus.bat` / `tools\patch_nexus.ps1`.

### Modern display / sharper 3D

- **dgVoodoo2** translates legacy fullscreen modes.
- Configured for aspect-correct scale, supersampling, MSAA, anisotropic filtering, mipmaps (`dgVoodoo.conf`).
- Game still runs at native **640×480** app resolution for stable UI placement; 3D is sharpened via the wrapper.

### Script editing without checksum blocks

A5 validates `.wdl` scripts and the engine binary (“script modified” / “engine corrupted”).

- All game module executables are **checksum-cracked** (script + self-check defeated).
- You can edit `*.wdl` (and shared `IO.wdl`) and rebuild flow without the stock protection rejecting the files.
- Keep originals under `_backup_wdl\` when experimenting.

### Models & textures — extract, edit, re-import

| Path | Role |
|------|------|
| `skins_editable\<Model>\skinN.png` | Editable skin atlases |
| `_backup_mdl\` | Pristine original `.MDL` files |
| `tools\mdl_tool.py` | Extract / import for **MDL3 / MDL5 / IDPO** (8-bit + 565) |
| `tools\extract-skins.bat` / `import-skins.bat` | One-model helpers |
| `tools\batch_upscale_all.py` / `batch_reprocess_safe.py` | Batch AI 2× with UV-island-safe gutters |

~640 character/prop models are 2× upscaled and re-embedded; UVs are scaled with the skins. Island-safe reprocess reduces AI “bleed” across UV gaps.

### Launcher contract (how modules chain)

Reverse-engineered from the original Director loop + `IO.wdl`:

- Boot → `Start.exe`
- Handoff → write next exe name to `Run.txt` + bump `Prefs\Date.txt`
- Quit → `Prefs\Flag.txt` = `0`

`Launch.bat` reproduces that loop and injects `-d l1 -NX …` every time.

---

## Project layout (short)

```
Go.bat / Launch.bat     Remaster entry
*.exe + *.wdl           A5 modules (patched engines + scripts)
MDL\                    3D models (live)
_backup_mdl\            Original models
_backup_exe\            Original engines (pre-patch snapshots)
skins_editable\         PNG skins for hand/AI editing
WMB\                    Levels (textures still mostly stock in 0.0.1)
GFX\                    2D UI / overlays (mostly stock in 0.0.1)
tools\                  Patchers, MDL pipeline, upscalers
dgVoodoo.conf           Display wrapper settings
```

---

## Roadmap → 1.0.0

0.0.1 is **get it running + unlock the platform**. Not a finished remaster.

| # | Goal |
|---|------|
| 1 | **Quality-of-life** — smoother transitions, defaults, accessibility, QoL toggles |
| 2 | **Better art** — real texture/model upgrades (authored for MDL UV layouts, not only upscaled JPGs/PNGs); world **WMB** + **GFX** 2D still largely original |
| 3 | **Stable gameplay + mode menu** — launch **Original / Remaster / QoL / Cheats** (and similar) without breaking saves |
| 4 | **Widescreen** — true 16:9 / 21:9 (engine mode work + UI anchoring), beyond 4:3 + wrapper scale |
| 5 | **Launcher extras** — save list / load picker, save editor, **movie mode** (walk all dialogue/scenes) |
| 6 | **Fluency** — fewer stalls, cleaner module handoffs, optional diagnostics off by default, general polish |

Track these as the project grows; none of the 1.0.0 items above are claimed done in 0.0.1.

---

## Known limits (0.0.1)

- Still a **32-bit** A5 process — nexus is large, not unlimited.
- Internal resolution remains **640×480**; sharpness is mostly supersampling + asset 2×.
- **WMB** level textures and most **GFX** 2D are not remastered yet.
- A few terrain meshes (`MDL4` / `MDL2`) were left untouched.
- Widescreen and a mode-select launcher are **future** work.

---

## Restoring originals

- Models: copy from `_backup_mdl\` over `MDL\`
- Engines: see `_backup_exe\` / `_backup_exe_pre_nexus\`
- Scripts: `_backup_wdl\`

---

## License / courtesy

Piposh 3D remains the property of its original authors/publishers. This remaster tree is a fan preservation effort for personal/archival use. Redistribute only if you have the rights to the base game.
