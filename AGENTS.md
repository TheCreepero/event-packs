# Event Packs - Agent Rules

Shared rules for every mod in this tree (file encodings, build commands, engine knowledge, git) are in the Modding Manager's `../../AGENTS.md`. `CLAUDE.md` and `GEMINI.md` import this file.

## What this mod is
- Small packs of historical flavor events, one pack per country, each published as its own Steam Workshop item "Event Pack: <Country>". One repository, many packs: `tools/HoiModBuild.json` lists them under `packages`, and every `build.ps1` action takes `-Pack <key>`.
- Each pack is a mod root of its own under `packs/<key>/` and stands alone: no pack requires or names another.
- Hand-written source in `source/<key>/`; everything a pack ships except `descriptor.mod` and `thumbnail.png` is generated from it. Layout and fields: `docs/source-format.md`.

## Mod invariants
- `packs/<key>/` changes only through `build.ps1 -Generate` and `-ConvertPictures`; `source/<key>/pictures.json` only through `-FetchPicture`. A hook refuses hand edits.
- A namespace (`ep_<tag>`), event id or guard flag never changes once a pack is released: saves hold the flags.
- Pictures come from Wikimedia Commons, licensed public domain (with the `PD-` reason Commons gives), CC0 or CC BY, and only through `-FetchPicture`, which decides the licence. CC BY credits are generated into the Workshop description and the wiki.
- Effects stay within `data/effect-caps.json`: flavor first, small numbers [SCR-088] [SCR-090].
- Every claim in an event text is in its fact-sheet section with a source; the `ep-editor` agent passes every text before a plan is READY. Voice: `docs/style-guide.md`.
- Events are `is_triggered_only` and fire from a weekly anchor with a guard flag, a date window and a weekly chance [SCR-080] [SCR-089] [SCR-091].
- Nothing sits in a pack folder that the source does not account for: `-Check` fails on any other file.
- Work goes plan first: a skill writes a READY plan in `docs/plans/`, `event-pack-implement` carries it out, the commit waits for the user.

## Commands beyond build.ps1
- `build.ps1 -NewPack -Pack <key> -Tag <TAG> -DisplayName "<Country>"`, `-Generate [-Pack] [-DryRun]`, `-FetchPicture -Pack -File -Key [-Crop] [-Tone] [-DryRun]`, `-ConvertPictures [-Pack] [-Force]`, `-PreviewPictures [-Pack]`, `-Check [-Pack]`, `-Audit -Pack`, `-SyncMirrors`. `Get-Help .\build.ps1` lists the parameters; `tools/EventPacks.ps1` holds the code.
- `-ConvertPictures` needs Python 3 with Pillow.

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
