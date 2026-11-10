# Finland pack: tighter triggers, date-free Winter War events

Status: DONE
Pack: finland (FIN, namespace ep_fin)
Kind: audit fixes
Created: 2026-11-10

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block holds, with `"mergeById": true`, only the events this plan changes, each as its whole object, and the `markdown fact-sheets` block holds the two fact-sheet sections it replaces. No picture changes. Step 1 writes both blocks with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

The owner asked for a check of every released pack's triggers: does each event fire only in a game where its text is true, also off the historical path (a leader replaced, a regime changed, a war that starts on another date or the other way round)? A `trigger-checker` agent on Opus checked all 15 Finland events against the game files (1.19.4.2) on 2026-11-09; the planner reviewed its report and reran the claims the fixes rest on. This plan holds the report, the owner's decisions and the approved fixes: seven events get a new trigger, and three of them (the Winter War events) also lose the dates in their text and get a wide window, as the mod's war rule asks. The pack predates that rule. Facts and pictures were not rechecked: no fact changes, the texts only lose dates.

## Audit report

How a gap was weighed: a human reads an event only while playing Finland. A gap counts when a plain historical game, a non-historical AI or the Finland player's own choice of another branch can open it; a gap that only a human-run other country or a conquest can open gets a pin only when the pin is one cheap leaf.

### Critical

1. `league_expulsion_1939`, `tolvajarvi_victory`, `finnish_relief_fund` (war events): the only gate is `has_war_with = SOV`, which also holds when Finland is the attacker (`FIN_soviet_threat`, `FIN_red_finland`, the Continuation-war events) and says nothing about when the war began. The texts name December dates and the windows are narrow, against the war rule (`docs/source-format.md`, `fire.trigger`): with a Soviet attack after the named date the text is false, and with one after the window the event is lost.

### Important

2. `yartsev_talks_1938`: the text names "the Cajander government" and Foreign Minister Holsti, Finland fortifying Åland, islands near Leningrad and a German invasion. The trigger only excludes a communist Finland. A non-historical AI re-elects Svinhufvud in about one game in three (`AAT_finland_political.02` option a, `events/AAT_Finland.txt:4317-4333`); a player can take Finland fascist or monarchist; Sweden can take Åland (`SWE_the_aland_issue`); an accepted `finland.1` cedes Karelia.
3. `holsti_resignation`: the coalition cabinet, a Social Democrat as acting minister and "the cabinet feared German retaliation" under another Finnish or German regime.
4. `election_1939`: "The Cajander government stays in office" also fires under a democratic-party government or a re-elected Svinhufvud (the gate is `OR = { has_government = democratic has_government = neutrality }`).
5. `taisto_maki_record`: no trigger at all; a race at the Helsinki Olympic Stadium can fire while Finland is at war (a non-historical Soviet Union can attack from 1937).

### Minor

6. `red_earth_government`: "president since 1 March. After his election" is false when a player removed Svinhufvud earlier through the no-confidence decision (AI weight 0). No vanilla state tells that route apart; left as it is.
7. `tolvajarvi_victory`: "the first major Finnish victory of the war" stays in the text. The new gate fires the event from the second week of the war.

### Intentionally unchanged

`berlin_1936_olympics`, `red_earth_government`, `aalto_world_fairs`, `vickers_six_ton_tanks`, `maternity_grant_1937`, `record_year_1937`, `olympics_1940_awarded`, `sillanpaa_nobel`: the text names no office holder or regime the trigger leaves open, or the gap cannot open before the window closes. The cabinet members (Cajander, Holsti, Tanner) are not modelled; President Kallio as the ruling leader is the gate that stands for the cabinet, as `red_earth_government` already has it.

## Decisions

Owner, 2026-11-10:
- War events lose their fixed dates: text without dates, wide window, gate on the state of the war.
- The cheap pins are added.
- A 1939-start game has Kyösti Kallio as president, so the Kallio gate is right for `election_1939` in both starts.

