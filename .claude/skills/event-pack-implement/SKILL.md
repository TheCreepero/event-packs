---
name: event-pack-implement
description: >-
  Use when carrying out a finished Event Packs plan file from docs/plans (Status READY or IN PROGRESS):
  "implement", "apply", "continue" or "ship" a pack plan, or a plan path given as the argument. Dispatches the
  ep-implementer subagent, verifies its result, has ep-reviewer review it, and ships on the owner's word. Does
  no research and writes no text; for those use event-pack-create or event-pack-audit.
---

# Event Pack: implement a plan

Carries out one plan written by `event-pack-create` or `event-pack-audit`. The plan holds every text, effect, picture and fact sheet, so the work is mechanical; `ep-implementer` does it in a fresh context, and this session verifies and ships.

## Rules
- **The plan is the only source.** No new text, no rewording, no other picture, no research. A plan that looks wrong goes back to its planner (section 4).
- **The pack changes only through `build.ps1`**, run by the implementer.
- `build.ps1`, `tools/`, `data/`, the tests, the skills, the agents, `AGENTS.md` and `docs/style-guide.md` are not edited.
- The commit and the wiki push wait for the owner's word (section 5).

## 1. Find the plan
1. Take the plan path from the request. With none, `Grep -n '^Status:'` across `docs/plans/` for `READY` or `IN PROGRESS`; with more than one or none, ask the owner which.
2. `PLANNING`: stop; the plan belongs to its planning skill. `READY` or `IN PROGRESS`: section 2. `DONE`: section 3.

## 2. Dispatch
Dispatch `ep-implementer` with the prompt `Carry out docs/plans/<file>.md` and nothing else. One plan per dispatch. Antigravity: pass the brief's path to `invoke_subagent`; where no subagent can be dispatched, read the brief and follow it yourself.

## 3. Verify
The report is a claim. Check:
1. `powershell -File .\build.ps1 -Check -Pack <key>` ends `Check OK`, and every `[WARN]` is in the plan's "Kept on judgment".
2. `powershell -File .\build.ps1 -ValidateOnly` ends `Validation succeeded.`; `powershell -File .\build.ps1 -Test` has no failed test.
3. `git status --short` lists only `source/<key>/`, `packs/<key>/`, `research/<key>/` (the plan's dossier and its `Used:` marks), `wiki/Event-Pack-<Country>.md` and the plan.
4. The plan says `Status: DONE`, every box but the ship step is ticked.
5. Look at each new picture: `powershell -File .\build.ps1 -PreviewPictures -Pack <key>` writes PNG copies of the pack's DDS pictures to `scratch/preview/<key>/`; open each with the Read tool, and `packs/<key>/thumbnail.png` when the plan made one. A crop that cuts the subject goes back to the planner, and so does a thumbnail whose banner or flag covers the picture's subject while an empty band stays bare.

Then dispatch `ep-reviewer` with the task as the owner asked it, the plan path and the summary lines of the three commands. Fix nothing yourself: Critical or Important findings go back to the planner (section 4).

## 4. When it stops
The implementer reported `STOPPED`, a check failed, or the reviewer found a problem. Leave the files, report to the owner (the step, the exact output, what the plan would need), and stop. Once the plan is corrected, dispatch again: the implementer resumes at the first unticked step.

## 5. Report and ship
Report: the `-Check` line, the files changed, the reviewer's verdict, and that the plan is ready to ship. Offer an in-game look: `powershell -File .\build.ps1 -DevLink -Pack <key>`, then in the game console `event ep_<tag>.<id>` for each new event. Then stop.

On the owner's word:
1. Tick the ship box.
2. Move the plan to `docs/plans/archive/`: `git mv` when tracked, `Move-Item` and `git add` when new.
3. Commit the files from section 3.3 with the plan at its archived path, with the message the ship step gives.
4. `powershell -File .\wiki\push-wiki.ps1`. If it fails, report the output; the commit stands.

Publishing to the Workshop is a separate decision: `event-pack-release`.
