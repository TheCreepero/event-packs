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

Thumbnail: <picture key, the background of step 4> | unchanged

## Editor record

<The ep-editor verdicts per event and round (KEEP, REWRITE, REJECT), and what the planner did with each.>

## Kept on judgment

<Each `[WARN]` line of `build.ps1 -Check` that stays, with the reason. The implementer stops on any other warning.>

## Implementation steps

- [ ] 1. Write the events: replace `source/<pack>/events.json` with the `json events` block below, whole.
- [ ] 2. Write the fact sheets: add each section of the `markdown fact-sheets` block below to `source/<pack>/fact-sheets.md`, replacing a section of the same key.
- [ ] 3. Fetch the pictures, one command per row of the picture table, each expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack <pack> -File "<File:...>" -Key <key> -Crop <crop> -Tone <tone>`
- [ ] 4. Make the thumbnail from the picture fetched in step 3, two commands (when "Thumbnail" says unchanged, this step reads `Thumbnail unchanged: nothing to run.`):
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\<pack>\<picture key>.*).FullName --bg-crop <crop> --title "EVENT PACK" --subtitle "<COUNTRY>" --theme <theme> --text-pos top --hoi4 --json --out-dirs "scratch\thumbnail\<pack>"`: expect `"status": "success"` and `"workshop_limit_exceeded": false`.
  - `Copy-Item scratch\thumbnail\<pack>\thumbnail.png packs\<pack>\thumbnail.png`
- [ ] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack <pack>`: expect `failed=0`.
- [ ] 6. `powershell -File .\build.ps1 -Generate -Pack <pack>`: expect `Generated pack '<pack>'`.
- [ ] 7. `powershell -File .\build.ps1 -Check -Pack <pack>`: expect `Check OK`, with no warning outside "Kept on judgment".
- [ ] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [ ] 9. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(<pack>): <summary>`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

<Filled by the implementer: date, the `-Check` summary line, deviations.>

## Fact sheets

```markdown fact-sheets
## <key>

- <fact>. Source: <URL> (<page title>)
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
