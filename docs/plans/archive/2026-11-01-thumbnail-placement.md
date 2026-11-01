# France and Finland packs: thumbnails with the banner off the picture's subject

Status: DONE
Pack: france (FRA, namespace ep_fra); finland (FIN, namespace ep_fin)
Kind: thumbnail
Created: 2026-11-01

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. This plan changes only `packs/france/thumbnail.png` and `packs/finland/thumbnail.png`. It has no event, fact sheet or picture changes, so it has no `json events` or `markdown fact-sheets` block. Decide nothing; stop and report when something does not fit.

## Context

Both thumbnails were made with `--text-pos top` and the flag under the text, which puts the banner over about the top 45% of the square. On France's `bastille_day_1939` that covers the marching column and the Grand Palais, and the empty pavement below stays bare. On Finland's `record_year_1937` the banner runs past the sky and over the mill skyline.

The owner asked for the banner to go over the picture's empty band instead. `event-pack-create` Phase 3 step 5, `TEMPLATE-pack.md`, `event-pack-implement` step 5 and `ep-reviewer` now cover the text and flag placement; those edits ship with this plan. Written by hand on the owner's request: candidate layouts were rendered to `scratch\thumbnail\<pack>-<variant>\` and the owner picked one per pack.

## Decisions

- 2026-11-01, the owner, France: text at the bottom and flag top-left (`--text-pos bottom --overlay-pos top-left`). The subject, the column and the Grand Palais, sits in the upper two thirds. The banner lies on the empty pavement; the flag lies over the sky and trees. Rejected: text at the bottom with the flag under it, whose taller banner covered the soldiers' legs.
- 2026-11-01, the owner, Finland: text at the top and flag top-right (`--text-pos top --overlay-pos top-right`). The subject, the mill skyline and the floating logs, sits in the lower two thirds. The banner and the flag stay in the sky band; only the tip of the tall chimney runs under the banner's lower edge, which the owner saw when picking. Rejected: text at the bottom with the flag under it, which covered the logs and left the empty sky bare; text at the top with the flag bottom-right, which put the flag over the logs.
- Unchanged from the plans that made them: backgrounds, crop `center`, flags (`FRA` `democratic`, `FIN` `neutrality`, game root `C:\Gaming\Steam\steamapps\common\Hearts of Iron IV`) and colours (France `#000066`, Finland `#003580`, text `#FFFFFF`).

## Events

Unchanged: France 20 events, Finland 15 events.

## Pictures

Unchanged.

Thumbnail (france): bastille_day_1939; subject in the upper two thirds; text bottom, flag top-left
Thumbnail (finland): record_year_1937; subject in the lower two thirds; text top, flag top-right

## Editor record

No text changes.

## Kept on judgment

The France pack's three picture warnings, which the owner kept on 2026-11-01 (`archive/2026-11-01-france-first-events.md`). This plan does not touch those pictures:

- `[WARN] picture richelieu_launch_1939: public domain in the United States only (PD-USGov-Military-Navy); the owner decides before a release`
- `[WARN] picture mermoz_disappearance: public domain in the United States only (PD-US); the owner decides before a release`
- `[WARN] picture pcf_dissolution_1939: public domain in the United States only (PD-US-no notice); the owner decides before a release`

## Implementation steps

- [x] 1. Events unchanged: nothing to run.
- [x] 2. Fact sheets unchanged: nothing to run.
- [x] 3. Pictures unchanged: nothing to run. `sources-cache\france\bastille_day_1939.jpg` and `sources-cache\finland\record_year_1937.jpg` are already there from the first plans.
- [x] 4. Make both thumbnails, four commands. Each generator run is expected to print `"status": "success"`, `"workshop_limit_exceeded": false` in `outputs`, and an `"overlay_source"` naming the flag file in the brackets:
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\france\bastille_day_1939.*).FullName --bg-crop center --title "EVENT PACK" --subtitle "FRANCE" --flag-tag FRA --flag-variant democratic --game-dir "C:\Gaming\Steam\steamapps\common\Hearts of Iron IV" --theme "#000066" --banner --banner-color "#000066" --text-color "#FFFFFF" --accent-color "#FFFFFF" --text-pos bottom --overlay-pos top-left --hoi4 --json --out-dirs "scratch\thumbnail\france"` (`FRA_democratic.tga`)
  - `Copy-Item scratch\thumbnail\france\thumbnail.png packs\france\thumbnail.png`
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\finland\record_year_1937.*).FullName --bg-crop center --title "EVENT PACK" --subtitle "FINLAND" --flag-tag FIN --flag-variant neutrality --game-dir "C:\Gaming\Steam\steamapps\common\Hearts of Iron IV" --theme "#003580" --banner --banner-color "#003580" --text-color "#FFFFFF" --accent-color "#FFFFFF" --text-pos top --overlay-pos top-right --hoi4 --json --out-dirs "scratch\thumbnail\finland"` (`FIN_neutrality.tga`)
  - `Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png`
- [x] 5. Pictures unchanged: nothing to run.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack france`, then `-Generate -Pack finland`: expect `Generated pack 'france'` and `Generated pack 'finland'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack france`, then `-Check -Pack finland`: expect `Check OK` from each, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 9. Ship (after the user confirms; another session's uncommitted edits share the skill files and the template, so only this plan's hunks are staged): move this plan to `docs/plans/archive/`, then commit it with the two thumbnails, `.claude/skills/event-pack-create/SKILL.md`, `.claude/skills/event-pack-implement/SKILL.md`, their `.agents/skills/` mirrors, `.claude/agents/ep-reviewer.md` and `docs/plans/TEMPLATE-pack.md`. Commit message: `fix(thumbnails): keep the banner off the picture's subject`. Then run `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- The generator exits 2 or prints `No flag for '<TAG>'`: stop and report the output.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

2026-11-01. `-Check -Pack france`: `Check OK: 1 pack(s), 3 warning(s).` (the three kept picture warnings); `-Check -Pack finland`: `Check OK: 1 pack(s), 0 warning(s).` Both generator runs printed `"status": "success"`, `"workshop_limit_exceeded": false` and the expected `overlay_source` (`FRA_democratic.tga`, `FIN_neutrality.tga`). `-Generate` wrote 0 files for each pack (thumbnails are not generated output). `-ValidateOnly`: `Validation succeeded.`; `-Test`: 210 passed, 0 failed. No deviations.
