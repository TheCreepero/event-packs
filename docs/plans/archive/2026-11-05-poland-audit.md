# Poland pack: audit fixes

Status: DONE
Pack: poland (POL, namespace ep_pol)
Kind: audit fixes
Created: 2026-11-05

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/<pack>/events.json`, the `markdown fact-sheets` block holds the sections for `source/<pack>/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

## Context

Audit of the shipped Poland pack (20 events, 17 Commons pictures, committed 2026-11-05 as `26752c8`; not yet on the Workshop), written by `event-pack-audit`. This file holds the audit report (Phases 0–2), the owner's answer in "Decisions" and the approved fixes (Phase 3: the events block, the fact-sheet block, the steps); the dossiers' `Checked:` lines are already written.

## Audit report

**Phase 0 (mechanical):** `-Audit`: 0 errors, 0 warnings. `-Check`: OK (20 events, 17 pictures). `Test-WorkshopText.ps1`: no problem found.

### Critical
None. No check fails, no picture is REJECTED by the licence gate, all 17 are still on Commons with an unchanged licence tag, and no fact was marked DROP. The two trigger FIXes below are not war events, so by the audit rule they are Important.

### Important

**Triggers (the text is false on some games)**
1. `wawel_coffin_1937`: the text names "President Mościcki" and says "The President did not accept it", but two vanilla focus chains (Dissolve the BBWR → poland.17, Triumph of OZN → poland.18) can replace him as leader from about mid-November 1936. New trigger: `has_war = no has_country_leader = { character = POL_ignacy_moscicki }` (the same leaf `hungary_border_1939` uses).
2. `zbaszyn_refugees_1938`: the text says Germany arrested and expelled the Polish Jews, but Germany can leave fascism before October 1938 (GER_oppose_hitler civil war). New trigger: `has_war = no GER = { has_government = fascism }`.

**Facts to FIX** (4 of 99 facts)
3. `wilimowski_brazil_1938`: "It was Poland's first ever World Cup match" is hedged on the page ("still remembered by many Polish fans as Poland's first ever FIFA World Cup match"). Say "remembered as Poland's first World Cup match" or "first World Cup finals match".
4. `wilimowski_brazil_1938`: attendance 13,452 is the match box figure, but the match section says "some 15,000 fans". Say "about 13,000" or drop the sentence.
5. `wawel_coffin_1937`: 22 June 1937 is the date the move was ordered *for*; the move happened in the night of 23/24 June. The fact line reads as if the order was issued on 22 June. Also the Silver Bells Tower crypt comes from the `1937` page (entry of 20 June) and the order from `Konflikt wawelski`, so the editor wants each claim in its own sentence.
6. `zbaszyn_refugees_1938`: the citizenship rule is a law of 31 March 1938 and the passport stamp a Ministry of Internal Affairs ordinance of 6 October 1938; the text gives neither. Add "since March 1938" to the citizenship sentence. The fix needs a verbatim quote for 31 March; Phase 3 gets it from the researcher first, or leaves the sentence as it is.

**Editor rewrites (9 of 20 events)**
7. `spitsbergen_crossing`: option "Let the mountaineering clubs celebrate their own." claims the men belong to clubs; not in the fact sheet. → "No state reception. Others can honour them."
8. `rambouillet_loan`: the "Rambouillet agreement commits France to a loan" joins a chapter heading to the loan sentence, and the option "Order the guns and aircraft the army lacks" claims a lack the fact sheet does not state. The page does carry the joining sentence («fut signé, à Rambouillet, l'accord portant engagement par la France d'un prêt de deux milliards de francs à la Pologne pour son armement»), so the fact gets that quote. Option → "Spend it on arms for the army at once."
9. `pzl37_los_first_flight`: "The order was for a modern, fast bomber" comes before the aircraft is introduced. Swap the two paragraphs.
10. `gdynia_boom_1936`: option "Housing can wait. The quays cannot." brings in quays (not in the sheet). → "Housing is for the city to pay, not the state."
11. `szymanowski_funeral`: option "Print his scores at the state's expense" says he wrote music; not in the sheet. → "Raise a memorial at Skałka at the state's expense."
12. `wawel_coffin_1937`: "demonstratively handed in" is a word-for-word Polish calque → "in protest"; the Silver Bells Tower in its own sentence (see 5).
13. `independence_day_1937`: title and first sentence tie 11 November to the 1937 law; the quote gives no date. → "Independence Day Is Celebrated as a State Holiday".
14. `destroyers_grom_blyskawica`: "Grom was ordered…" names Grom without saying it is a ship → "The destroyer Grom was ordered…".
15. `wilimowski_brazil_1938`: option "Five goals and still beaten. The defence must improve." gives war support for a complaint → "Five goals and still beaten. Next time we win."

**Workshop intro**
16. `workshop-intro.bbcode`: "from 1936 up to the German invasion" reads as stopping before the invasion, but `westerplatte` is the invasion event, and the intro gives no end year (France and Finland intros do). → "from 1936 to the German invasion in September 1939." The rest of the intro is supported by the files (17 of 20 events show a photograph; the focuses/events claim holds).

**Pictures (the gate ACCEPTED all six dry runs; these are judgment calls)**
17. `pyry_enigma`: the file page names no photographer, no source and no date; the only data is "original uploader Listowy at English Wikipedia", 2006. A PD-Poland claim cannot be backed without the photographer, and a modern photo of a museum object would not be PD. Owner's decision: keep, or replace (a replacement goes through `ep-picture-researcher` and a new `-FetchPicture`).
18. `szymanowski_funeral`: the page shows only CC0, with no PD reason, for a 1937 photo by a named photographer ("Photo Gerber - Lausana") from Polona; CC0 is a rights-holder's declaration and the uploader looks like a Wikimedia user. Owner's decision: keep, or replace. (Both 17 and 18 were left for this audit by the owner.)

