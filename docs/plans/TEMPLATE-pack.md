# <Country> pack: <what this plan adds>

Status: PLANNING
Pack: <key> (<TAG>, namespace ep_<tag>)
Kind: new pack | new events | audit fixes
Created: <YYYY-MM-DD>

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/<pack>/events.json`, the `markdown fact-sheets` block holds the sections for `source/<pack>/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

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

## Fact verification

<Phase 3a of event-pack-create, or Phase 1 of an audit: the ep-audit-researcher agents and the events each checked; per checked event, replaced ones included, the KEEP, FIX and DROP counts, each fixed fact with its correction and each dropped fact; the events sent back for a replacement. The dossiers' `Checked:` lines take their counts from here.>

## Editor record

<The ep-editor verdicts per event and round (KEEP, REWRITE, REJECT), and what the planner did with each.>

## Kept on judgment

<Each `[WARN]` line of `build.ps1 -Check` or `-RenderEvents` that stays, with the reason. The implementer stops on any other warning.>

## Implementation steps

- [ ] 1. Write the events: replace `source/<pack>/events.json` with the `json events` block below, whole.
- [ ] 2. Write the fact sheets: add each section of the `markdown fact-sheets` block below to `source/<pack>/fact-sheets.md`, replacing a section of the same key.
- [ ] 3. Fetch the pictures, one command per row of the picture table, each expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack <pack> -File "<File:...>" -Key <key> -Crop <crop> -Tone <tone>`
- [ ] 4. Make the thumbnail from the picture fetched in step 3 (when "Thumbnail" says unchanged, this step reads `Thumbnail unchanged: nothing to run.`):
  - In `assets/thumbnail.json`, set `packs.<pack>.background` to `{ "path": "sources-cache/<pack>/<picture key>.*", "crop": <crop> }`, adding the pack's entry under `packs` when it has none.
  - `powershell -File "<Manager root>\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack <pack>`: expect the pack's line with `new` or `changed` and no `Warning:` line; open the preview it names with the Read tool.
  - `powershell -File "<Manager root>\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack <pack> -Apply`: expect the pack's line with `new` or `changed`.
- [ ] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack <pack>`: expect `failed=0`.
- [ ] 6. `powershell -File .\build.ps1 -Generate -Pack <pack>`: expect `Generated pack '<pack>'`.
- [ ] 7. `powershell -File .\build.ps1 -Check -Pack <pack>`: expect `Check OK`, with no warning outside "Kept on judgment".
- [ ] 8. `powershell -File .\build.ps1 -RenderEvents -Pack <pack>`: expect `Rendered <n> events to ...artifacts\workshop-images\<pack>`, with no `[WARN]` outside "Kept on judgment".
- [ ] 9. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [ ] 10. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(<pack>): <summary>`, then `powershell -File .\wiki\push-wiki.ps1`.

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
