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
- **Every fact is verified on its page.** A fact enters the fact sheet only from a Phase 3a `KEEP` or `FIX`, with its source and its quote; a detail no checked page states does not enter a text, however plausible.
- **The licence is the tool's decision.** A picture enters the plan only after `build.ps1 -FetchPicture ... -DryRun` printed `ACCEPTED` for it.
- **The editor passes every text.** No plan goes READY with an event the editor has not returned KEEP for in its latest round.
- **The shipped pack is not touched here.** This skill writes the plan, the dossier under `research/<key>/` and files under `scratch/`; `source/` and `packs/` change when the plan is implemented. The one exception is `-NewPack` for a brand-new pack (Phase 0); its thumbnail is made at implementation (Phase 3).
- **Dossiers are kept.** Every dossier stays in `research/<key>/`, never deleted or trimmed, also when the plan is dropped: the candidates not chosen and the facts not used are where the next expansion of the pack starts. The only additions are the `Used:` and `Checked:` lines of Phase 5.4. It is committed with the plan when the plan ships, or on the owner's word.
- Ask the owner only the questions in Phase 0 and Phase 2.

## Phase 0: scope
1. Ask the owner, in one message: the country (and its tag if not obvious), the period (default: 1936 to the start of its war, plus its first months), the number of events (default 10 to 15), kinds to stress or avoid, and anything the pack must not touch. Record the answers in the plan's "Decisions".
2. A new pack: confirm the tag with the `hoi4-vanilla-lookup` skill (`Get-HoiCountry`), then `powershell -File .\build.ps1 -NewPack -Pack <key> -Tag <TAG> -DisplayName "<Country>"`; it gives the pack the placeholder thumbnail, which Phase 3 replaces. Write `source/<key>/workshop-intro.bbcode`: two or three plain sentences about the pack, and the info lines `-NewPack` drafted.
3. Copy `docs/plans/TEMPLATE-pack.md` to `docs/plans/<YYYY-MM-DD>-<key>-<what>.md` and fill the header, "Context" and "Decisions". An existing pack: note its last event id; new ids continue from it.

## Phase 1: research
1. If `research/<key>/` exists, read its dossiers. Their candidates without a `Used:` mark that fit the period and kinds are candidates for this plan too; note their keys. A candidate with a `Checked:` line has been checked on its pages; judge it by the place its newest `Checked:` line names, not by the facts written under it. A fact sheet there holds every checked fact. A plan's "Fact verification" holds only the fixes and drops, so the dossier facts it does not name were kept. If chosen, it still goes through Phase 3a.
2. Candidates wanted: about one and a half times the events wanted, less the usable earlier candidates. Split them into runs of at most 12, each covering its own slice of the period (for 30: 1936, 1937-1938, 1939-1940), and dispatch one `ep-historical-researcher` per run, all in parallel, each with: the country, tag, its period slice, its number of candidates, the kinds from Phase 0, the titles of the pack's existing events, every candidate of the earlier dossiers as key, date and one line, and its own path `research/<key>/<YYYY-MM-DD>-dossier.md` (with `-2` and up for the other runs, or when that day already has one). Wait for every summary.

## Phase 2: choose
Read the new dossiers. Drop candidates whose key facts are `UNVERIFIED`, that cannot fill 40 words with quoted facts, or that duplicate a candidate of another run. Show the owner the rest, with the usable earlier candidates marked as such, as a short list (key, date, kind, one line) with your recommendation of which to keep and why, and take their choice.

