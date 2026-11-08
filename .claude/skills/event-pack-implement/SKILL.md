---
name: event-pack-implement
description: >-
  Use when carrying out a finished Event Packs plan file from docs/plans (Status READY or IN PROGRESS):
  "implement", "apply" or "continue" a pack plan, or a plan path given as the argument. Dispatches the
  ep-implementer subagent, verifies its result, has ep-reviewer review it, and hands the commit to the shared
  ship skill. Does no research and writes no text; for those use event-pack-create or event-pack-audit.
---

# Event Pack: implement a plan

Carries out one plan written by `event-pack-create` or `event-pack-audit`. The plan holds every text, effect, picture and fact sheet, so the work is mechanical; `ep-implementer` does it in a fresh context, and this session verifies and hands the ship to `ship`.

## Rules
- **The plan is the only source.** No new text, no rewording, no other picture, no research. A plan that looks wrong goes back to its planner (section 4).
- **The pack changes only through `build.ps1`**, run by the implementer.
- `build.ps1`, `tools/`, `data/`, the tests, the skills, the agents, `AGENTS.md` and `docs/style-guide.md` are not edited.
- The commit and the wiki push wait for the owner's word, and go through the shared `ship` skill (section 5).

## 1. Find the plan
1. Take the plan path from the request. With none, `Grep -n '^Status:'` across `docs/plans/` for `READY` or `IN PROGRESS`; with more than one or none, ask the owner which.
2. `PLANNING`: stop; the plan belongs to its planning skill. `READY` or `IN PROGRESS`: section 2. `DONE`: section 3.

## 2. Dispatch
Dispatch `ep-implementer` with the prompt `Carry out docs/plans/<file>.md` and nothing else. One plan per dispatch. Antigravity: pass the brief's path to `invoke_subagent`; where no subagent can be dispatched, read the brief and follow it yourself.

## 3. Verify
The report is a claim. Check:
1. `powershell -File .\build.ps1 -Check -Pack <key>` ends `Check OK` (it also checks the bundle that holds the pack: `Bundle 'all': ... 0 error(s)`), and every `[WARN]` is in the plan's "Kept on judgment".
2. `powershell -File .\build.ps1 -ValidateOnly` ends `Validation succeeded.`; `powershell -File .\build.ps1 -Test` has no failed test.
3. `git status --short` lists only `source/<key>/`, `packs/<key>/`, `research/<key>/` (the plan's dossier, and the `Used:` and `Checked:` lines the plan added), `wiki/Event-Pack-<Country>.md`, `assets/thumbnail.json` when the plan made a thumbnail, and the plan; and, for a pack that changes the bundle, `tools/HoiModBuild.json` (the new member), `source/all/workshop-intro.bbcode` and the regenerated `packs/all/WORKSHOP_DESCRIPTION_GUIDELINES.md`.
4. The plan says `Status: DONE`, every box but the ship step is ticked.
5. Look at the thumbnail: open `packs/<key>/thumbnail.png` with the Read tool when the plan made one, and nothing else (the DDS previews of `-PreviewPictures` add nothing here: step 6's renders show each event picture at its in-game crop). A thumbnail whose title plate or flag covers the picture's subject goes back to the planner.
6. Look at the event renders the plan's render step wrote to `artifacts/workshop-images/<key>/`, one per event, drawn as the game's event window. Always open `contact-sheet-NOT-FOR-WORKSHOP` (every event as a small card under its file stem, on one image; it is for this check and is not uploaded) and `00-overview`. Open an event's own render only when its hash differs from the one the create skill's rehearsal saved in `scratch\render-hashes-<key>.txt` (an unchanged event gives the same file). List the differing renders with this one statement; it lists every render when the file does not exist:
   `$saved = @{}; if (Test-Path scratch\render-hashes-<key>.txt) { Get-Content scratch\render-hashes-<key>.txt | ForEach-Object { $p = $_ -split '  ', 2; $saved[$p[1]] = $p[0] } }; Get-ChildItem artifacts\workshop-images\<key> -File | Where-Object { $_.BaseName -match '^(?!00-)\d{2,}-' -and $saved[$_.Name] -ne (Get-FileHash -Algorithm SHA256 -LiteralPath $_.FullName).Hash } | ForEach-Object Name`
   A title or option running into the text below, a text that reads wrong in the window, a picture that sits badly or a crop that cuts the subject goes back to the planner. The event renders and the overview are what the owner uploads to the Workshop page (`event-pack-release`).

Then dispatch `ep-reviewer` with the task as the owner asked it, the plan path and the summary lines of the three commands. Fix nothing yourself: Critical or Important findings go back to the planner (section 4).

## 4. When it stops
The implementer reported `STOPPED`, a check failed, or the reviewer found a problem. Leave the files, report to the owner (the step, the exact output, what the plan would need), and stop. An intro that step 6's `Test-WorkshopText.ps1` fails goes back through `workshop-editor` before the plan is changed (a plan change, as below), because the editor judged it without that check. Once the plan is corrected, dispatch again: the implementer resumes at the first unticked step.

## 5. Report and ship
Report: the `-Check` line, the files changed, the reviewer's verdict, and that the plan is ready to ship. Unless the owner has already reported the in-game look passed, add the pack change's row to the Manager's `docs/ingame-verification-pending.md` now, citing the plan: the agent gets no turn at the end of a session, and a later `ship` then finds the row instead of adding a second. Offer an in-game look: `powershell -File .\build.ps1 -DevLink -Pack <key>`, then in the game console `event ep_<tag>.<id>` for each new event; or enable "Event Packs Test (dev only)" (written by `build.ps1 -TestMod -Pack <key>`) and run `ep_<tag>_all` to fire every event of the pack. To see the pack inside the bundle item, `powershell -File .\build.ps1 -DevLink -Pack all` loads every member from the git-ignored `.devlink/` folder (`-DevLink -CheckLinks -Pack all` first, after a `git checkout` or `pull`); the bundle and the single pack of the same release load together without a duplicate [LOAD-022]. Then stop.

On the owner's word ("ship"), the shared `ship` skill takes over: the commit, the push, the wiki push (`push-wiki.ps1 -CommitMessage`), archiving the plan and the in-game row of the Manager's `docs/ingame-verification-pending.md` when the owner has not checked the change in game. Before it runs, this skill does what is the pack's:
1. Tick the plan's ship box.
2. Give `ship` the commit message of the plan's ship step as the subject, and the files of section 3.3 as this session's files, together with the plan (at its archived path) and the `Used:` and `Checked:` lines the planning session wrote under `research/<key>/`.

After the ship, end the report with the command for the release in a new session, which needs none of this one's context: `/clear`, then `/event-pack-release <pack>` when you publish.

When the owner later reports the in-game look passed, the row comes out of `docs/ingame-verification-pending.md`, as that file's own text says: "a row comes out when the user reports the check".

Publishing to the Workshop is a separate decision: `event-pack-release`.