Planner's choices inside those decisions:
- "The Soviet Union attacked Finland and that war is still on" is the vanilla flag `FIN_winter_war_ongoing_flag`: set once, when the attacker's tag is SOV and the defender's FIN (`common/on_actions/07_nsb_on_actions.txt:1593-1607`, no DLC check), cleared at peace (`09_aat_on_actions.txt:1670-1673`). "How long ago" is the flag's `days >` (`documentation/triggers_documentation.md:3624`).
- Days into the war: `league_expulsion_1939` and `tolvajarvi_victory` more than 10 (historically day 14 and day 12), `finnish_relief_fund` more than 90 (the fund's 2.5 million dollars are its figure for March 1940, about day 95).
- Windows open on 1939.1.1 (the men and posts the texts name are those of 1939). They close where the text would stop being possible: `league_expulsion_1939` at the end of 1945 (the League was dissolved in 1946), `finnish_relief_fund` at the end of 1943 (van Loon died in March 1944), `tolvajarvi_victory` at the end of 1947 as the Poland pack's war events do.
- `finnish_relief_fund` loses the sentence on the first screening of Gone with the Wind (round 2 of the trigger check): it is a fixed event of the winter of 1939 to 1940, false in every war that begins after it, and a historical AI starts the war in 1940 or later. The planner's first repair (a closing question, "How should we use it?", to stay above the floor of 40 words) did not survive the editor: it implied that Finland spends Hoover's money. The text in the block is the editor's ("Editor record").
- The checker's `has_character = FIN_paavo_talvela` leaf is left out (a player-only Red Finland, and the flag already excludes Finland as the attacker). Its date test `date <` is not in the documentation; `days >` is.

## Events

Only the events this plan changes. Pictures, options and effects stay as they are.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 7 | yartsev_talks_1938 | A Soviet Diplomat Opens Secret Talks | 1938.6.1 to 1938.8.31 | 10 | unchanged | unchanged |
| 9 | holsti_resignation | Foreign Minister Holsti Resigns | 1938.11.17 to 1938.11.30 | 30 | unchanged | unchanged |
| 10 | election_1939 | Social Democrats Win 85 Seats | 1939.7.3 to 1939.8.15 | 50 | unchanged | unchanged |
| 11 | taisto_maki_record | Taisto Mäki Runs 10,000 Metres Under 30 Minutes | 1939.9.17 to 1939.10.31 | 50 | unchanged | unchanged |
| 13 | league_expulsion_1939 | The League of Nations Expels the Soviet Union | 1939.1.1 to 1945.12.31 (was 1939.12.14 to 1940.1.31) | 50 | unchanged | unchanged |
| 14 | tolvajarvi_victory | Detachment P Defeats the Enemy at Tolvajärvi | 1939.1.1 to 1947.12.31 (was 1939.12.13 to 1940.1.31) | 50 | unchanged | unchanged |
| 15 | finnish_relief_fund | Hoover's Relief Fund Raises 2.5 Million Dollars | 1939.1.1 to 1943.12.31 (was 1940.3.1 to 1940.4.30) | 100 | unchanged | unchanged |

New triggers:

| Key | `fire.trigger` |
|---|---|
| yartsev_talks_1938 | `has_war = no has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio } owns_state = 145 owns_state = 146 SOV = { has_government = communism } GER = { has_government = fascism }` |
| holsti_resignation | `has_war = no has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio } GER = { has_government = fascism }` |
| election_1939 | `has_war = no has_elections = yes has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio }` |
| taisto_maki_record | `has_war = no` |
| league_expulsion_1939 | `has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 10 } has_capitulated = no SOV = { has_government = communism }` |
| tolvajarvi_victory | `has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 10 } has_capitulated = no SOV = { has_government = communism } controls_state = 146` |
| finnish_relief_fund | `has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 90 } NOT = { has_government = fascism has_government = communism } USA = { has_government = democratic NOT = { has_war_with = FIN } }` |

Text changes (the block holds the texts; this is what differs from the shipped ones):
- `league_expulsion_1939`: the dates of 11, 13 and 14 December are out; "Geneva has answered our appeal." is out (no page names the place); the finding is given to "The Council of the League of Nations"; the option "Thank Geneva, and look for help elsewhere." becomes "Thank the League, and look for help elsewhere."; anchor "14 December" dropped.
- `tolvajarvi_victory`: "at 5 pm on 12 December" becomes "at 5 pm"; "His Detachment P, part of Group T, has beaten the Soviet 139th Rifle Division." becomes "His Detachment P is part of Group T. The Soviet 139th Rifle Division began a disorderly retreat after the Finnish forces launched their offensive."; anchor "12 December" dropped.
- `finnish_relief_fund`: the description is now "Former U.S. President Herbert Hoover started the Finnish Relief Fund. He appeared at Madison Square Garden with Hendrik Willem van Loon and Fiorello La Guardia. The fund advertises in 1,400 American newspapers." and "So far the fund has raised 2.5 million dollars."; the dates and the Gone with the Wind sentence are out; the option "Spend it on relief at home." becomes "Thank Mr Hoover, and ask for nothing more."; anchor "20 December" dropped.

## Pictures

No picture changes.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|

Thumbnail: unchanged

Pack intro: unchanged

Bundle intro: unchanged

## Fact verification

The audit checked triggers; facts were rechecked only where the editor asked. His first round over the three rewritten texts found claims that sat on a fact line but in no quote, so one `ep-audit-researcher` rechecked the three sections on their pages (2026-11-10, 12 web calls).

- `tolvajarvi_victory`: 5 kept, 2 fixed, 0 dropped. Kept: Detachment P under Paavo Talvela's Group T and the first major victory (now with the sentences that say so), Pajari's 5 pm report, the promotions, the museum's casualty line. New line with its own quote: Detachment P was commanded by Lieutenant Colonel Aaro Pajari. Fixed: no page says in one sentence that the 139th Rifle Division was "defeated" on 12 December; the page says it "began a disorderly retreat" after the Finnish forces launched their offensive, and the event text now says that. Fixed: the rest on 13 December and the Ägläjärvi front on 17 December are on talvisota.fi only, not on Wikipedia; the line cites that page alone (not used in the event text; not fetched again in this round).
- `league_expulsion_1939`: 3 kept, 1 fixed, 1 dropped. Kept: the Assembly's Special Committee, the resolution's two sentences, Argentina's demand. Fixed: "the Council expelled the Soviet Union on 14 December" had no quote; it is its own line now, with the sentence of talvisota.fi and the resolution's heading. Dropped: "Geneva" (the shipped text said "Geneva has answered our appeal"); no page fetched names the place, and the text no longer does.
- `finnish_relief_fund`: 4 kept, 0 fixed, 1 dropped. The section stays as it is. Dropped: that the Finnish government decides how the fund's money is spent (the shipped option "Spend it on relief at home."); no page says who decided, and the option is now "Thank Mr Hoover, and ask for nothing more."

The dossiers' `Checked:` lines for these three take their counts from here.

## Trigger verification

Round 1, `trigger-checker` on Opus over `source/finland/events.json`, 2026-11-09 (`Test-HoiConditions.ps1 -Events`: 15 events, 4 hold, 11 open, 0 dead): 8 OK, 7 FIX, 0 OPEN.

| Event | Verdict |
|---|---|
| berlin_1936_olympics, red_earth_government, aalto_world_fairs, vickers_six_ton_tanks, maternity_grant_1937, record_year_1937, olympics_1940_awarded, sillanpaa_nobel | OK |
| yartsev_talks_1938 | FIX: Kallio as ruling leader, Åland (145) and Karelia (146) Finnish, USSR communist, Germany fascist. The checker's `NOT = { has_government = communism }` is left out: Kallio leads only the non-aligned government (`common/characters/FIN.txt:28-40`). |
| holsti_resignation | FIX: Kallio as ruling leader, Germany fascist. |
| election_1939 | FIX: Kallio as ruling leader in place of the `OR` of two ideologies. The checker's open point (the 1939 start's leader) is settled by the owner: Kallio. |
| taisto_maki_record | FIX: `has_war = no`. |
| league_expulsion_1939, tolvajarvi_victory, finnish_relief_fund | FIX: the Winter War flag in place of bare `has_war_with = SOV`; the checker's fix kept the dated texts and pinned the flag's date, the plan follows the owner's decision instead (text without dates, `days >`). |