## Phase 3: pictures
1. Dispatch `ep-picture-researcher` with the chosen events: key, date, place and the dossier's picture ideas.
2. For each event, run `powershell -File .\build.ps1 -FetchPicture -Pack <key> -File "<File:...>" -Key <picture key> -DryRun` on its first proposal; on `REJECTED`, try the next. An event with no accepted file gets a vanilla picture (`vanilla:GFX_report_event_<name>`, found with `Find-HoiUsage` of the `hoi4-vanilla-lookup` skill) and a note in the plan.
3. Choose crop and tone per picture: `warm` for black-and-white photographs (it matches the game's own pictures), `none` for colour art; a crop other than 50 only where the researcher's crop note asks for it.
4. Fill the plan's "Pictures" table with what the dry runs printed.
5. Thumbnail, for a new pack or one whose `packs/<key>/thumbnail.png` still has the hash of `assets/thumbnail_master.png` (`Get-FileHash`): the background is one of the pack's own event pictures, not a vanilla loading screen. Pick a picture that printed `ACCEPTED`, PD or CC0 preferred; CC BY also does, as the generated Workshop description credits every picture an event uses. Look at the picture and name where its subject sits. A landscape picture fills the square's whole height, so the crop (`center`, `left`, `right`) only moves it sideways; a portrait picture fills its width, and `top` or `bottom` keeps the subject in. The text block (title, country, and the flag with the banner behind them) covers the top or bottom 45% of the square with the flag under the text (`--overlay-pos below-text`), or 25% with the flag in a corner (`--overlay-pos top-left` and the other corners). Put it over the picture's emptiest band, such as sky, ground or water, and never over the subject: `--text-pos top` or `bottom`. When no band is that tall, put the flag in a corner over another empty area. Prefer a picture with such a band. Write its key on the plan's "Thumbnail" line with the subject's place, the text position and the flag position, and fill step 4 of "Implementation steps": picture key, country in capitals, crop, text and flag positions, and the pack's two colours. The flag: the tag, the game root `Get-HoiGameInfo` prints, and as flag variant the ruling party ideology `Get-HoiCountryHistory -Tag <TAG> -Section politics` prints. Check the flag while planning with the same generator command and `--out-dirs "scratch\thumbnail\<key>"` but no `--bg-image`: when it stops with `No flag for '<TAG>'`, pick the variant from the list it prints. The colours come from that flag as the game draws it, never a preset theme, so every pack wears its own nation's colours: list the file's commonest colours with `python -I -c "from PIL import Image; from collections import Counter; print(['#%02X%02X%02X' % c for c, n in Counter(Image.open(r'<the overlay_source the check printed>').convert('RGB').getdata()).most_common(6)])"`. The main colour is the one the flag is known by, never white (Finland: its blue `#003580`); it frames the picture and fills the banner behind the text. The text colour is `#FFFFFF`, or `#000000` when the main colour is light (a yellow, a pale blue). A dry run downloads nothing, so the thumbnail is made at implementation, after step 3, from the copy `-FetchPicture` saves in `sources-cache/<key>/` (the Commons rendering, up to 1600 px wide), never from the 210x176 DDS. A pack that already has its own thumbnail: write `Thumbnail: unchanged` and make step 4 read `Thumbnail unchanged: nothing to run.`, so the step numbers stay.

## Phase 3a: verify
Runs after the owner's choice, at the same time as Phase 3 if you like; a researcher's quote is a lead, not yet a check.
1. Dispatch `ep-audit-researcher` on the chosen events, at most five per agent, all in parallel. Paste each event's dossier section whole; send no pictures.
2. Only `KEEP` and `FIX` facts go on, each with the source and quote the checker returned. An event left with less than 40 words of verified detail goes back to Phase 2 for a replacement, and the replacement comes through Phase 3a too.
3. Fill the plan's "Fact verification": agents and events per agent; per checked event, replaced ones included, the `KEEP`, `FIX` and `DROP` counts, each fixed fact with its correction and each dropped fact; the events replaced.

## Phase 4: write
1. Write each chosen event's section of the plan's `markdown fact-sheets` block from its Phase 3a results only: every fact line is `- <fact>. Source: <URL> (<page title>). Quote: «<line from the page>»`. Never copy a dossier fact straight in.
2. Write the events into the `json events` block: for an existing pack, start from the current `source/<key>/events.json` and add to it. Follow `docs/source-format.md` for every field and `docs/style-guide.md` for every text. Effects small and matching their option; a timed idea only where the event earns one. Three rules the editor holds you to:
   - No claim made by joining two facts, unless one quote states the joined claim.
   - Titles and roles as they were on the event's date, not as they became later.
   - The text stays true on every day of the `fire` window: nothing it calls recent or upcoming may already be over, or not yet happened, on another day of the window.
3. Dispatch `ep-editor` with the plan path (its `markdown fact-sheets` block is the fact sheet) and the event keys. Apply every REWRITE as given; drop or replace a REJECT (back to Phase 2 for a replacement). Record each round in "Editor record". Send the changed events back to the editor until every event is KEEP; at most three rounds, then ask the owner.

## Phase 5: gate
1. Rehearse the plan without touching the repository: `robocopy . scratch\rehearsal /MIR /XD .git scratch artifacts sources-cache`, then in `scratch\rehearsal` run steps 1 to 7 of the plan exactly as written (they write only the copy). Every step must give what it says to expect; fix the plan, not the copy, and rehearse again.
2. Fill "Events", list in "Kept on judgment" any `[WARN]` the rehearsal's `-Check -Pack <key>` printed that stays, and set `Status: READY`.
3. Delete the copy: `Remove-Item -Recurse -Force scratch\rehearsal`.
4. Mark the dossiers, in every section of the candidate's key (dossier and addendum alike):
   - Each event of the READY plan gets a line `Used: <plan file name>` right under its `## <key>` heading.
   - Every candidate Phase 3a checked, the replaced ones included, then gets a line below that (below its heading if it has no `Used:`, below any earlier `Checked:` line): `Checked: <plan file name>, <K> kept, <F> fixed, <D> dropped. The facts below are the researcher's notes, not the checked ones: see <where>.` The counts are its own from "Fact verification". `<where>` is `source/<key>/fact-sheets.md` for an event of the plan, and `the plan's "Fact verification"` for a replaced one.
   - Change nothing else in a dossier. A candidate never checked stays unmarked, as the researcher wrote it.

## Phase 6: hand off
Report to the owner: the plan path, the dossier paths with how many candidates they keep for later, the events with their titles, the picture licences (how many PD, CC0, CC BY), the thumbnail's picture, the fact verification totals, the editor's totals, and that `event-pack-implement` carries it out. Then stop.

Antigravity: pass each agent brief's path to `invoke_subagent`; where no subagent can be dispatched, read the brief and do its work yourself, keeping the editor's work in a separate pass that reads only the draft, the fact sheet and the style guide.
