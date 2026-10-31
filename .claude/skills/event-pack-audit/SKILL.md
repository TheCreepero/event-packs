---
name: event-pack-audit
description: >-
  Use when auditing an existing Event Packs country pack: the mechanical check and scorecard, a recheck of
  its facts and of its pictures' Commons licences, the texts against the current style guide, and a report
  by severity for the owner's approval. The approved fixes become a READY plan for event-pack-implement.
---

# Event Pack: audit a pack

Finds what an existing pack needs: broken checks, facts that no longer hold, pictures whose licence changed or that were deleted from Commons, texts that fall short of the current style guide, effects out of balance. It writes a report, waits for the owner, then plans only the approved fixes.

## Rules
- The audit changes nothing in `source/` or `packs/`. Fixes reach the pack only through a plan and `event-pack-implement`.
- A licence change or a deleted picture is always Critical: a pack must not ship a picture outside the policy.
- Ask the owner only in Phase 2.

## Phase 0: mechanical
1. `powershell -File .\build.ps1 -Audit -Pack <key>`: the scorecard (words, anchors, options, effects, licence per event) and every `[ERROR]` and `[WARN]`.
2. `powershell -File .\build.ps1 -Check -Pack <key>` must pass on a pack that shipped; a failure is Critical.
3. Note the events and pictures the scorecard flags.

## Phase 1: recheck
1. Dispatch `ep-audit-researcher` with the fact-sheet sections of the events (pasted from `source/<key>/fact-sheets.md`) and one row per picture from `source/<key>/pictures.json` (key, Commons title, page URL, licence).
2. For each picture it marks `RECHECK`, run `powershell -File .\build.ps1 -FetchPicture -Pack <key> -File "<File:...>" -Key <picture key> -DryRun`: `REJECTED` is Critical.
3. Dispatch `ep-editor` with `source/<key>/events.json` as the draft, `source/<key>/fact-sheets.md` as the fact sheet and the event keys: every REWRITE or REJECT is Important.

## Phase 2: report
Write the report into a new plan, `docs/plans/<YYYY-MM-DD>-<key>-audit.md` from `docs/plans/TEMPLATE-pack.md` with `Kind: audit fixes`, under a `## Audit report` heading placed after "Context":
- **Critical**: failing checks, pictures outside the policy or gone from Commons, facts the researcher marked `DROP`.
- **Important**: facts to `FIX`, editor rewrites and rejects, effects that read wrong against their option.
- **Minor**: warnings, crops, wording the editor kept but flagged.
- **Intentionally unchanged**: what was considered and is fine.

Show the owner the report and stop until they say which fixes to make. Record their answer in "Decisions".

## Phase 3: plan the fixes
1. Build the plan's `json events` block from the current `source/<key>/events.json` with only the approved fixes; corrected facts go into the `markdown fact-sheets` block with their sources.
2. A replaced picture follows Phase 3 of `event-pack-create`; its new row goes into "Pictures" and step 3.
3. Send changed texts through `ep-editor` until KEEP, as in `event-pack-create` Phase 4.
4. Gate as in `event-pack-create` Phase 5, set `Status: READY`, and hand off to `event-pack-implement`.
