---
name: event-pack-create
description: >-
  Use when planning a new Event Packs country pack ("Event Pack: <Country>") or new events for an existing
  pack: research through subagents, picture search with licence checks, event texts written from sourced
  fact sheets and passed by the independent editor, and a self-contained READY plan in docs/plans. Ends with
  a hand-off; event-pack-implement carries the plan out.
---

# Event Pack: create a pack or add events

Plans a pack or new events, down to every text, effect and picture, in one plan file that `event-pack-implement` carries out. Read `docs/source-format.md` and `docs/style-guide.md` before Phase 4.

## Rules
- **Every fact comes from the dossier.** A detail the historical researcher did not source does not enter a text, however plausible.
- **The licence is the tool's decision.** A picture enters the plan only after `build.ps1 -FetchPicture ... -DryRun` printed `ACCEPTED` for it.
- **The editor passes every text.** No plan goes READY with an event the editor has not returned KEEP for in its latest round.
- **The shipped pack is not touched here.** This skill writes the plan, the dossier under `research/<key>/` and files under `scratch/`; `source/` and `packs/` change when the plan is implemented. The one exception is `-NewPack` and the thumbnail of a brand-new pack (Phase 0).
- **Dossiers are kept.** Every dossier stays in `research/<key>/`, never deleted or trimmed, also when the plan is dropped: the candidates not chosen and the facts not used are where the next expansion of the pack starts. It is committed with the plan when the plan ships, or on the owner's word.
- Ask the owner only the questions in Phase 0 and Phase 2.

## Phase 0: scope
1. Ask the owner, in one message: the country (and its tag if not obvious), the period (default: 1936 to the start of its war, plus its first months), the number of events (default 10 to 15), kinds to stress or avoid, and anything the pack must not touch. Record the answers in the plan's "Decisions".
2. A new pack: confirm the tag with the `hoi4-vanilla-lookup` skill (`Get-HoiCountry`), then `powershell -File .\build.ps1 -NewPack -Pack <key> -Tag <TAG> -DisplayName "<Country>"`. Make its thumbnail with the `mod-thumbnail-generator` skill: a loading screen from its catalog that suits the country, title `EVENT PACK`, subtitle the country in capitals, written to `packs/<key>/thumbnail.png` (under 1 MB). Write `source/<key>/workshop-intro.bbcode`: two or three plain sentences about the pack, and the info lines `-NewPack` drafted.
3. Copy `docs/plans/TEMPLATE-pack.md` to `docs/plans/<YYYY-MM-DD>-<key>-<what>.md` and fill the header, "Context" and "Decisions". An existing pack: note its last event id; new ids continue from it.

## Phase 1: research
1. If `research/<key>/` exists, read its dossiers. Their candidates without a `Used:` mark that fit the period and kinds are candidates for this plan too; note their keys.
2. Dispatch `ep-historical-researcher` with: the country, tag, period, number of candidates (about twice the events wanted, less the usable earlier candidates), the kinds from Phase 0, the titles of the pack's existing events, every candidate of the earlier dossiers as key, date and one line, and the path `research/<key>/<YYYY-MM-DD>-dossier.md` to write (with `-2` and up when that day already has one). Wait for its summary.

## Phase 2: choose
Read the new dossier. Drop candidates whose key facts are `UNVERIFIED` or that cannot fill 40 words with sourced detail. Show the owner the rest, with the usable earlier candidates marked as such, as a short list (key, date, kind, one line) with your recommendation of which to keep and why, and take their choice.

## Phase 3: pictures
1. Dispatch `ep-picture-researcher` with the chosen events: key, date, place and the dossier's picture ideas.
2. For each event, run `powershell -File .\build.ps1 -FetchPicture -Pack <key> -File "<File:...>" -Key <picture key> -DryRun` on its first proposal; on `REJECTED`, try the next. An event with no accepted file gets a vanilla picture (`vanilla:GFX_report_event_<name>`, found with `Find-HoiUsage` of the `hoi4-vanilla-lookup` skill) and a note in the plan.
3. Choose crop and tone per picture: `warm` for black-and-white photographs (it matches the game's own pictures), `none` for colour art; a crop other than 50 only where the researcher's crop note asks for it.
4. Fill the plan's "Pictures" table with what the dry runs printed.

## Phase 4: write
1. Copy each chosen event's section, from whichever dossier holds it, into the plan's `markdown fact-sheets` block, keeping only the facts with sources.
2. Write the events into the `json events` block: for an existing pack, start from the current `source/<key>/events.json` and add to it. Follow `docs/source-format.md` for every field and `docs/style-guide.md` for every text. Effects small and matching their option; a timed idea only where the event earns one.
3. Dispatch `ep-editor` with the plan path, the path of every dossier that holds a chosen event and the event keys. Apply every REWRITE as given; drop or replace a REJECT (back to Phase 2 for a replacement). Record each round in "Editor record". Send the changed events back to the editor until every event is KEEP; at most three rounds, then ask the owner.

## Phase 5: gate
1. Rehearse the plan without touching the repository: `robocopy . scratch\rehearsal /MIR /XD .git scratch artifacts sources-cache`, then in `scratch\rehearsal` run steps 1 to 6 of the plan exactly as written (they write only the copy). Every step must give what it says to expect; fix the plan, not the copy, and rehearse again.
2. Fill "Events", list in "Kept on judgment" any `[WARN]` the rehearsal's `-Check -Pack <key>` printed that stays, and set `Status: READY`.
3. Delete `scratch/rehearsal/`.
4. Mark each event of the READY plan in the dossier that holds it: a line `Used: <plan file name>` right under its `## <key>` heading. Change nothing else in a dossier; a candidate the owner or the editor dropped stays unmarked, as the researcher wrote it.

## Phase 6: hand off
Report to the owner: the plan path, the dossier path with how many candidates it keeps for later, the events with their titles, the picture licences (how many PD, CC0, CC BY), the editor's totals, and that `event-pack-implement` carries it out. Then stop.

Antigravity: pass each agent brief's path to `invoke_subagent`; where no subagent can be dispatched, read the brief and do its work yourself, keeping the editor's work in a separate pass that reads only the draft, the fact sheet and the style guide.