Planner's own lookups: the flag's setter and clearer (`Find-HoiUsage.ps1 FIN_winter_war_ongoing_flag -Context`, and the `on_war_relation_added` block read at `07_nsb_on_actions.txt:1493-1607`); the `has_country_flag` block form (`Find-HoiDoc.ps1 -Name has_country_flag`); the election event (`Get-HoiEvent.ps1 AAT_finland_political.02`) and its caller without a DLC check (`history/countries/FIN - Finland.txt:629`).

Round 2, `trigger-checker` on Opus over this plan's block, 2026-11-10 (`Test-HoiConditions.ps1 -Events`: 7 open, 0 dead): 6 OK, 1 FIX (text), 0 OPEN. No leaf blocks the plain historical game.

What it showed about the war itself: with the historical AI the Soviet attack comes in 1940 or later. `SOV_secure_leningrad` (`common/ai_strategy_plans/SOV_historical_strategy_plan.txt:89`) needs `SOV_claims_in_baltic`, which the plan's own comment puts at 1940 (`:87`); from the 1939 start two 70-day focuses are still ahead, so `finland.1` comes on 1940.1.1 at the earliest. The shipped windows (to 1940.1.31, and March to April 1940) could meet that war only when it began in January 1940.

| Event | Round 2 |
|---|---|
| yartsev_talks_1938 | OK. Åland, Karelia, the Soviet and German regimes hold from the start data; Kallio from 1937.3.2 with the historical AI. About 13 checks at 10 per cent (about 75 per cent that it fires, as before). |
| holsti_resignation | OK. 1 or 2 checks at 30 per cent in a 13-day window (as before). |
| election_1939 | OK. `elections_allowed = yes` in both starts (`history/countries/FIN - Finland.txt:618`, `:637`). The 1939 start opens on 8.14 and the window closes on 8.15, so it gets at most one check there (the window is the shipped one). |
| taisto_maki_record | OK. Finland is at peace in September and October 1939 in a historical game. |
| league_expulsion_1939, tolvajarvi_victory | OK. The block form with `days >` is documented and used by vanilla (`common/decisions/AUS.txt:2516-2518`). The flag is set once per game (its setter needs `NOT = { has_global_flag = SOV_winter_war_flag }` and nothing clears that global flag) and cannot be cleared while the war is on, so the count never restarts; only the first Soviet attack of a game gets the events. From day 11 of the war, one 50 per cent check a week: about 13 checks in a war of the historical 105 days. |
| finnish_relief_fund | FIX, applied to the text: the Gone with the Wind sentence removed (see "Decisions"). The trigger stays. At chance 100 it fires at the first check after day 90, if the war lasts that long: `finland.7` offers peace once Finland's surrender progress passes 0.25 (`events/Finland.txt:313-375`), and a human Finland ends the war only by choosing it or by capitulating. |