### Minor
- Weak PD tags, kept unless the owner wants them replaced: `spitsbergen_crossing` (PD-old-auto with an unknown photographer; the page sits in the "PD Old auto: no death date" category), `gdynia_boom_1936` and `batory_maiden_voyage` (PD-old-70 without a death date for Durczykiewicz / Poddębski; "Copyright-tag-still-required" on both), `wawel_coffin_1937` (PD-anon-70-EU on a c. 1930 portrait), `westerplatte` (no source or publication).
- `pictures.json` of `wawel_coffin_1937` records `pictureYear` 1867, which is the sitter's birth year (the photo is from about 1930); `westerplatte` records null. Only a re-run of `-FetchPicture` changes it.
- Picture fit: `gdynia_boom_1936` is a 1938 postcard (event 1936–37), `fon_1936` a photo of 1937–39 (event text 1936 decree), `pzl37_los_first_flight` an aircraft at an airfield in 1939, `wilimowski_brazil_1938` a match photo that does not show him, `destroyers_grom_blyskawica` shows Błyskawica only.
- `wilimowski_brazil_1938` has only 3 to 4 weekly checks at chance 50: it is missed in 6 to 12.5% of games. Raising the chance to 75 or 100 closes it (owner's call).
- `hungary_border_1939`: window to 1947 with the present-perfect "have reached", so the event can fire long after the meeting (five months later in a 1939 start, years later after a war). A narrower `fire.before` is the only fix and it is a date decision. The editor also notes "The new border is only 180 km long" holds only for the historical border (Hungary holding Carpathian Ruthenia, state 73, not also Slovak lands).
- `independence_day_1937`: the fact sheet gives no day for the Sowiński unveiling; a check on 11–13 November could come slightly early.
- `destroyers_grom_blyskawica`: Błyskawica's 25 November date rests on one source (dzieje.pl; en.wikipedia's body says 1 October 1937 and its infobox 25 November); the first commander also rests on one source. "Her first commander is…" may read better in the past tense.
- `szymanowski_funeral`: no source gives the date the coffin went into the crypt (7 April is an inference, so the text does not state it); the "carried past Wawel to the church on Skałka" sentence was seen only in part. The text never says who he was; a sourced "composer" fact would let the text and the score option read better.
- Quotes the fetch tool returns only in part (it caps a quote near 125 characters): the Silver Bells Tower line on the `1937` page, Składkowski's resignation sentence, Sucharski/Dąbrowski, the FON ministry and Kurkowska-Spychajowa lines, the Nanda Devi avalanche line. The pages show the beginning of each; no contradiction was seen, so they stay as the earlier pass wrote them.
- `pyry_enigma`: the 1936-start route through `focus_progress` has not been seen in game (optional second in-game run; it cannot make an event fire falsely).

