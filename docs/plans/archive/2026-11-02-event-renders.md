# Event Packs: rendered event images for the Workshop page

Status: DONE

## Context

The owner wants each pack's Workshop page to show every event of the pack as an image of the in-game event window, made as part of the creation process. Decisions (2026-11-02):
- **Rendering: offline.** A Python/Pillow script draws the country event window from the game's own files, with no game launch.
- **Upload: manual.** The owner adds the images on the Workshop page. SteamCMD's `workshop_build_item` VDF has only one `previewfile`, so `Publish-Mod.ps1` cannot add gallery images, and the owner chose not to add a Steamworks API helper.
- **Effects: not shown.** Each option button shows only its text, as the game does before you hover over it.

What exists today:
- Event text: `source/<key>/events.json`, and the generated English localisation `packs/<key>/localisation/english/ep_<tag>_l_english.yml` (keys `ep_<tag>.<id>.t`, `.desc`, `.a`, `.b`, ...).
- Pictures: the 210x176 uncompressed BGRA DDS files `packs/<key>/gfx/event_pictures/ep_<tag>/*.dds`, mapped in `packs/<key>/interface/ep_<tag>_event_pictures.gfx`. Vanilla pictures (`vanilla:GFX_report_event_*`, e.g. Finland event 4) are in the game's `interface/eventpictures.gfx` [SPR-028].
- Window layout: vanilla `interface/eventwindow.gui`, window `EventWindow`, 581 px wide.
  - `top_Window`, 121 px high: `GFX_event_report_top_win`, and `Title` at 14,70 in `hoi4_typewriter22`, maxWidth 551, maxHeight 32.
  - `midsection` at y 121: a tiling `GFX_event_report_tileable_midsection`, and `Description` at 31,0 in `hoi4_typewriter16`, maxWidth 512. The game grows the window to the full text [GUW-046].
  - `bottom_Window`, 206 px high: `GFX_event_report_bottom_win`, `event_picture` at 5,5, `event_pic_clip` frame at -3,35, and `options_grid` at 215,-1 with 300x47 slots.
- Rendering reference to read, not import: `mods/hoi4-1440p-ui-mod/tools/guiparse.py` has `load_image` (DDS via Pillow), `load_sprites` (.gfx index), `font_declarations` and `load_font` (BMFont `.fnt` + page), and `find_game_dir` (`--game-dir`, `HOI4_GAME_DIR`, Steam registry, `libraryfolders.vdf`). Engine facts: the typewriter fonts are white glyphs declared black [GUW-011]; text width is the sum of `xadvance` [GUW-012]; `.fnt` glyph ids [SPR-023].
- The pattern to copy: `-ConvertPictures` (`Invoke-EpConvertPictures`, `tools/EventPacks.ps1:1475`, Python found by `Get-EpPythonExecutable`, `:1466`) and `-PreviewPictures` (`Export-EpPicturePreviews`, `:1636`, output in `scratch/preview/<key>/`).

## Approach

### 1. Renderer: `tools/render_event_cards.py` (new; Python 3 + Pillow; run with `python -I`)
- Arguments:
  - `--pack <key>` (required).
  - `--game-dir`, found the way `find_game_dir` does when not given.
  - `--out`, default `artifacts/workshop-images/<key>/`.
  - `--source-dir` and `--pack-dir`, for tests; defaults `source/<key>` and `packs/<key>`.
- Per event, in id order:
  - Structure (id, picture key, number of options) from `events.json`.
  - Strings from the generated English yml, so the image shows what ships.
  - The picture from the pack's `.gfx` and DDS, or from vanilla `eventpictures.gfx` for `vanilla:` pictures.
- Drawing, all from vanilla `eventwindow.gui` and its sprites:
  - The window with the description wrapped at 512 px and the midsection tiled to its height.
  - The bottom section with the picture, the clip frame, and one option button per option. The button entry sits in `options_grid`; read its type and sprite from `eventwindow.gui`.
  - Bitmap-font text in the colours the game uses.
  - Only the code needed for this is ported from `guiparse.py`.
- Output:
  - The window is composed on a plain dark background with a small margin, written as `NN-<event key>.png` (e.g. `01-berlin_1936_olympics.png`).
  - The output folder is emptied first, so dropped events do not linger.
  - A file over 1 MB is written as a JPEG at quality 90, with a line saying so.
- Text checks, printed as `[WARN] ep_<tag>.<id>: ...`:
  - A title wider than 551 px, wrapping past its 32 px box: it runs into the description [GUW-027].
  - An option text wider than its button.
  - A picture that cannot be resolved.
- Exit code 1 on a missing game folder or a missing picture.
- Last line: `Rendered <n> events to <folder>`.
- The docstring cites the register ids it relies on: [SPR-023], [SPR-028], [GUW-011], [GUW-012], [GUW-046]. No engine fact is written into the repository.

### 2. `build.ps1 -RenderEvents [-Pack <key>] [-GameDir <path>]`
- Add a parameter set like `-PreviewPictures`.
- Add the dispatch in `tools/EventPacks.ps1`: a function `Export-EpEventRenders` next to `Export-EpPicturePreviews`. It reuses `Get-EpPythonExecutable` and runs the script once per pack (every pack when `-Pack` is omitted).
- Only a targeted read of those few functions and the switch is needed. The project hook asks the owner before any read of `EventPacks.ps1`.
- Nothing is written under `packs/`, so `-Check` is unaffected.