Unverified and outside the historical game: whether the flag is cleared when the Winter War ends while Finland is still at war with a third country (`on_peace`); whether the flag is set when the Soviets join an ally's war on Finland. In both cases the events are missed or fire as a Soviet war; no text turns false.

Round 3, `trigger-checker` on Opus over the three war events after the editor's changes (its questions 3 and 4), 2026-11-10: 2 OK, 1 FIX, 0 OPEN.

| Event | Round 3 |
|---|---|
| league_expulsion_1939 | OK. No sentence or option assumes anything the trigger leaves open; the window closes before the League's dissolution. With the historical AI the event fires from mid-January 1940. |
| tolvajarvi_victory | FIX, applied: `controls_state = 146`. The editor had asked who holds the ground. Tolvajärvi lies in state 146 Karjala by the map's geometry (`Get-HoiProvinceMap`, against the provinces of Viipuri, Joensuu and Kuopio; no file names it), Finnish-owned and Finnish-controlled at the start (`history/states/146-Karelia.txt:1`). The leaf stops the event once the Soviets control Karelia, the case where "Keep pressing east" reads falsest. It does not test the Tolvajärvi sector itself: a province leaf would lose the event in many normal wars, because the Soviet AI takes that sector in the first weeks, and historically Pajari's attack was a counter-attack into ground the 139th had taken. Unverified: how the engine decides who controls a state whose provinces are split. |
| finnish_relief_fund | OK. Hoover has been a former president since 1933; the trigger keeps the United States democratic and at peace with Finland, which "Ask Washington for arms credits as well." needs. With the historical AI the event comes in April 1940 or later, if Finland holds out past day 90. |

## Editor record

