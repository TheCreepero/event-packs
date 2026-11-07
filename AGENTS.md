# Event Packs - Agent Rules

Shared rules for every mod in this tree (file encodings, build commands, engine knowledge, git) are in the Modding Manager's `../../AGENTS.md`. `CLAUDE.md` and `GEMINI.md` import this file.

## What this mod is
- Small packs of historical flavor events, one pack per country, each published as its own Steam Workshop item "Event Pack: <Country>", and all of them together as one bundle item "Immersive Events Expanded". One repository, many packs: `tools/HoiModBuild.json` lists them under `packages`, and every `build.ps1` action takes `-Pack <key>`.
- Each pack is a mod root of its own under `packs/<key>/` and stands alone: no pack requires or names another.
- The bundle is the package `all`: `packs/all/` holds only its `descriptor.mod`, `thumbnail.png` and the generated `WORKSHOP_DESCRIPTION_GUIDELINES.md`; `source/all/workshop-intro.bbcode` is hand-written. Its content is every member's, added by the build engine from the `members` list of `tools/HoiModBuild.json` (nothing is committed twice). `-NewPack` adds a new country to `members`, and `-Check` fails for a pack that is not a member. A pack's upload also updates the bundle (`Publish-Mod.ps1` does both in one run, once the bundle has a `remote_file_id`).
- Hand-written source in `source/<key>/`; everything a pack ships except `descriptor.mod` and `thumbnail.png` is generated from it. Layout and fields: `docs/source-format.md`.
- The historical researcher's dossiers stay in `research/<key>/`, every candidate with its sourced facts, used or not: a pack's next events start from them. Never delete or trim one. The only additions are a candidate's `Used:` line and its `Checked:` lines: once a candidate is checked, its facts stay as the researcher wrote them, and the checked ones are where its newest `Checked:` line points.

## Mod invariants
- `packs/<key>/` changes only through `build.ps1 -Generate` and `-ConvertPictures`, its `thumbnail.png` only through the Manager's `New-HoiThumbnail.ps1 -Apply` from `assets/thumbnail.json` (a plan's thumbnail step); `source/<key>/pictures.json` only through `-FetchPicture` and `-RemovePicture`. The bundle's `packs/all/WORKSHOP_DESCRIPTION_GUIDELINES.md` changes only through `-Generate`, its `thumbnail.png` only through `New-HoiThumbnail.ps1 -Pack all -Apply`. A hook refuses hand edits.
- A namespace (`ep_<tag>`), event id or guard flag never changes once a pack is released: saves hold the flags.
- Pictures come from Wikimedia Commons, licensed public domain (with the `PD-` reason Commons gives), CC0 or CC BY, and only through `-FetchPicture`, which decides the licence with the Manager's shared gate (`tools/HoiImageSources.ps1`, a synced copy). Credits are generated into the pack's wiki page; the Workshop description carries no Wiki or GitHub link, so the wiki is pushed with the pack but is not referenced from the page. Only `packs/<key>/thumbnail.png` also carries the game's own interface art and fonts (border, title plate, flag), which the Manager's renderer reads from the install around one of the pack's pictures.
- Effects stay within `data/effect-caps.json`: flavor first, small numbers [SCR-088] [SCR-090].
- Every claim in an event text is in its fact-sheet section with a source and the quote of its page, checked by `ep-audit-researcher` before the text is written; the `ep-editor` agent passes every text before a plan is READY. Voice: `docs/style-guide.md`.
- Events are `is_triggered_only` and fire from a weekly anchor with a guard flag, a date window and a weekly chance [SCR-080] [SCR-089] [SCR-091].
- The owner's rule: do not assume the war starts on its historical date; the aggressor may attack on a different date in each game. An event about a war, or about preparing for one, is gated on the game state (`fire.trigger`: the country at war with the enemy, or the situation that shows the war is near), never on a date window alone. Its text names no historical date for the war's start or for the preparations and stays true on whatever day it fires. A peacetime event keeps its date window and is blocked once its country is at war. The trigger is checked with `Find-HoiDoc` and `Find-HoiUsage` before it is written.
- A check a plan promises for later is done before the plan is READY: the `trigger-checker` agent resolves every `fire.trigger` against the game files, and an event it leaves `OPEN` waits for its probe result or the owner's decision.
- Nothing sits in a pack folder that the source does not account for: `-Check` fails on any other file.
- Work goes plan first: a skill writes a READY plan in `docs/plans/`, `event-pack-implement` carries it out, the commit waits for the user.

