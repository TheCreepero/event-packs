# <Country> pack: <what this plan adds>

Status: PLANNING
Pack: <key> (<TAG>, namespace ep_<tag>)
Kind: new pack | new events | audit fixes
Created: <YYYY-MM-DD>

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/<pack>/events.json` (in an audit plan with `"mergeById": true`, only the events it changes), the `markdown fact-sheets` block holds the sections for `source/<pack>/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Step 1 writes both blocks with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

<Why this plan exists: a new pack, events added to a pack, or the fixes an audit approved. Which skill wrote it.>

## Decisions

<The owner's answers to the scope questions: period, number of events, kinds, anything excluded, with the date.>

## Events

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|

## Pictures

Every row passed `build.ps1 -FetchPicture ... -DryRun` while planning; the licence column is what it printed.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|

Thumbnail: <picture key, the background of step 4>, crop <crop> | unchanged

Pack intro: <the pack's intro text, two or three plain sentences, as it goes before the `strip-info` region of `source/<pack>/workshop-intro.bbcode`> | unchanged (events added to a pack whose intro stays true)

Bundle intro: <the new first sentence of `source/all/workshop-intro.bbcode`, which names this pack's country> | unchanged (a new pack names its country there; events added to an existing pack leave it unchanged)

## Fact verification

<Phase 3a of event-pack-create, or Phase 1 of an audit: the ep-audit-researcher agents and the events each checked; per checked event, replaced ones included, the KEEP, FIX and DROP counts, each fixed fact with its correction and each dropped fact; the events sent back for a replacement. The dossiers' `Checked:` lines take their counts from here.>

## Trigger verification

<Phase 4 of event-pack-create, or Phase 1 and the rerun of Phase 3 of an audit: the `trigger-checker` verdict per event (OK, FIX with the trigger that replaced the old one, OPEN with the probe and its result or the owner's decision) and the round it came in. No plan is READY with an OPEN that has neither.>

## Editor record

<The ep-editor verdicts per event and round (KEEP, REWRITE, REJECT), and what the planner did with each.>

## Kept on judgment

<Each `[WARN]` line of `build.ps1 -Check` or `-RenderEvents` that stays, with the reason. The implementer stops on any other warning.>

## Implementation steps

- [ ] 1. Write the source from the blocks below: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\<plan file>.md`: expect `Applied <plan file>.md`, with no `[WARN]` outside "Kept on judgment", and with the events and fact-sheet sections it lists as changed or added being the ones this plan changes. It writes `source/<pack>/events.json` from the `json events` block (the whole file; a `"mergeById": true` block puts its events in place of those of the same id) and puts each section of the `markdown fact-sheets` block in place of the section of the same key in `source/<pack>/fact-sheets.md`, adding new keys. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [ ] 2. Check that the source holds the blocks: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\<plan file>.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [ ] 3. Fetch the pictures as one loop in one tool call, not one call per picture: a PowerShell `foreach` over the rows of the picture table, running the command below for each row and printing its output. The loop stops at the first row whose output has no `ACCEPTED` (`$out = powershell -File ...; $out; if (-not ($out -cmatch '\bACCEPTED\b')) { break }`); a retry after a failure reruns the loop over the remaining rows only, the failed row onward, not over all of them. Each row is expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack <pack> -File "<File:...>" -Key <key> -Crop <crop> -Tone <tone>`
- [ ] 4. Make the thumbnail from the picture fetched in step 3 (when "Thumbnail" says unchanged, this step reads `Thumbnail unchanged: nothing to run.`):
  - In `assets/thumbnail.json`, set `packs.<pack>.background` to `{ "path": "sources-cache/<pack>/<picture key>.*", "crop": <crop> }`, adding the pack's entry under `packs` when it has none.
  - `powershell -File "<Manager root>\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack <pack>`: expect the pack's line with `new` or `changed` and no `Warning:` line; open the preview it names with the Read tool.
  - `powershell -File "<Manager root>\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack <pack> -Apply`: expect the pack's line with `new` or `changed`.
- [ ] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack <pack>`: expect `failed=0`.
- [ ] 6. When "Pack intro" gives text, replace the intro text of `source/<pack>/workshop-intro.bbcode` with it, and when "Bundle intro" gives a sentence, replace the first sentence of the intro of `source/all/workshop-intro.bbcode` with it (the lines around each stay: region markers, the info lines). Then `powershell -File .\build.ps1 -Generate -Pack <pack>`: expect `Generated pack '<pack>'`; it also writes the bundle page `packs/all/WORKSHOP_DESCRIPTION_GUIDELINES.md` with this pack's event count. When "Pack intro" gave text: `powershell -NoProfile -File "<Manager root>\Scripts\Workshop\Sync-WorkshopRegions.ps1" -ModName "Event Packs"` and `powershell -NoProfile -File "<Manager root>\Scripts\Workshop\Test-WorkshopText.ps1" -Mod "Event Packs" -Pack <pack> -TextOnly`: expect the second to report `no problem found (the description Steam gets, apart from the cross-link block)`. Image addresses and cross-links stay with the release preflight. (The planning rehearsal skips these two: they act on the registered repository, not on its copy.)
- [ ] 7. `powershell -File .\build.ps1 -Check -Pack <pack>`: expect `Check OK` and `Bundle 'all': <n> member(s), 0 error(s)`, with no warning outside "Kept on judgment". A new pack is already in the bundle's `members` (`-NewPack` added it).
- [ ] 8. `powershell -File .\build.ps1 -RenderEvents -Pack <pack>`: expect `Rendered <n> events to ...artifacts\workshop-images\<pack>` (the folder gets one render per event, `00-overview` and `contact-sheet-NOT-FOR-WORKSHOP`), with no `[WARN]` outside "Kept on judgment".
- [ ] 9. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [ ] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `feat(<pack>): <summary>`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The commit holds the bundle's files too (`tools/HoiModBuild.json`, `source/all/`, `packs/all/`). The Workshop upload is `event-pack-release`: one `Publish-Mod.ps1 -Pack <pack>` run uploads the pack and then the bundle, and a new country is released with its Commanders Pack in the same session.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

<Filled by the implementer: date, the `-Check` summary line, deviations.>

## Fact sheets

```markdown fact-sheets
## <key>

- <fact>. Source: <URL> (<page title>). Quote: «<line from the page>»
```

## Events source

<The whole `source/<pack>/events.json`. An audit plan holds only the events its fixes change, each as its whole object with its id unchanged, under `"pack"`, `"tag"` and `"mergeById": true` (and `"ideas"` with only the changed ideas, `"factQuotesFromId": null` to remove that field): see `docs/source-format.md`, "Plans".>

```json events
{
    "pack": "<key>",
    "tag": "<TAG>",
    "namespace": "ep_<tag>",
    "displayName": "<Country>",
    "events": [],
    "ideas": []
}
```
