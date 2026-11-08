---
name: event-pack-audit
description: >-
  Use when auditing an existing Event Packs country pack: the mechanical check and scorecard, a recheck of
  its facts and of its pictures' Commons licences, the texts against the current style guide, the Workshop intro against the page
  standard, and a report by severity for the owner's approval. The approved fixes become a READY plan for event-pack-implement.
---

# Event Pack: audit a pack

Finds what an existing pack needs: broken checks, facts that no longer hold, pictures whose licence changed or that were deleted from Commons, texts that fall short of the current style guide, effects out of balance. It writes a report, waits for the owner, then plans only the approved fixes.

## Rules
- The audit changes nothing in `source/` or `packs/`. Fixes reach the pack only through a plan and `event-pack-implement`. Besides its plan, it writes only the `Checked:` lines of Phase 3 into `research/<key>/`.
- A licence change or a deleted picture is always Critical: a pack must not ship a picture outside the policy.
- Ask the owner only in Phase 2.

## Phase 0: mechanical
1. `powershell -File .\build.ps1 -Audit -Pack <key>`: the scorecard (words, anchors, options, effects, licence per event) and every `[ERROR]` and `[WARN]`.
2. `powershell -File .\build.ps1 -Check -Pack <key>` must pass on a pack that shipped; a failure is Critical. The check includes the bundle that holds the pack: the pack must be a member of `all` in `tools/HoiModBuild.json`, the bundle's intro (`source/all/workshop-intro.bbcode`) must name its country, and the generated bundle page (`packs/all/WORKSHOP_DESCRIPTION_GUIDELINES.md`) must list it with its event count; an error there is Critical, and its fix is a plan step on the bundle's source, never on the generated page.
3. `powershell -File ..\..\Scripts\Workshop\Test-WorkshopText.ps1 -Mod "Event Packs" -Pack <key>`: the Workshop page as a whole (wording, page order, shared lines, images, regions). A line it reports for a published pack is Important.
4. Note the events and pictures the scorecard flags.

## Phase 1: recheck
1. Dispatch `ep-audit-researcher` with the pack, the path `source/<key>/fact-sheets.md` and the event keys, at most five events per agent, all in parallel. Take the keys from a `Grep` of `^## ` in that file (headings only); do not read `fact-sheets.md` or paste a section. Send one of them, or one more, the picture keys instead (a `Grep` of `"key":` in `source/<key>/pictures.json`, matches only): the agent reads their rows (Commons title, page URL, licence) from that file itself, so name the file's path in the prompt.
2. For each picture it marks `RECHECK`, run `powershell -File .\build.ps1 -FetchPicture -Pack <key> -File "<File:...>" -Key <picture key> -DryRun`: `REJECTED` is Critical.
3. Dispatch `trigger-checker` (the Modding Manager's `Agents/trigger-checker.md`) with `source/<key>/events.json`, all event keys and the pack's tag: an event it marks `FIX` cannot fire or says something false, which is Critical for a war event and Important for any other; an `OPEN` is Important and names its probe.
4. Dispatch `ep-editor` with `source/<key>/events.json` as the draft, `source/<key>/fact-sheets.md` as the fact sheet and the event keys: every REWRITE or REJECT is Important.
5. Dispatch `workshop-editor` in mod mode (the Modding Manager's `docs/workshop-text-style.md` (`..\..\docs\workshop-text-style.md`), section "Auditing a page") with the mod folder (the repository root) and `source/<key>/workshop-intro.bbcode` as the text, so that the intro is judged against `source/<key>/events.json` and `pictures.json`: a count, a claim about the pictures or the effects that the files do not show, a wording that differs from the other packs' intros. Every REWRITE or REJECT is Important.

## Phase 2: report
Write the report into a new plan, `docs/plans/<YYYY-MM-DD>-<key>-audit.md` from `docs/plans/TEMPLATE-pack.md` with `Kind: audit fixes`, under a `## Audit report` heading placed after "Context":
- **Critical**: failing checks, pictures outside the policy or gone from Commons, facts the researcher marked `DROP`.
- **Important**: facts to `FIX`, editor rewrites and rejects (of the events and of the Workshop intro), effects that read wrong against their option.
- **Minor**: warnings, crops, wording the editor kept but flagged.
- **Intentionally unchanged**: what was considered and is fine.

Fill the plan's "Fact verification" from Phase 1 as `event-pack-create` Phase 3a step 3 does, per event, and its "Trigger verification" with the checker's verdict per event.

Show the owner the report and stop until they say which fixes to make. Record their answer in "Decisions", and mark each `FIX` or `DROP` they decline as declined in "Fact verification".

## Phase 3: plan the fixes
1. Put only the changed events into the plan's `json events` block: each event an approved fix changes, as its whole object from the current `source/<key>/events.json` with the fixes applied and its `id` unchanged, under `"pack"`, `"tag"` and `"mergeById": true` (`docs/source-format.md`, "Plans"). The events no fix touches stay out of the block; template step 1 (`build.ps1 -ApplyPlan`) puts each block event in place of the event of the same `id` and leaves the others and their order as they are, and refuses an `id` the pack does not have (a new event is `event-pack-create`'s). A changed idea goes into an `"ideas"` list the same way, by its key. Corrected facts go into the `markdown fact-sheets` block, only the changed sections, with the sources and quotes the researcher returned. An audit that rechecked every fact of the events below the pack's `factQuotesFromId` gives every one of them a quote and removes the field with `"factQuotesFromId": null` in the block. Run `powershell -File .\build.ps1 -Check -Plan docs\plans\<file>.md` and fix every `[ERROR]` before step 3.
2. A replaced picture follows Phase 3 of `event-pack-create`; its new row goes into "Pictures" and step 3. When it was the thumbnail's background (`packs.<key>.background` in `assets/thumbnail.json`), step 4 points that entry at another picture of the pack, with its crop, and renders the thumbnail again; otherwise "Thumbnail" says unchanged.
3. Send changed texts through `ep-editor` until KEEP, as in `event-pack-create` Phase 4; then, after the last round, send every event whose text changed in any round back through `trigger-checker` (its questions 3 and 4: is the text false in a case the trigger allows; do the text's dates fit the window), not only an event that had a `FIX`, and record its verdict in "Trigger verification"; a text it makes you change goes back through the editor, for at most three rounds, as in `event-pack-create` Phase 4 step 4, and a round that is not settled goes into the report, not into a question. A fix of the Workshop intro goes into the plan as its "Pack intro" line, which template step 6 writes to `source/<key>/workshop-intro.bbcode` (never to the generated `packs/<key>/WORKSHOP_DESCRIPTION_GUIDELINES.md`); `workshop-editor` judges it in the rehearsal copy of the gate (Phase 5 step 1 of `event-pack-create`), until KEEP. A third round that is not KEEP goes into the report, not into a question.
4. Gate as in `event-pack-create` Phase 5 and set `Status: READY`.
5. Mark the dossiers. Find every `research/<key>/` section (dossier and addendum alike) that has the key of an event Phase 1 rechecked and a `Used:` line. Below its `Used:` line and any earlier `Checked:` line, add: `Checked: <plan file name>, <K> kept, <F> fixed, <D> dropped. The facts below are the researcher's notes, not the checked ones: see source/<key>/fact-sheets.md.` The counts are that event's verdicts from the plan's "Fact verification", where a declined fix or drop stays listed as declined. Change nothing else in a dossier.
6. Hand off to `event-pack-implement`. End the report with the command for a new session, which needs none of this one's context: `/clear`, then `/event-pack-implement docs/plans/<file>.md`.
