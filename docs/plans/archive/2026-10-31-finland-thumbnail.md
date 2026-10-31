# Finland pack: thumbnail with the flag and the flag's blue

Status: DONE
Pack: finland (FIN, namespace ep_fin)
Kind: thumbnail
Created: 2026-10-31

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. This plan changes only `packs/finland/thumbnail.png`: no event, fact sheet or picture changes, so it has no `json events` or `markdown fact-sheets` block. Decide nothing; stop and report when something does not fit.

## Context

The pack's thumbnail (made by `archive/2026-10-31-finland-first-events.md`) used the preset `amber` theme and no flag. The thumbnail generator can now draw the country's flag from the game files and take any colour, and the owner wants every pack in its own nation's colours. `event-pack-create` Phase 3 step 5 and the plan template now say how: the flag below the country, and the colours taken from that flag as the game draws it. This plan remakes Finland's thumbnail that way. Written by hand on the owner's request, following those rules.

## Decisions

- 2026-10-31, the owner: the thumbnail shows Finland's flag, and its colour scheme is the blue of the Finnish flag.
- Background unchanged: `record_year_1937` (timber floating at Jämsänkoski, 1938; PD), crop `center`.
- Flag: `FIN`, variant `neutrality` (the 1936 ruling party, `Get-HoiCountryHistory -Tag FIN -Section politics`: `ruling_party neutrality`), game root `C:\Gaming\Steam\steamapps\common\Hearts of Iron IV`.
- Colours sampled from `gfx\flags\FIN_neutrality.tga`: `#FFFFFF`, `#003580`, ... Main colour `#003580` (the flag's blue), text colour `#FFFFFF`.

## Events

Unchanged: 15 events, ids 1 to 15.

## Pictures

Unchanged.

Thumbnail: record_year_1937

## Editor record

No text changes.

## Kept on judgment

None.

## Implementation steps

- [x] 1. Events unchanged: nothing to run.
- [x] 2. Fact sheets unchanged: nothing to run.
- [x] 3. Pictures unchanged: nothing to run. `sources-cache\finland\record_year_1937.jpg` is already there from the first plan.
- [x] 4. Make the thumbnail from the picture fetched by the first plan, two commands:
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\finland\record_year_1937.*).FullName --bg-crop center --title "EVENT PACK" --subtitle "FINLAND" --flag-tag FIN --flag-variant neutrality --game-dir "C:\Gaming\Steam\steamapps\common\Hearts of Iron IV" --theme "#003580" --banner --banner-color "#003580" --text-color "#FFFFFF" --accent-color "#FFFFFF" --text-pos top --hoi4 --json --out-dirs "scratch\thumbnail\finland"`: expect `"status": "success"`, `"workshop_limit_exceeded": false` and an `"overlay_source"` naming `FIN_neutrality.tga`.
  - `Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png`
- [x] 5. Pictures unchanged: nothing to run.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack finland`: expect `Generated pack 'finland'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack finland`: expect `Check OK`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 9. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(finland): thumbnail with the flag in the flag's blue`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- The generator exits 2 or prints `No flag for 'FIN'`: stop and report the output.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

2026-10-31. `Check OK: 1 pack(s), 0 warning(s).` Generator: status success, workshop_limit_exceeded false, overlay_source `FIN_neutrality.tga`. `-ValidateOnly` succeeded, `-Test` 171 passed, 0 failed. No deviations. Step 9 (ship) left for the caller.