## Commands beyond build.ps1
- `build.ps1 -NewPack -Pack <key> -Tag <TAG> -DisplayName "<Country>"`, `-Generate [-Pack] [-DryRun]`, `-FetchPicture -Pack -File -Key [-Crop] [-Tone] [-DryRun]`, `-RemovePicture -Pack -Key [-DryRun]`, `-ConvertPictures [-Pack] [-Force]`, `-PreviewPictures [-Pack]`, `-Check [-Pack]`, `-Audit -Pack`, `-SyncMirrors`, `-TestMod [-Pack] [-ModDir] [-DryRun]`. `Get-Help .\build.ps1` lists the parameters. Run the tools; don't read `tools/EventPacks.ps1` or `tools/HoiModBuild.ps1` (181 KB, about 45k tokens together; a read asks the user first). If one seems broken, report the command and its output.
- `-TestMod` writes the unpublished mod "Event Packs Test (dev only)" to `artifacts/event_packs_test/` with its launcher file: console commands `ep_<tag>_all` (fire every event of the pack to its country) and `ep_<tag>_reset` (clear the guard flags) [AUTO-043]. It never touches a pack. Each run replaces the whole mod: with `-Pack`, only that pack's commands remain. It is a dev-only tool beside the bundle: use it for the console commands, and `build.ps1 -DevLink -Pack all` to load the real bundle item (the bundle and a single pack of the same release load together without a duplicate [LOAD-022]; a pack of another release beside the bundle has not been checked). `-DevLink -CheckLinks -Pack all` reports links that a `git checkout` or `pull` broke.
- `-ConvertPictures` needs Python 3 with Pillow.
- `-RenderEvents [-Pack] [-GameDir]` draws every event of a pack as the game's event window over a blurred vanilla loading screen (`tools/render_event_cards.py`, from the game's own window art and fonts; 16:9, one size per pack), plus `00-overview` with up to 7 of them thrown on a pile, into `artifacts/workshop-images/<key>/` (every image has the country's flag in the game's flag frame at the top right), for the owner to upload to the Workshop page; `[WARN]` marks a title or option that overflows its box [GUW-027]. Needs Python 3 with Pillow and the game installed.

## Read when
| Task | Read |
|---|---|
| A new pack or new events | skill `event-pack-create` |
| Checking an existing pack | skill `event-pack-audit` |
| Carrying out a READY plan | skill `event-pack-implement` |
| Publishing a pack | skill `event-pack-release` (and the shared `hoi4-mod-release`) |
| Writing or judging event text | `docs/style-guide.md` |
| The source files and what is generated | `docs/source-format.md` |

## Compacting
Keep: the pack, the plan path and its `Status:`, the current phase or step, the last `-Check` line. Drop: dossier contents, raw search results, editor reports once applied to the plan.

## Engine Knowledge
- Engine facts live in the Modding Manager's register, reached through the user-level `hoi4-modding-knowledge` skill: search it before a new kind of file and before asking for a game launch, cite ids here, never write a fact into this repository.
- Topics this mod leans on: `script-language`, `localisation`, `gui-sprites-and-fonts`, `loading-and-overrides`.
- `tests/Knowledge.Tests.ps1` runs the register's audit for this repository; it is a copy the Manager keeps current.