`ep-editor`, round 1 over the three rewritten texts (this plan's block as the draft, `source/finland/fact-sheets.md` as the fact sheet), 2026-11-10: 0 KEEP, 2 REWRITE, 1 REJECT. The editor judges the whole text against the fact sheet, so it found more than the dates:
- `league_expulsion_1939` REWRITE, applied as given: "Geneva" is in no fact; no quote named the Council.
- `finnish_relief_fund` REWRITE, applied as given: the planner's closing question and the shipped option "Spend it on relief at home." both had Finland spend the fund's money, which no fact says; "has started" was the wrong tense for an event that fires three months into the war. New description and first option as in "Events".
- `tolvajarvi_victory` REJECT: "Detachment P", "Aaro Pajari" and the "139th Rifle Division" were on a fact line whose quote did not carry them. The researcher read the pages again ("Fact verification"); the section in this plan's fact-sheets block is the result, and the sentence on the 139th now says what the page says.

Round 2 over the three, with this plan's fact-sheets block as the fact sheet for the first two: `tolvajarvi_victory` KEEP, `finnish_relief_fund` KEEP, `league_expulsion_1939` REWRITE, applied as given: the finding is the Council's, and the text named only the Assembly before it, so "The Council of the League of Nations finds". The editor's note on the fact line of the 139th (its quotes say neither "Soviet" nor "at Tolvajärvi") is applied to the line. Its note on mechanics (nothing checks that Finland holds the ground at Tolvajärvi) went to the trigger check's round 3.

Round 3 over `league_expulsion_1939`: KEEP. Its note on the fact line of Argentina (the quote says "in his address", not "told the Assembly") is applied to the line. Every one of the three texts is KEEP in its latest round.

## Kept on judgment

None. The gate rehearsal of 2026-11-10 (a copy under `scratch\rehearsal`) ran steps 1 to 9 as written: `-ApplyPlan` `Applied`, 2 files written, events 7, 9, 10, 11 (fire), 13 and 15 (desc, anchors, fire, options) and 14 (desc, anchors, fire) changed, 8 unchanged, the fact-sheet sections `league_expulsion_1939` and `tolvajarvi_victory` replaced; the dry run `0 file(s) would be written`; `-ConvertPictures` `failed=0`; `-Generate` 15 events, 13 files written; `-Check` OK with 0 warnings, `Bundle 'all': 4 member(s), 0 error(s)`; `-RenderEvents` 15 events with no `[WARN]`; `-ValidateOnly` succeeded. The renders of 13, 14 and 15 were opened: every title fits its line, no option runs over, each text reads cleanly in the window. The contact sheet shows the twelve other cards whole (their files differ from the repository's renders only because those were drawn by an earlier version of the renderer). The render hashes are in `scratch\render-hashes-finland.txt`.

One thing for the owner to know, not a warning: the picture of `finnish_relief_fund` is the Madison Square Garden poster, which reads "Wednesday, December 20th". The text names no date; the photograph shows one.

## Implementation steps

- [x] 1. Write the source from the block below: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-finland-trigger-audit.md`: expect `Applied 2026-11-10-finland-trigger-audit.md`, with no `[WARN]` outside "Kept on judgment", the events it lists as changed being ids 7, 9, 10, 11, 13, 14 and 15, and the fact-sheet sections it lists as replaced being `league_expulsion_1939` and `tolvajarvi_victory`. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [x] 2. Check that the source holds the block: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-finland-trigger-audit.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [x] 3. No pictures to fetch (the table is empty).
- [x] 4. Thumbnail unchanged: nothing to run.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack finland`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack finland`: expect `Generated pack 'finland'`. The intro texts stay as they are.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack finland`: expect `Check OK` and `Bundle 'all': 4 member(s), 0 error(s)`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack finland`: expect `Rendered 15 events to ...artifacts\workshop-images\finland`, with no `[WARN]` outside "Kept on judgment". The cards of ids 13, 14 and 15 change; the owner uploads them where the Workshop page shows them.
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly`: expect `Validation succeeded.` (the full suite runs once, in `event-pack-implement` 3.2).
- [x] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `fix(finland): tighter triggers, Winter War events without fixed dates`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The Workshop upload is `event-pack-release`.
- [ ] 11. Owner, in game (not the implementer): in a game as Finland, check that the three Winter War events fire after the Soviet attack (`league_expulsion_1939` and `tolvajarvi_victory` from the second week, `finnish_relief_fund` after about three months) and not when Finland attacks first. `ep_fin_all` fires the events without their triggers, so it does not test this.

## Stop conditions

- `-ApplyPlan`, `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.
- `-ApplyPlan` lists an event other than ids 7, 9, 10, 11, 13, 14 and 15 as changed, or a fact-sheet section other than `league_expulsion_1939` and `tolvajarvi_victory` as replaced: stop.

## Outcome

2026-11-10. `-Check -Pack finland`: `Check OK: 1 pack(s), 1 bundle(s), 0 warning(s).` (`Bundle 'all': 4 member(s), 0 error(s)`). `-ApplyPlan` changed events 7, 9, 10, 11, 13, 14, 15 and replaced fact-sheet sections `league_expulsion_1939` and `tolvajarvi_victory`; the dry run wrote 0 files; `-ConvertPictures` failed=0; `-Generate` 15 events, 13 files written; `-RenderEvents` 15 events, no `[WARN]`; `-ValidateOnly` succeeded (its full-repository check printed three France picture `[WARN]` lines, not Finland's). No deviations. Steps 10 and 11 (ship, owner in game) are left for the caller and the owner.

## Fact sheets

Two sections, from the researcher's recheck of 2026-11-10 ("Fact verification"). `finnish_relief_fund` stays as it is.

```markdown fact-sheets
## league_expulsion_1939

- On 11 December 1939 the League Assembly, having heard the delegate of Finland, set up a Special Committee to study Finland's appeal. Source: https://www.cambridge.org/core/journals/american-journal-of-international-law/article/was-the-soviet-union-expelled-from-the-league-of-nations/A5C41801CC250E9FE0E36DEB41DF030C (Was the Soviet Union Expelled from the League of Nations?, AJIL, note 32). Quote: «On December 11, 1939, the Assembly, having heard the statement of the Delegate of Finland, decided to set up a Special Committee to study the appeal of the Finnish Government.»
- On 14 December 1939 the Council of the League of Nations decided to expel the Soviet Union. Source: https://talvisota.fi/en/politics-of-the-winter-war/ (Politics of the Winter War); https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations). Quote: «In a meeting held on 14 December, the Council of the League of Nations decided to expel the Soviet Union.» «Council of the League of Nations, Resolution. December 14, 1939»
- The Council's resolution: 'Finds that, by its act, the Union of Soviet Socialist Republics has placed itself outside the League of Nations. It follows that the Union of Soviet Socialist Republics is no longer a Member of the League.' Source: https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations). Quote: «Council of the League of Nations, Resolution. December 14, 1939» «Finds that, by its act, the Union of Soviet Socialist Republics has placed itself outside the League of Nations.» «It follows that the Union of Soviet Socialist Republics is no longer a Member of the League.»
- On 13 December 1939 the delegate of Argentina stated in his address that the Soviet Union had 'placed itself outside the Covenant' and demanded its expulsion from the League. Source: https://www.cambridge.org/core/journals/american-journal-of-international-law/article/was-the-soviet-union-expelled-from-the-league-of-nations/A5C41801CC250E9FE0E36DEB41DF030C (Was the Soviet Union Expelled from the League of Nations?, AJIL, note 32). Quote: «The delegate of the Argentine in his address of December 13, 1939, stated that the Soviet Union had "placed itself outside the Covenant" and, demanding "the expulsion of the Soviet Union from the League of Nations,"»

## tolvajarvi_victory

- On 12 December 1939 Detachment P, under Paavo Talvela's Group T, defeated an enemy rifle division at Tolvajärvi, the first major Finnish victory of the Winter War. Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «At Tolvajärvi, Detachment P, which was subordinate to Paavo Talvela's Group T, defeated an enemy rifle division on 12 December» «The victory achieved in Tolvajärvi was the first major Finnish victory of the Winter War.»
- Detachment P was commanded by Lieutenant Colonel Aaro Pajari. Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «Detachment P was commanded by Lieutenant Colonel Pajari.» «the regiment was commanded by Lieutenant Colonel Aaro Pajari»
- The 139th Rifle Division, commanded by Brigade Commander Nikolay I. Belyaev, began a disorderly retreat from its positions after the Finnish forces launched their offensive. Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «the 139th Rifle Division, commanded by Brigade Commander Nikolay I. Belyaev» «Having been about to launch its own attack, the 139th Rifle Division began a disorderly retreat» «from its positions after the Finnish forces launched their offensive.»
- Pajari reported to Talvela at 5 pm on 12 December: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «Lieutenant Colonel Pajari reported to Talvela on the day's battles at 5pm on 12 December as follows: "Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.»
- During the battle, or soon after the victory, Talvela was promoted to major general and Pajari to colonel. Source: https://en.wikipedia.org/wiki/Battle_of_Tolvajärvi (Battle of Tolvajärvi); https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «During the battle, Talvela was promoted to Major General and Pajari to full Colonel.» «Soon after the victory, the commander-in-chief promoted Talvela to major general and Pajari to colonel.»
- After a day's rest on 13 December the Finnish forces advanced and reached the Ägläjärvi front on 17 December (not used in the event text). Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «after a day's rest on 13 December» «The Finnish forces advanced to the front of Ägläjärvi (Yaglyayarvi) on 17 December»
- About 100 Finns were killed in the day's attack and ten times as many Soviet soldiers in the battle; 20 tanks and 60 machine guns were captured (one museum source; other accounts differ). Source: https://infotaulu.museomilitaria.fi/en/winter-war/examples-from-ladoga-karelia (Winter war). Quote: «Finnish casualties in the day's attack were about 100 killed. Ten times as many Russians were killed in the battle.» «The Finns captured guns worth of two artillery batteries, 20 tanks and 60 machine guns.»
```

## Events source

The seven events this plan changes, each as its whole object with its id unchanged (`docs/source-format.md`, "Plans").

```json events
{
    "pack": "finland",
    "tag": "FIN",
    "mergeById": true,
    "events": [
        {
            "id": 7,
            "key": "yartsev_talks_1938",
            "title": "A Soviet Diplomat Opens Secret Talks",
            "desc": "Boris Yartsev, a second-class secretary at the Soviet embassy, has opened secret talks with the government on Moscow's behalf. Moscow offers all possible economic and military help if Finland fights a German invasion. In return it wants Finland to cede or lease some islands near Leningrad, and it would permit Finland to fortify Åland.\n\nForeign Minister Rudolf Holsti is away, and members of the Cajander government are hearing the offer. How should we answer?",
            "picture": "vanilla:GFX_report_event_generic_conference",
            "factSheet": "yartsev_talks_1938",
            "anchors": [
                "Boris Yartsev",
                "Rudolf Holsti",
                "Åland",
                "Leningrad"
            ],
            "fire": {
                "after": "1938.6.1",
                "before": "1938.8.31",
                "chance": 10,
                "trigger": "has_war = no has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio } owns_state = 145 owns_state = 146 SOV = { has_government = communism } GER = { has_government = fascism }"
            },
            "options": [
                {
                    "name": "Keep listening, and promise nothing.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": 15
                        }
                    ]
                },
                {
                    "name": "No Finnish island is for lease.",
                    "ai": 40,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 9,
            "key": "holsti_resignation",
            "title": "Foreign Minister Holsti Resigns",
            "desc": "Rudolf Holsti has resigned as foreign minister. On 7 November our envoy Aarne Vuorimaa reported accusations against him made by State Secretary Ernst von Weizsäcker. The cabinet feared German retaliation and wanted Holsti to step down.\n\nVäinö Voionmaa of the Social Democrats is acting foreign minister.",
            "picture": "holsti_resignation",
            "factSheet": "holsti_resignation",
            "anchors": [
                "Rudolf Holsti",
                "Aarne Vuorimaa",
                "Ernst von Weizsäcker",
                "Väinö Voionmaa"
            ],
            "fire": {
                "after": "1938.11.17",
                "before": "1938.11.30",
                "chance": 30,
                "trigger": "has_war = no has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio } GER = { has_government = fascism }"
            },
            "options": [
                {
                    "name": "Name a minister Berlin cannot object to.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": 20
                        }
                    ]
                },
                {
                    "name": "We choose our ministers, not Berlin.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -20
                        },
                        {
                            "war_support": 0.02
                        }
                    ]
                }
            ]
        },
        {
            "id": 10,
            "key": "election_1939",
            "title": "Social Democrats Win 85 Seats",
            "desc": "The votes of the 1 and 2 July election are counted. The Social Democrats hold 85 seats with 39.77 per cent of the vote, and the Agrarian League 56. The National Coalition has 25, the Swedish People's Party 18, IKL 8 and the National Progressive Party 6. IKL drew 86,219 votes.\n\nTurnout was 66.55 per cent: 1,302,348 of 1,956,807 registered voters. The Cajander government stays in office.",
            "picture": "election_1939",
            "factSheet": "election_1939",
            "anchors": [
                "85 seats",
                "39.77 per cent",
                "66.55 per cent"
            ],
            "fire": {
                "after": "1939.7.3",
                "before": "1939.8.15",
                "chance": 50,
                "trigger": "has_war = no has_elections = yes has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio }"
            },
            "options": [
                {
                    "name": "Carry on as before.",
                    "ai": 70,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Spend on welfare while the mandate is fresh.",
                    "ai": 30,
                    "effects": [
                        {
                            "political_power": -25
                        },
                        {
                            "stability": 0.03
                        }
                    ]
                }
            ]
        },
        {
            "id": 11,
            "key": "taisto_maki_record",
            "title": "Taisto Mäki Runs 10,000 Metres Under 30 Minutes",
            "desc": "At the Olympic Stadium in Helsinki on 17 September, Taisto Mäki ran 10,000 metres in 29:52.6, breaking his own world record. No man has run the distance in under 30 minutes before.\n\nHe first broke the record in Tampere on 29 September 1938, running 30:02.0 and beating Ilmari Salminen's old mark by more than three seconds.",
            "picture": "taisto_maki_record",
            "factSheet": "taisto_maki_record",
            "anchors": [
                "Taisto Mäki",
                "29:52.6",
                "17 September"
            ],
            "fire": {
                "after": "1939.9.17",
                "before": "1939.10.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Put it on every front page.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.01
                        },
                        {
                            "war_support": 0.01
                        }
                    ]
                },
                {
                    "name": "A fine run, but the cabinet has other business.",
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
            "id": 13,
            "key": "league_expulsion_1939",
            "title": "The League of Nations Expels the Soviet Union",
            "desc": "The League Assembly has heard Finland's delegate and set up a Special Committee to study our appeal. The delegate of Argentina demanded the expulsion of the Soviet Union.\n\nThe Council of the League of Nations finds that the Union of Soviet Socialist Republics 'has placed itself outside the League of Nations.' It is no longer a member.",
            "picture": "league_expulsion_1939",
            "factSheet": "league_expulsion_1939",
            "anchors": [
                "Argentina",
                "Special Committee"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1945.12.31",
                "chance": 50,
                "trigger": "has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 10 } has_capitulated = no SOV = { has_government = communism }"
            },
            "options": [
                {
                    "name": "Now ask the members for arms.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.03
                        }
                    ]
                },
                {
                    "name": "Thank the League, and look for help elsewhere.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 25
                        }
                    ]
                }
            ]
        },
        {
            "id": 14,
            "key": "tolvajarvi_victory",
            "title": "Detachment P Defeats the Enemy at Tolvajärvi",
            "desc": "Lieutenant Colonel Aaro Pajari reported to Paavo Talvela at 5 pm: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' His Detachment P is part of Group T. The Soviet 139th Rifle Division began a disorderly retreat after the Finnish forces launched their offensive. It is the first major Finnish victory of the war.\n\nAbout 100 Finns were killed in the day's attack. The Soviet dead in the battle are put at ten times as many, and 20 tanks and 60 machine guns were captured. Talvela is promoted to major general and Pajari to colonel.",
            "picture": "tolvajarvi_victory",
            "factSheet": "tolvajarvi_victory",
            "anchors": [
                "Aaro Pajari",
                "Paavo Talvela",
                "139th Rifle Division"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 50,
                "trigger": "has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 10 } has_capitulated = no SOV = { has_government = communism } controls_state = 146"
            },
            "options": [
                {
                    "name": "Keep pressing east.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.03
                        }
                    ]
                },
                {
                    "name": "Hold the line and rest the men.",
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
            "id": 15,
            "key": "finnish_relief_fund",
            "title": "Hoover's Relief Fund Raises 2.5 Million Dollars",
            "desc": "Former U.S. President Herbert Hoover started the Finnish Relief Fund. He appeared at Madison Square Garden with Hendrik Willem van Loon and Fiorello La Guardia. The fund advertises in 1,400 American newspapers.\n\nSo far the fund has raised 2.5 million dollars.",
            "picture": "finnish_relief_fund",
            "factSheet": "finnish_relief_fund",
            "anchors": [
                "Herbert Hoover",
                "1,400 American newspapers",
                "Madison Square Garden"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1943.12.31",
                "chance": 100,
                "trigger": "has_war_with = SOV has_country_flag = { flag = FIN_winter_war_ongoing_flag days > 90 } NOT = { has_government = fascism has_government = communism } USA = { has_government = democratic NOT = { has_war_with = FIN } }"
            },
            "options": [
                {
                    "name": "Thank Mr Hoover, and ask for nothing more.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Ask Washington for arms credits as well.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": -15
                        },
                        {
                            "war_support": 0.02
                        }
                    ]
                }
            ]
        }
    ]
}
```