### Intentionally unchanged
- 11 events the editor KEEPs: `kasprowy_cable_car`, `batory_maiden_voyage`, `berlin_olympics_team`, `chopin_competition_1937`, `gordon_bennett_1938`, `zbaszyn_refugees_1938` (text; see 6), `hungary_border_1939`, `nanda_devi_east`, `fon_1936`, `pyry_enigma`, `westerplatte`.
- 18 of 20 triggers are OK, among them the war-gated `fon_1936`, `pyry_enigma` and `westerplatte` (probed in the owner's 1939-start run). `westerplatte`: Danzig (state 85) is Polish at every start, so the guard holds; the `months > 1` guard lasts about 60 days (measured, harmless).
- The three vanilla pictures (`independence_day_1937`, `zbaszyn_refugees_1938`, `hungary_border_1939`) and the intro's "17 of 20 show a photograph": the intro states it correctly; whether to look for photographs is the owner's call.
- Effects: all inside `data/effect-caps.json`, flavor first.

## Decisions

The owner's answer, 2026-11-05:
1. Fix all the Important items (1–16): yes.
2. `pyry_enigma` and `szymanowski_funeral` pictures: keep them.
3. The Minor owner calls: yes, except photo searches for the vanilla pictures, which are left out.

How the Minor calls were applied:
- `wilimowski_brazil_1938`: `chance` 50 → 100 (its window has 3 to 4 weekly checks).
- `hungary_border_1939`: `fire.before` 1947.12.31 → **1939.12.31**, and the text goes to the past tense ("Hungarian patrols reached …"). The planner did not narrow it further than the end of 1939: the owner's 1939-start run (start 14 August 1939) showed the event firing at the first weekly check on 20 August, five months after the meeting, so a window ending before August 1939 would stop it firing in a 1939 start. The window still cuts the 1940–1947 tail, and the past tense keeps the text true on any day inside it.
- `hungary_border_1939` also loses its sentence "The new border is only 180 km long." (and the anchor "180 km"): the `trigger-checker` showed it can be false while the trigger holds. The other fix it proposed was a long trigger on Slovakia's ownership with a border adjacency it could not verify; the planner took the smaller one.
- The other Minor items (weak PD tags, `pictureYear` fields, picture fit, the Szymanowski burial date, the unsourced second source of Błyskawica) change nothing; they stay in the report.

## Events

Eleven events change; the other nine are in the `json events` block as they are in `source/poland/events.json` now.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 4 | spitsbergen_crossing | Three Men Complete the First Traverse of Spitsbergen | 1936.9.2 – 1936.10.31 | 50 | spitsbergen_crossing | option 2 renamed; effects unchanged |
| 5 | rambouillet_loan | France Promises Poland a Loan of Two Billion Francs | 1936.9.7 – 1936.10.31 | 50 | rambouillet_loan | text and option 1 reworded; effects unchanged |
| 6 | pzl37_los_first_flight | The PZL.37 Łoś Bomber Flies for the First Time | 1936.12.14 – 1937.1.31 | 50 | pzl37_los_first_flight | paragraphs swapped; effects unchanged |
| 7 | gdynia_boom_1936 | Gdynia Grows to 102,000 Inhabitants | 1937.1.1 – 1937.3.31 | 50 | gdynia_boom_1936 | option 2 renamed; effects unchanged |
| 9 | szymanowski_funeral | Karol Szymanowski Is Buried at Skałka | 1937.4.10 – 1937.5.10 | 50 | szymanowski_funeral | option 2 renamed; effects unchanged |
| 10 | wawel_coffin_1937 | Archbishop Sapieha Moves Piłsudski's Coffin | 1937.7.1 – 1937.8.15 | 50 | wawel_coffin_1937 | text reworded; trigger adds Mościcki as leader |
| 11 | independence_day_1937 | Independence Day Is Celebrated as a State Holiday | 1937.11.11 – 1937.12.15 | 100 | vanilla:GFX_report_event_soldiers_parade | title and text reworded |
| 12 | destroyers_grom_blyskawica | ORP Błyskawica Enters Service in the Polish Navy | 1937.11.26 – 1938.1.31 | 50 | destroyers_grom_blyskawica | "The destroyer Grom" |
| 13 | wilimowski_brazil_1938 | Poland Loses 6-5 to Brazil at the World Cup | 1938.6.6 – 1938.6.30 | **100** | wilimowski_brazil_1938 | text and option 2 reworded; attendance dropped |
| 15 | zbaszyn_refugees_1938 | Polish Jews Expelled from Germany Are Sent to Zbąszyń | 1938.11.1 – 1938.12.31 | 50 | vanilla:GFX_report_event_german_polish_border | "Since March 1938"; trigger adds Germany fascist |
| 16 | hungary_border_1939 | Polish and Hungarian Soldiers Meet at the Border | 1939.3.17 – **1939.12.31** | 50 | vanilla:GFX_report_event_generic_handshake | past tense; "180 km" sentence and anchor dropped; window ends 1939.12.31 |

## Pictures

No picture is fetched, replaced or removed (the owner keeps `pyry_enigma` and `szymanowski_funeral`).

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|
| (none) | | | | | |

Thumbnail: unchanged. `packs.poland.background` in `assets/thumbnail.json` is `chopin_competition_1937`, which no fix touches.

## Fact verification

Phase 1, five `ep-audit-researcher` passes (events A–D at five events each, then a re-fetch of quotes the first pass could not see) over all 20 events, 99 facts: **95 KEEP, 4 FIX, 0 DROP**. Declined fixes: none (the owner approved every Important item).

| Event | KEEP | FIX | DROP | Note |
|---|---|---|---|---|
| kasprowy_cable_car | 5 | 0 | 0 | |
| batory_maiden_voyage | 7 | 0 | 0 | |
| berlin_olympics_team | 4 | 0 | 0 | |
| spitsbergen_crossing | 3 | 0 | 0 | |
| rambouillet_loan | 3 | 0 | 0 | fact 2 gets the loan-signing quote (item 8) |
| pzl37_los_first_flight | 4 | 0 | 0 | |
| gdynia_boom_1936 | 3 | 0 | 0 | |
| chopin_competition_1937 | 7 | 0 | 0 | |
| szymanowski_funeral | 5 | 0 | 0 | Warsaw funeral 6 April verified on the re-fetch; route sentence seen in part; no burial date in any source |
| wawel_coffin_1937 | 3 | 1 | 0 | FIX: date of the order vs the move (item 5) |
| independence_day_1937 | 4 | 0 | 0 | |
| destroyers_grom_blyskawica | 7 | 0 | 0 | |
| wilimowski_brazil_1938 | 4 | 2 | 0 | FIX: "first ever" hedge, attendance (items 3, 4) |
| gordon_bennett_1938 | 4 | 0 | 0 | |
| zbaszyn_refugees_1938 | 6 | 1 | 0 | FIX: citizenship rule wording (item 6) |
| hungary_border_1939 | 6 | 0 | 0 | Horthy telegram verified in full on the re-fetch |
| nanda_devi_east | 5 | 0 | 0 | |
| fon_1936 | 6 | 0 | 0 | |
| pyry_enigma | 5 | 0 | 0 | meeting 25 July per the Rejewski page; the text names no date |
| westerplatte | 4 | 0 | 0 | |

Pictures: 17 of 17 still on Commons, no deletion or copyvio template; 6 marked RECHECK (`pyry_enigma`, `szymanowski_funeral`, `gdynia_boom_1936`, `spitsbergen_crossing`, `wawel_coffin_1937`, `westerplatte`); `-FetchPicture -DryRun` printed ACCEPTED for all six (no REJECTED).

## Trigger verification

`trigger-checker`, round 1 (`Test-HoiConditions.ps1` over `events.json`: 20 open, 0 dead, 0 holds; game files 1.19.4.1): 18 OK, 2 FIX, 0 OPEN.

| Event | Verdict |
|---|---|
| kasprowy_cable_car, batory_maiden_voyage, berlin_olympics_team, spitsbergen_crossing, rambouillet_loan, pzl37_los_first_flight, gdynia_boom_1936, chopin_competition_1937, szymanowski_funeral, independence_day_1937, destroyers_grom_blyskawica, wilimowski_brazil_1938, gordon_bennett_1938 | OK (`has_war = no`; windows after the dated facts) |
| wawel_coffin_1937 | FIX → `has_war = no has_country_leader = { character = POL_ignacy_moscicki }` (checked at 1937.7.1: OPEN on the run-time leaves) |
| zbaszyn_refugees_1938 | FIX → `has_war = no GER = { has_government = fascism }` (checked at 1938.11.1: GER leaf HOLDS, rest run-time) |
| hungary_border_1939 | OK (state 73 and 89 neighbour; fired in the owner's run); residual present-perfect text, see Minor |
| nanda_devi_east | OK |
| fon_1936, pyry_enigma, westerplatte | OK (fired in the owner's 1939-start run) |

Round 2 (Phase 3, over the plan's `json events` block; its fire blocks differ from `source/poland/events.json` only in ids 10, 13, 15 and 16): `wawel_coffin_1937` OK (Mościcki is the start leader at both starts; the leaf is false once poland.17 / poland.18 or an opposition civil war promotes another; 6–7 checks, miss at most 1.6%), `zbaszyn_refugees_1938` OK (the GER leaf holds from the start data; 8–9 checks, miss at most 0.4%), `wilimowski_brazil_1938` OK (chance 100, 0% miss unless Poland is at war the whole window), `hungary_border_1939` FIX for the "180 km" sentence (see "Editor record"; resolved by dropping the sentence, trigger and window unchanged by the fix). The game has two starts only, 1936.1.1 and 1939.8.14, so every window before August 1939 is reached from the 1936 start.

Notes from round 2, left as they are:
- `hungary_border_1939`, 1939 start: 2 weekly checks (20 and 27 August) at 50% before the war on 1 September, so the event is missed in 25% of 1939-start games where Germany attacks on 1 September (it fired at the first check in the owner's run). Raising its chance to 100 would close it; the owner did not name this event, so it stays at 50. In a 1936 start the event is missed when Hungary gets state 73 only in 1940 or later, which the narrower window now causes (intended: the past-tense text is meant for the weeks after the meeting).
- Optional guards that would close rare cases: `owns_state = 88` (Kraków) on `wawel_coffin_1937` and `owns_state = 86` (Poznań) on `zbaszyn_refugees_1938`; neither is needed in a normal game.

## Editor record

`ep-editor`, round 1 over all 20 events (draft = current `events.json`): 11 KEEP, 9 REWRITE, 0 REJECT. REWRITE: `spitsbergen_crossing`, `rambouillet_loan`, `pzl37_los_first_flight`, `gdynia_boom_1936`, `szymanowski_funeral`, `wawel_coffin_1937`, `independence_day_1937`, `destroyers_grom_blyskawica`, `wilimowski_brazil_1938` (items 7–15). The editor did not see the researcher's FIXes (items 3, 4, 6) or the two trigger fixes; Phase 3 sends the changed texts back through `ep-editor` until KEEP.

`workshop-editor` (mod mode), round 1: intro opening paragraph REWRITE (item 16), the Info region KEEP.

Phase 3, after the owner's answer (the plan's `json events` block as the draft):
- `ep-editor` round 2 over the 11 changed events: 8 KEEP (`spitsbergen_crossing`, `rambouillet_loan`, `pzl37_los_first_flight`, `gdynia_boom_1936`, `szymanowski_funeral`, `independence_day_1937`, `destroyers_grom_blyskawica`, `zbaszyn_refugees_1938`), 3 REWRITE, applied verbatim:
  - `wawel_coffin_1937`: the two sentences saying the same thing merged; the text now says the move happened in the night of 23 to 24 June (fact 2, no longer "not used").
  - `wilimowski_brazil_1938`: the hindsight sentence ("Many Polish fans remember it as Poland's first ever World Cup match") removed (the event fires days after the match); the fact line is marked not used; "Ernest Wilimowski".
  - `hungary_border_1939`: "on what had been the border" (the page says the border no longer existed).
- `ep-editor` round 3 over those three: 3 KEEP. Wilimowski now has 42 words, two above the style guide's floor of 40: nothing else is cut from it.
- `workshop-editor` round 2 over the new first paragraph of the intro ("from 1936 to the German invasion in September 1939"): KEEP; the Info region KEEP.
- `hungary_border_1939` and the "180 km" sentence: the editor's note (the sentence holds only for the historical border) was confirmed by the `trigger-checker` in round 2: DOD_hungary.101 gives Hungary Slovakia (states 70, 71) together with state 73, and the trigger still holds then. The checker's fix was a long trigger with an adjacency it could not verify, so the planner took the smaller one: the sentence "The new border is only 180 km long." and the anchor "180 km" are dropped, and the fact is marked not used. The event went back through `ep-editor` (round 4): KEEP.

## Kept on judgment

None. The gate rehearsal (a copy under `scratch\rehearsal`, deleted afterwards) gave: `-ConvertPictures` `failed=0`; `-Generate` 20 events, 13 files written; `-Check` OK with 0 warnings; `-Audit` 0 errors, 0 warnings; `-RenderEvents` 20 events with no `[WARN]` (the wawel and Hungary cards were opened and read cleanly); `-ValidateOnly` succeeded. The implementer stops on any `[WARN]` of `-Check` or `-RenderEvents`, and on a `-Validate`/`-Check` warning about a Poland picture.

Rehearsal notes for steps 8, 11 and 12:
- Step 8 could not be rehearsed on a copy (`Sync-WorkshopRegions.ps1` and `Test-WorkshopText.ps1` resolve the mod by name, so they act on this repository). `Sync-WorkshopRegions.ps1 -ModName "Event Packs" -Check` was run read-only before any change: all three packs `Current`. The copy's generated page did carry the new intro paragraph.
- Step 11: `-ValidateOnly` prints `Check OK: 3 pack(s), 3 warning(s)`; the 3 warnings are the France pictures `mermoz_disappearance`, `pcf_dissolution_1939` and `richelieu_launch_1939` (PD-US only), already there; none is a Poland picture. `-Test` on this repository (before any change): 264 passed, 0 failed. In the rehearsal copy one Knowledge test failed only because the copy's skills duplicate the repository's skill names; that does not happen on the real tree.

## Implementation steps

- [x] 1. Write the events: replace `source/poland/events.json` with the `json events` block below, whole.
- [x] 2. Write the fact sheets: replace the sections `rambouillet_loan`, `wawel_coffin_1937`, `wilimowski_brazil_1938`, `zbaszyn_refugees_1938` and `hungary_border_1939` of `source/poland/fact-sheets.md` with the sections of the same key in the `markdown fact-sheets` block below (the other 15 stay).
- [x] 3. Fix the Workshop intro: in `source/poland/workshop-intro.bbcode` change `from 1936 up to the German invasion.` to `from 1936 to the German invasion in September 1939.` and nothing else (never the generated `packs/poland/WORKSHOP_DESCRIPTION_GUIDELINES.md`).
- [x] 4. No pictures to fetch (the table is empty).
- [x] 5. Thumbnail unchanged: nothing to run.
- [x] 6. `powershell -File .\build.ps1 -ConvertPictures -Pack poland`: expect `failed=0`.
- [x] 7. `powershell -File .\build.ps1 -Generate -Pack poland`: expect `Generated pack 'poland'`.
- [x] 8. `powershell -File ..\..\Scripts\Workshop\Sync-WorkshopRegions.ps1 -ModName "Event Packs"`, then `powershell -File ..\..\Scripts\Workshop\Test-WorkshopText.ps1 -Mod "Event Packs" -Pack poland`: expect `no problem found`; if the sync changes the generated page, run `-Generate` again.
- [x] 9. `powershell -File .\build.ps1 -Check -Pack poland`: expect `Check OK`, with no warning outside "Kept on judgment"; then `powershell -File .\build.ps1 -Audit -Pack poland`: expect 0 errors and 0 warnings, and 20 events.
- [x] 10. `powershell -File .\build.ps1 -RenderEvents -Pack poland`: expect `Rendered 20 events to ...artifacts\workshop-images\poland`, with no `[WARN]` outside "Kept on judgment". The owner uploads the new images (the event cards of eleven events changed); the Workshop page is not published yet.
- [x] 11. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 12. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `fix(poland): audit fixes, trigger guards, text and fact corrections`, then `powershell -File .\wiki\push-wiki.ps1`.
- [ ] 13. Owner, in game (not the implementer): a 1936-start run to October 1939 settles the two remaining engine facts (a focus completed in play; `pyry_enigma` through the 1936-start route); `wawel_coffin_1937` and `zbaszyn_refugees_1938` cannot be tested by a smoke test alone (`ep_pol_all` fires the events without the trigger).

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

2026-11-05. Steps 1-11 done; steps 12 (ship) and 13 (owner, in game) left for the caller and the owner.

- `-Check -Pack poland`: Check OK: 1 pack(s), 0 warning(s). `-Audit`: 0 errors, 0 warnings, 20 events. `-RenderEvents`: Rendered 20 events, no [WARN]. `-ValidateOnly`: Validation succeeded (3 warnings, the known France pictures). `-Test`: 264 passed, 0 failed.
- `Sync-WorkshopRegions.ps1` left all three packs Current; `Test-WorkshopText.ps1`: no problem found.
- Deviation: step 1 was applied as targeted Edit calls on `source/poland/events.json` instead of one Write; the result was compared with the plan's `json events` block and is identical. Step 2 was applied by a script that replaced the five sections by key.

## Fact sheets

Only the five sections that change; each replaces the section of the same key in `source/poland/fact-sheets.md`.

```markdown fact-sheets
## rambouillet_loan

- Delbos gave a lunch for Rydz-Śmigły at the Quai d'Orsay on 5 September 1936. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «le déjeuner qui lui fut offert par Delbos, au Quai d'Orsay, le 5 septembre 1936»
- The agreement is known as the Rambouillet agreement. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «Accord de Rambouillet» (chapter heading)
- The agreement, signed at Rambouillet, committed France to a loan of two billion francs to Poland for its armament. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «fut signé, à Rambouillet, l'accord portant engagement par la France d'un prêt de deux milliards de francs à la Pologne pour son armement»

## wawel_coffin_1937

- Archbishop Adam Sapieha ordered, against the state authorities, that the coffin be moved to the prepared crypt on 22 June 1937 (the date set for the move). Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Abp Sapieha wydał wtedy, wbrew władzom państwowym, polecenie, aby przenieść trumnę do przygotowanej krypty 22 czerwca 1937 r.»
- The move itself took place in the night of 23/24 June 1937. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «W przeniesieniu trumny marszałka w nocy z 23/24 czerwca 1937» (the beginning of the sentence; the audit's fetch showed no more of it)
- The coffin of Marshal Piłsudski was to be moved to the crypt under the Silver Bells Tower. Source: https://pl.wikipedia.org/wiki/1937 (1937). Quote: «przeniesieniu trumny marszałka Piłsudskiego do krypty pod Wieżą Srebrnych Dzwonów» (the entry of 20 June, which begins «20 czerwca – biskup Adam Sapieha podtrzymał swoją wcześniejszą decyzję o przeniesieniu trumny marszałka Piłsudskiego do»; the audit's fetch showed «krypty pod Wieżą Sre…»)
- The Marshal's memorial committee and President Ignacy Mościcki opposed the archbishop's decision. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Tak samo postąpił Naczelny Komitet Uczczenia Pamięci Marszałka Józefa Piłsudskiego oraz prezydent Ignacy Mościcki.» (the sentence before it: the committee's executive chairman «wystąpił przeciw decyzji arcybiskupa»)
- Because of the conflict Prime Minister Składkowski demonstratively handed in the resignation of his government, and the President did not accept it. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Ze względu na trwający konflikt wawelski Felicjan Sławoj Składkowski demonstracyjnie złożył dymisję swojego rządu, która nie została jednak przyjęta przez Prezydenta RP Ignacego Mościckiego.»

## wilimowski_brazil_1938

- Brazil beat Poland 6-5 at the Stade de la Meinau in Strasbourg. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Stade de la Meinau, Strasbourg.»; «Brazil 6–5 Poland»
- The match was played on 5 June 1938. Source: https://en.wikipedia.org/wiki/Ernest_Wilimowski (Ernest Wilimowski). Quote: «June 5, 1938» (results table, with «Stade de la Meinau»)
- Wilimowski scored in the 53rd, 59th, 89th and 118th minutes. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Wilimowski 53', 59', 89', 118'» (scorers cell of the match box, as rendered)
- Wilimowski became the first player ever to score four goals in a single World Cup match. Source: https://en.wikipedia.org/wiki/Ernest_Wilimowski (Ernest Wilimowski). Quote: «put on a stunning display by becoming the first player ever to score four goals in a single World Cup match.»
- Many Polish fans remember it as Poland's first ever World Cup match (not used in the text; a later retrospective). Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «still remembered by many Polish fans as Poland's first ever FIFA World Cup match.»
- The match box gives an attendance of 13,452, the match section says some 15,000 fans (not used in the text). Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Attendance: 13,452»; «some 15,000 fans»

## zbaszyn_refugees_1938

- About 17,000 Polish Jews living in Germany were arrested and expelled in October 1938. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «In October 1938, about 17,000 Jewish Poles living in Nazi Germany were arrested and expelled.»
- The arrests ran in the days from 27 to 29 October (not used in the text). Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «From October 27 until October 29»
- On 31 March 1938 the Polish parliament approved legislation enabling the revocation of Polish citizenship of a person who had been living abroad for more than five years since 1919. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «On 31 March 1938, the parliament approved legislation enabling the revocation of Polish citizenship»; «if the person had been living abroad for more than five years since the establishment of Poland in 1919.»
- On 6 October 1938 the Ministry of Internal Affairs announced an ordinance: Polish citizens living outside Poland had to obtain an endorsement stamp on their passports before 30 October. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «On October 6, 1938, the Polish Ministry of Internal Affairs announced an ordinance requiring that Polish citizens»; «living outside Poland obtain an endorsement stamp on their passports before October 30.»
- The Polish Government quickly closed the border. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «However, the Polish Government quickly responded by closing the border down and denying any further access.»
- 8,000 of the expelled were sent to the town of Zbąszyń. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «8,000 were sent to the town of Zbąszyń.»
- For months the refugees at Zbąszyń slept in poorly constructed barracks with very few provisions. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «For months, refugees in Zbąszyń slept in poorly constructed barracks with very few provisions.»

## hungary_border_1939

- Hungarian patrols reached the Werecka Pass, also called the Tucholska Pass, on what had been the border of Poland with Czecho-Slovakia. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Po południu 16 marca patrole węgierskie dotarły do Przełęczy Wereckiej, nazywanej również Tucholską, na nieistniejącej już granicy Polski z Czecho-Słowacją.»
- At the Tucholska Pass in the Carpathians Polish troops welcomed the Hungarians coming from the south. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «na Przełęczy Tucholskiej w Karpatach oddziały polskie powitały nadciągających z południa Węgrów.»
- On the Polish side, Polish troops and an official delegation led by General Mieczysław Boruta-Spiechowicz awaited the Hungarians. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Po polskiej stronie na Węgrów oczekiwały oddziały Wojska Polskiego i oficjalna delegacja z gen. Mieczysławem Borutą-Spiechowiczem na czele.»
- Regent Horthy telegraphed his greetings to President Mościcki at the historic moment when a Hungarian soldier shakes the right hand of a Polish soldier on the Polish-Hungarian border. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Regent Królestwa Węgier admirał Miklós Horthy wystosował depeszę do prezydenta Ignacego Mościckiego, w której stwierdził: „W historycznej chwili, gdy na granicy polsko-węgierskiej żołnierz węgierski ściska prawicę żołnierza polskiego, przesyłam Waszej Ekscelencji i Narodowi polskiemu jak najserdeczniejsze pozdrowienia tak w swoim, jak i Narodu węgierskiego imieniu”.»
- A demonstration was held outside the Hungarian legation in Koszykowa street. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «17 marca pod siedzibą poselstwa węgierskiego przy ul. Koszykowej doszło do największej manifestacji.»
- The historical border was only 180 km long and lasted until the last days of September 1939 (not used in the text: in a game Hungary can hold more land along Poland's border). Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Nowa granica licząca zaledwie 180 km długości przetrwała do ostatnich dni września 1939 r.»
```

## Events source

The whole `source/poland/events.json` after the fixes.

```json events
{
    "pack": "poland",
    "tag": "POL",
    "namespace": "ep_pol",
    "displayName": "Poland",
    "events": [
        {
            "id": 1,
            "key": "kasprowy_cable_car",
            "title": "Cable Car Opens on Kasprowy Wierch",
            "desc": "On 15 March the cable car from Kuźnice to Kasprowy Wierch opened in the Tatra mountains. Work began on 1 August 1935 and lasted over seven months. The line is nearly 4300 metres long.\n\nIt is the first investment of its kind in Poland and the 60th in the world. It was built on the initiative of the president of the Polish Ski Association.",
            "picture": "kasprowy_cable_car",
            "factSheet": "kasprowy_cable_car",
            "anchors": [
                "Kuźnice",
                "Kasprowy Wierch",
                "15 March",
                "4300 metres",
                "Polish Ski Association"
            ],
            "fire": {
                "after": "1936.3.16",
                "before": "1936.4.30",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Keep the fares low enough for ordinary skiers.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Our ski patrols will use it too.",
                    "ai": 40,
                    "effects": [
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 2,
            "key": "batory_maiden_voyage",
            "title": "MS Batory Begins Her Maiden Voyage",
            "desc": "The liner Batory began her maiden voyage on 18 May. That day she left the Gdynia maritime station with 600 passengers aboard.\n\nShe belongs to the Gdynia-America Line and is the sister ship of MS Piłsudski. She was launched on 3 July 1935 and measures 14,287 GRT. This month she begins regular service on the Gdynia to New York run.",
            "picture": "batory_maiden_voyage",
            "factSheet": "batory_maiden_voyage",
            "anchors": [
                "Batory",
                "Gdynia",
                "18 May",
                "14,287 GRT",
                "Gdynia-America Line"
            ],
            "fire": {
                "after": "1936.5.19",
                "before": "1936.5.31",
                "chance": 100,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Let her sail as the nation's showpiece.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "She must pay her way on the Atlantic.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 10
                        }
                    ]
                }
            ]
        },
        {
            "id": 3,
            "key": "berlin_olympics_team",
            "title": "Poland Brings Six Medals Home from the Olympics",
            "desc": "The Olympic Games ran from 1 to 16 August. Poland sent 144 competitors, 127 men and 17 women, to 55 events in 15 sports. Stanisława Walasiewicz won silver in the women's 100 metres and Jadwiga Wajs silver in the women's discus throw.\n\nIn all the team won no gold medal, three silver and three bronze, and ranked 22nd.",
            "picture": "berlin_olympics_team",
            "factSheet": "berlin_olympics_team",
            "anchors": [
                "Stanisława Walasiewicz",
                "Jadwiga Wajs",
                "144 competitors",
                "22nd"
            ],
            "fire": {
                "after": "1936.8.17",
                "before": "1936.9.30",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Honour every medallist and every competitor.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Gold will come. Fund the clubs for the next Games.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -15
                        },
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 4,
            "key": "spitsbergen_crossing",
            "title": "Three Men Complete the First Traverse of Spitsbergen",
            "desc": "Stanisław Siedlecki, Stefan Bernadzikiewicz and Konstanty Narkiewicz-Jodko made the first traverse of Spitsbergen, from 7 July to 1 September. They crossed about 850 km. The expedition relied on its own resources, without any communication or support.\n\nShould the government receive the three men with honours, or leave that to others?",
            "picture": "spitsbergen_crossing",
            "factSheet": "spitsbergen_crossing",
            "anchors": [
                "Spitsbergen",
                "Bernadzikiewicz",
                "Siedlecki",
                "7 July",
                "850 km"
            ],
            "fire": {
                "after": "1936.9.2",
                "before": "1936.10.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Receive them in Warsaw with honours.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.01
                        }
                    ]
                },
                {
                    "name": "No state reception. Others can honour them.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 10
                        }
                    ]
                }
            ]
        },
        {
            "id": 5,
            "key": "rambouillet_loan",
            "title": "France Promises Poland a Loan of Two Billion Francs",
            "desc": "On 5 September Delbos gave a lunch for Rydz-Śmigły at the Quai d'Orsay.\n\nFrance has committed itself, in the agreement signed at Rambouillet, to a loan of two billion francs to Poland for its armament. Should the army spend it at once, or should we take care not to depend on Paris?",
            "picture": "rambouillet_loan",
            "factSheet": "rambouillet_loan",
            "anchors": [
                "Delbos",
                "Rydz-Śmigły",
                "Quai d'Orsay",
                "Rambouillet",
                "two billion francs"
            ],
            "fire": {
                "after": "1936.9.7",
                "before": "1936.10.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Spend it on arms for the army at once.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Take care to stay independent of Paris.",
                    "ai": 40,
                    "effects": [
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 6,
            "key": "pzl37_los_first_flight",
            "title": "The PZL.37 Łoś Bomber Flies for the First Time",
            "desc": "The prototype of the PZL.37 Łoś made its first flight on 13 December. The pilot, Jerzy Widawski, reported several shortcomings.\n\nThe order was for a modern, fast bomber to replace the outdated Fokker F.VII machines. Engineer Jerzy Dąbrowski prepared the plans, assisted by Piotr Kubicki and Franciszek Misztal. Should the bomber go into production at once?",
            "picture": "pzl37_los_first_flight",
            "factSheet": "pzl37_los_first_flight",
            "anchors": [
                "PZL.37 Łoś",
                "Jerzy Widawski",
                "Jerzy Dąbrowski",
                "Fokker F.VII",
                "13 December"
            ],
            "fire": {
                "after": "1936.12.14",
                "before": "1937.1.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Fix the shortcomings before it reaches the squadrons.",
                    "ai": 50,
                    "effects": [
                        {
                            "air_experience": 5
                        }
                    ]
                },
                {
                    "name": "Put it into production now.",
                    "ai": 50,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 7,
            "key": "gdynia_boom_1936",
            "title": "Gdynia Grows to 102,000 Inhabitants",
            "desc": "In May 1936 the city of Gdynia counted 83,000 inhabitants. In December it counted 102,000. The growth comes from workers who arrived from almost the whole country.\n\nAbout 30 percent of the people live in some 2,500 primitive huts and shacks. How should the city be built?",
            "picture": "gdynia_boom_1936",
            "factSheet": "gdynia_boom_1936",
            "anchors": [
                "Gdynia",
                "83,000",
                "102,000",
                "2,500 primitive huts and shacks"
            ],
            "fire": {
                "after": "1937.1.1",
                "before": "1937.3.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Build streets and houses for the new workers.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "gdynia_housing",
                            "days": 150
                        }
                    ]
                },
                {
                    "name": "Housing is for the city to pay, not the state.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 15
                        }
                    ]
                }
            ]
        },
        {
            "id": 8,
            "key": "chopin_competition_1937",
            "title": "Yakov Zak Wins the Third Chopin Competition",
            "desc": "The third Chopin Competition ran in Warsaw from 21 February to 13 March. Eighty pianists from 22 countries took part. Adam Wieniawski chaired the jury. The Soviet pianist Yakov Zak was awarded the first prize.\n\nChieko Hara of Japan, acclaimed by critics and the public, reached the final but was awarded only an honourable mention, and a commotion broke out. Fearing that the crowd would damage the Philharmonic, the industrialist Stanisław Meyer sponsored a special audience award for her.",
            "picture": "chopin_competition_1937",
            "factSheet": "chopin_competition_1937",
            "anchors": [
                "Yakov Zak",
                "Chieko Hara",
                "Stanisław Meyer",
                "Adam Wieniawski",
                "22 countries"
            ],
            "fire": {
                "after": "1937.3.14",
                "before": "1937.4.15",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "The jury has spoken. Congratulate the winner.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Found a prize for Polish music beside the competition.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -10
                        },
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 9,
            "key": "szymanowski_funeral",
            "title": "Karol Szymanowski Is Buried at Skałka",
            "desc": "Karol Szymanowski died on 29 March in a sanatorium at Lausanne. His body travelled by train, and the train stopped for commemorative ceremonies in Berlin, at the German-Polish border and in Poznań.\n\nThe Warsaw funeral took place on the morning of Tuesday 6 April in the Church of the Holy Cross. On Wednesday 7 April the coffin arrived in Kraków and was carried past Wawel to the church on Skałka. He is buried in the Crypt of the Distinguished there.",
            "picture": "szymanowski_funeral",
            "factSheet": "szymanowski_funeral",
            "anchors": [
                "Lausanne",
                "Church of the Holy Cross",
                "Wawel",
                "Skałka",
                "29 March"
            ],
            "fire": {
                "after": "1937.4.10",
                "before": "1937.5.10",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Keep the Crypt of the Distinguished for such men.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Raise a memorial at Skałka at the state's expense.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -10
                        },
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 10,
            "key": "wawel_coffin_1937",
            "title": "Archbishop Sapieha Moves Piłsudski's Coffin",
            "desc": "Archbishop Adam Sapieha decided to move Marshal Piłsudski's coffin to the crypt under the Silver Bells Tower. Against the state authorities, he ordered that the coffin be moved on 22 June. It was moved in the night of 23 to 24 June.\n\nThe Marshal's memorial committee and President Mościcki opposed the archbishop's decision. Because of the Wawel conflict, Prime Minister Składkowski handed in his government's resignation in protest. The President did not accept it.",
            "picture": "wawel_coffin_1937",
            "factSheet": "wawel_coffin_1937",
            "anchors": [
                "Adam Sapieha",
                "Silver Bells Tower",
                "Mościcki",
                "Składkowski",
                "22 June"
            ],
            "fire": {
                "after": "1937.7.1",
                "before": "1937.8.15",
                "chance": 50,
                "trigger": "has_war = no has_country_leader = { character = POL_ignacy_moscicki }"
            },
            "options": [
                {
                    "name": "Stand with the committee and the President.",
                    "ai": 50,
                    "effects": [
                        {
                            "political_power": 15
                        },
                        {
                            "stability": -0.01
                        }
                    ]
                },
                {
                    "name": "Settle it quietly with the archbishop.",
                    "ai": 50,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 11,
            "key": "independence_day_1937",
            "title": "Independence Day Is Celebrated as a State Holiday",
            "desc": "The law of 23 April gave Independence Day the rank of a state holiday. It is meant to link the regaining of state sovereignty with the end of the First World War and to commemorate Józef Piłsudski.\n\nUntil this year the celebrations in Warsaw were military ceremonies, usually held on the first Sunday after 11 November. This year they included the unveiling of a monument to General Józef Sowiński.",
            "picture": "vanilla:GFX_report_event_soldiers_parade",
            "factSheet": "independence_day_1937",
            "anchors": [
                "23 April",
                "11 November",
                "Józef Piłsudski",
                "General Józef Sowiński"
            ],
            "fire": {
                "after": "1937.11.11",
                "before": "1937.12.15",
                "chance": 100,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "A parade of the army through Warsaw.",
                    "ai": 50,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "A holiday for every town and village.",
                    "ai": 50,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 12,
            "key": "destroyers_grom_blyskawica",
            "title": "ORP Błyskawica Enters Service in the Polish Navy",
            "desc": "ORP Błyskawica entered service in the Polish Navy on 25 November. Her first commander is Tadeusz Podjazd-Morgenstern. She carries seven 120 mm guns and has a maximum speed of 39.6 knots.\n\nThe destroyer Grom was ordered from the British J. Samuel White shipyard in Cowes and was commissioned in 1937. The Grom class was designed both for shore defence and for convoy escort.",
            "picture": "destroyers_grom_blyskawica",
            "factSheet": "destroyers_grom_blyskawica",
            "anchors": [
                "Błyskawica",
                "Cowes",
                "Podjazd-Morgenstern",
                "39.6 knots",
                "25 November"
            ],
            "fire": {
                "after": "1937.11.26",
                "before": "1938.1.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Base both at Gdynia to guard the coast.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Train the crews at sea before anything else.",
                    "ai": 40,
                    "effects": [
                        {
                            "navy_experience": 5
                        }
                    ]
                }
            ]
        },
        {
            "id": 13,
            "key": "wilimowski_brazil_1938",
            "title": "Poland Loses 6-5 to Brazil at the World Cup",
            "desc": "On 5 June, at the Stade de la Meinau in Strasbourg, Brazil beat Poland 6-5.\n\nErnest Wilimowski scored four times, in the 53rd, 59th, 89th and 118th minutes. No player before him has scored four goals in a single World Cup match.",
            "picture": "wilimowski_brazil_1938",
            "factSheet": "wilimowski_brazil_1938",
            "anchors": [
                "Strasbourg",
                "Wilimowski",
                "6-5",
                "118th minute",
                "5 June"
            ],
            "fire": {
                "after": "1938.6.6",
                "before": "1938.6.30",
                "chance": 100,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "They gave the Brazilians a fight. Well played.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Five goals and still beaten. Next time we win.",
                    "ai": 40,
                    "effects": [
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 14,
            "key": "gordon_bennett_1938",
            "title": "Janusz and Janik Win the Gordon Bennett Cup",
            "desc": "Antoni Janusz and Franciszek Janik have won the Gordon Bennett Cup for 1938 in the balloon SP-BCU LOPP. The race started at Liège on 11 September, and they covered 1,692 km in 37 hours and 47 minutes.\n\nJanusz is an officer of the Polish Air Force. The cup was held in Warsaw in 1934, 1935 and 1936.",
            "picture": "gordon_bennett_1938",
            "factSheet": "gordon_bennett_1938",
            "anchors": [
                "Antoni Janusz",
                "Franciszek Janik",
                "Liège",
                "1,692 km",
                "SP-BCU LOPP"
            ],
            "fire": {
                "after": "1938.9.15",
                "before": "1938.10.15",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Praise the airmen who flew it.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.01
                        }
                    ]
                },
                {
                    "name": "Fund the balloon crews for next year's race.",
                    "ai": 40,
                    "effects": [
                        {
                            "air_experience": 5
                        }
                    ]
                }
            ]
        },
        {
            "id": 15,
            "key": "zbaszyn_refugees_1938",
            "title": "Polish Jews Expelled from Germany Are Sent to Zbąszyń",
            "desc": "In October about 17,000 Polish Jews living in Germany were arrested and expelled. Since March 1938 Polish citizenship can be revoked if the citizen has lived abroad for more than five years. Polish citizens living outside Poland had to obtain an endorsement stamp on their passports before 30 October.\n\nOf the expelled, 8,000 were sent to the town of Zbąszyń, where they sleep in poorly constructed barracks with very few provisions. The Polish Government quickly closed the border and denied any further access.",
            "picture": "vanilla:GFX_report_event_german_polish_border",
            "factSheet": "zbaszyn_refugees_1938",
            "anchors": [
                "Zbąszyń",
                "17,000",
                "30 October",
                "8,000"
            ],
            "fire": {
                "after": "1938.11.1",
                "before": "1938.12.31",
                "chance": 50,
                "trigger": "has_war = no GER = { has_government = fascism }"
            },
            "options": [
                {
                    "name": "Admit them and organise relief at Zbąszyń.",
                    "ai": 50,
                    "effects": [
                        {
                            "political_power": -20
                        },
                        {
                            "stability": 0.01
                        }
                    ]
                },
                {
                    "name": "Keep the border shut until Berlin negotiates.",
                    "ai": 50,
                    "effects": [
                        {
                            "political_power": 10
                        }
                    ]
                }
            ]
        },
        {
            "id": 16,
            "key": "hungary_border_1939",
            "title": "Polish and Hungarian Soldiers Meet at the Border",
            "desc": "Hungarian patrols reached the Werecka Pass, also called the Tucholska Pass, on what had been the border of Poland with Czecho-Slovakia. There, in the Carpathians, Polish troops welcomed the Hungarians coming from the south. An official delegation led by General Mieczysław Boruta-Spiechowicz awaited them.\n\nRegent Horthy telegraphed his greetings to President Mościcki 'at the historic moment when a Hungarian soldier shakes the right hand of a Polish soldier on the Polish-Hungarian border'. A demonstration was held outside the Hungarian legation in Koszykowa street.",
            "picture": "vanilla:GFX_report_event_generic_handshake",
            "factSheet": "hungary_border_1939",
            "anchors": [
                "Werecka Pass",
                "Boruta-Spiechowicz",
                "Horthy",
                "Mościcki",
                "Koszykowa"
            ],
            "fire": {
                "after": "1939.3.17",
                "before": "1939.12.31",
                "chance": 50,
                "trigger": "has_war = no NOT = { has_war_with = HUN } HUN = { owns_state = 73 has_country_leader = { character = HUN_miklos_horthy } } owns_state = 89 has_country_leader = { character = POL_ignacy_moscicki }"
            },
            "options": [
                {
                    "name": "A common border with Hungary is a gain.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Keep the celebrations quiet. Berlin is watching.",
                    "ai": 40,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 17,
            "key": "nanda_devi_east",
            "title": "Nanda Devi East Climbed, Two Climbers Lost",
            "desc": "The Polish Himalayan expedition was led by Adam Karpiński. Its members were Jakub Bujak, Stefan Bernadzikiewicz, Janusz Klarner and Major J. R. Foy. On 2 July Bujak and Klarner reached the 7434 m summit of Nanda Devi East.\n\nOn 18 July an avalanche came down on Camp III and buried Bernadzikiewicz and Karpiński. The party started early on 19 July and reached the edge of the hanging glacier by noon. They saw only a huge avalanche covering the site.",
            "picture": "nanda_devi_east",
            "factSheet": "nanda_devi_east",
            "anchors": [
                "Adam Karpiński",
                "Jakub Bujak",
                "Janusz Klarner",
                "2 July",
                "18 July"
            ],
            "fire": {
                "after": "1939.7.20",
                "before": "1939.9.30",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Honour the two who died and the two who stood on top.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Fund the next Polish expedition to the Himalaya.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -10
                        },
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 18,
            "key": "fon_1936",
            "title": "The National Defence Fund Gathers Gifts",
            "desc": "The National Defence Fund was created by a decree of the President. Its purpose is to obtain extra money for the rearmament of the army and for a military investment programme. The Ministry of National Defence manages it.\n\nSchoolchildren give their pocket money, and people give jewellery, precious coins and gold earrings. Janusz Kusociński gave a gold signet ring of 9.5 grams and Janina Kurkowska-Spychajowa eight silver cups.",
            "picture": "fon_1936",
            "factSheet": "fon_1936",
            "anchors": [
                "National Defence Fund",
                "Janusz Kusociński",
                "Kurkowska-Spychajowa",
                "9.5 grams"
            ],
            "fire": {
                "after": "1938.1.1",
                "before": "1947.12.31",
                "chance": 100,
                "trigger": "OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } has_war_with = GER } has_capitulated = no"
            },
            "options": [
                {
                    "name": "Put collection boxes in every shop and school.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Ask the firms and the councils to give first.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -10
                        },
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 19,
            "key": "pyry_enigma",
            "title": "French and British Representatives Come to Pyry",
            "desc": "French and British intelligence representatives have arrived in Warsaw. At seven in the morning they get into cars provided by the Polish staff. At Pyry, south of Warsaw, the Polish methods are revealed to them.\n\nMajor Maksymilian Ciężki gives a three-hour lecture on the history of the Polish struggle with the Enigma. Then the device is presented. Asked where they got it, Colonel Gwido Langer, head of the cipher bureau, answers: 'We made it ourselves.' Two copies are intended for the visitors, one for Paris and one for London.",
            "picture": "pyry_enigma",
            "factSheet": "pyry_enigma",
            "anchors": [
                "Pyry",
                "Maksymilian Ciężki",
                "Gwido Langer",
                "Enigma",
                "one for Paris and one for London"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 100,
                "trigger": "has_war = no OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } } FRA = { exists = yes has_capitulated = no NOT = { is_in_faction_with = GER } } ENG = { exists = yes NOT = { is_in_faction_with = GER } } owns_state = 10"
            },
            "options": [
                {
                    "name": "Share everything with Paris and London.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "pyry_cooperation",
                            "days": 120
                        }
                    ]
                },
                {
                    "name": "Show them only what they need to see.",
                    "ai": 40,
                    "effects": [
                        {
                            "command_power": 5
                        }
                    ]
                }
            ]
        },
        {
            "id": 20,
            "key": "westerplatte",
            "title": "Schleswig-Holstein Opens Fire on Westerplatte",
            "desc": "In the early morning Schleswig-Holstein fired a broadside at the Polish garrison at Westerplatte. Major Henryk Sucharski commands the garrison, and Captain Franciszek Dąbrowski is his second-in-command.\n\nStaff Sergeant Wojciech Najsarek was killed by machine-gun fire. What orders do we give the garrison?",
            "picture": "westerplatte",
            "factSheet": "westerplatte",
            "anchors": [
                "Schleswig-Holstein",
                "Henryk Sucharski",
                "Franciszek Dąbrowski",
                "Wojciech Najsarek",
                "Westerplatte"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 100,
                "trigger": "has_war_with = GER owns_state = 85 controls_state = 85 NOT = { war_length_with = { tag = GER months > 1 } }"
            },
            "options": [
                {
                    "name": "Hold to the last man.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Save the men if the position cannot be held.",
                    "ai": 40,
                    "effects": [
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        }
    ],
    "ideas": [
        {
            "key": "gdynia_housing",
            "name": "Housing for Gdynia",
            "desc": "Streets and houses are built for the workers who came to Gdynia.",
            "picture": "generic_political_support",
            "modifier": {
                "production_speed_buildings_factor": 0.03
            }
        },
        {
            "key": "pyry_cooperation",
            "name": "Cipher Cooperation",
            "desc": "French and British experts work on the Polish methods.",
            "picture": "generic_research_bonus",
            "modifier": {
                "research_speed_factor": 0.02
            }
        }
    ]
}
```