### 3. Workflow and docs
- `docs/plans/TEMPLATE-pack.md`: add a step after `-Check`:
  - `powershell -File .\build.ps1 -RenderEvents -Pack <pack>`: expect `Rendered <n> events`, and no `[WARN]` outside "Kept on judgment".
  - Renumber the later steps, and update every skill or doc reference to the old step numbers (grep for "step 8", "step 9", "steps 1 to").
- `.claude/skills/event-pack-implement/SKILL.md`, step 3.5: also open the renders with Read, checking that the title fits, the text reads right and the buttons hold their text.
- `.claude/skills/event-pack-create/SKILL.md`: the Phase 5 rehearsal includes the render step and treats its `[WARN]` lines like `-Check` warnings: fix the text, or record it in "Kept on judgment".
- `.claude/skills/event-pack-release/SKILL.md`, step 4: after the upload, run `-RenderEvents -Pack <key>` from the committed pack and give the owner the folder path. The owner then:
  - opens the item's Workshop page, "Add/edit images & videos";
  - on an update, removes the previous event images when events or texts changed;
  - uploads the files in name order.
- Steam's "Add/edit images & videos" page is reached from the item page. This step is the owner's, like the upload itself.
- `AGENTS.md`, "Commands beyond build.ps1": add `-RenderEvents [-Pack] [-GameDir]`, and that it needs Python 3 with Pillow and the game install.
- `tools/HoiModBuild.json` `testSuites.EventPacks`: add `tools/render_event_cards.py`.
- Run `build.ps1 -SyncMirrors` after the skill edits (the Documentation tests check the Antigravity mirror).

### 4. Tests: `tests/EventPacks.Tests.ps1`
- `-RenderEvents -Pack finland`, with `--out` in TestDrive, writes one PNG per event of `source/finland/events.json`, each 581 px wide plus the margin.
- A fixture copy of the Finland source with one over-long title prints the title `[WARN]`.
- Both tests are skipped with `Set-ItResult -Skipped` when no game install is found, as on CI.

## Files
- New: `tools/render_event_cards.py`.
- Changed:
  - `build.ps1`
  - `tools/EventPacks.ps1`
  - `tools/HoiModBuild.json`
  - `tests/EventPacks.Tests.ps1`
  - `docs/plans/TEMPLATE-pack.md`
  - `.claude/skills/event-pack-{create,implement,release}/SKILL.md`, plus their `.agents/` mirrors via `-SyncMirrors`
  - `AGENTS.md`
- First step of implementation: save this plan as `docs/plans/2026-11-02-event-renders.md`, as the root AGENTS.md asks for implementation plans.

## Verification
1. `powershell -File .\build.ps1 -RenderEvents -Pack finland`: 15 images in `artifacts/workshop-images/finland/`, including event 4 with its vanilla tank-factory picture. Run `-Pack france`: 20 images. Open several with Read.
2. Compare with the game once, on the owner's word: one event fired with `event ep_fin.1` through `-TestMod`, and an F11 screenshot [AUTO-008]. Any difference in position, colour or font that the files did not show is recorded in the register through `hoi4-modding-knowledge`, and fixed in the renderer.
3. `powershell -File .\build.ps1 -Check -Pack finland` and `-Pack france`: still `Check OK`, since nothing is written into the packs.
4. `tests\Run-Tests.ps1 -Changed` while working, then `build.ps1 -ValidateOnly` and `build.ps1 -Test` at the end.
5. `ep-reviewer` as the final gate, since this changes the mod's tools. The commit waits for the owner.

## Outcome

2026-11-02.
- `build.ps1 -RenderEvents -Pack finland` wrote 15 images and `-Pack france` 20, with no warning. Each is 613 px wide: the 581 px window and a 16 px margin. Finland event 4 shows its vanilla tank-factory picture.
- `-Check -Pack finland` ends `Check OK: 1 pack(s), 0 warning(s).` `-ValidateOnly` ends `Validation succeeded.` `-Test` gives 215 passed, 0 failed.
- Deviations:
  - The upload steps are a new section 5 of `event-pack-release`, not part of step 4.
  - An option gets a `[WARN]` when its text needs more lines than the button's 40 px box holds (hoi_20bs wraps at 340 px). The game wraps a text in a maxWidth box [GUW-015], and without fixedsize it runs past the box [GUW-027]. The first version of the renderer cut such text off; after the in-game check it draws the overflow as the game does.
  - `ep-implementer.md` got the rule for the new step.
- Verification 2 was done on 2026-11-02 with the owner's F11 screenshot of `ep_fin.4`. The window art, picture, clip and buttons matched pixel for pixel. Three fixes followed: the gap under the description is 30 px, not 16 [GUW-047]; the fonts are kerned [SPR-030]; the stretched midsection was right [SPR-029]. All three were recorded in the register.
- Review (ep-reviewer): the minor findings are fixed, namely a wrong `--game-dir` or a missing pack giving an `[ERROR]`, the release wording, the citations, this Status line, and tests for the option warning and a missing picture. The tiling question was settled by Verification 2. The finding that `-RenderEvents` is not on the `.claude/settings.json` allow list goes to the owner.
- Added after the owner's review of the renders (2026-11-02): each window now sits at 1:1 on a 16:9 image, the same size for every event of a pack, over a blurred and dimmed vanilla loading screen. By default the screens rotate from event to event; `--background load_<n>|none` of the script picks one screen or none.
