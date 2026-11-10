# France pack: tighter triggers, date-free war events

Status: DONE
Pack: france (FRA, namespace ep_fra)
Kind: audit fixes
Created: 2026-11-10

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block holds, with `"mergeById": true`, only the events this plan changes, each as its whole object. No fact-sheet section and no picture changes. Step 1 writes the block with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

The owner asked for a check of every released pack's triggers: does each event fire only in a game where its text is true, also off the historical path (a leader replaced, a regime changed, a war that starts on another date)? A `trigger-checker` agent on Opus checked all 20 France events against the game files (1.19.4.2) on 2026-11-09; the planner reviewed its report and reran the claims the fixes rest on. This plan holds the report, the owner's decisions and the approved fixes: fourteen events get a new trigger, and seven of them (the war events) also lose the dates in their text and get a wide window, as the mod's war rule asks. The pack predates that rule. Facts and pictures were not rechecked: no fact changes, the texts only lose dates.

## Audit report

How a gap was weighed: a human reads an event only while playing France. A gap counts when a plain historical game, a non-historical AI or the France player's own choice of another branch can open it; a gap that only a human-run other country or a conquest can open gets a pin only when the pin is one cheap leaf.

Facts the findings rest on:
- France can be at war with Germany from 1936: the Rhineland chain `germany.61` option b, `germany.64`, `germany.65` option a has France declare war (`events/Germany.txt:6493-6558`). So a war with Germany in late 1939 can be years old, and France can have capitulated; the FRA tag then stays at war as Free France.
- France starts democratic under Laval; the Popular Front focus makes Blum leader (`common/national_focus/france.txt:1641-1667`). A fascist France is possible from about 1937.1, a monarchist one from about 1938.2, by a player or a non-historical AI.
- Britain's king is the idea `ENG_george_vi` (`common/ideas/britain.txt:85`); Edward VIII can stay king with a non-historical AI (`events/MTG_Britain.txt:48-199`), and a fascist Britain also holds the idea.

### Critical

1. `alsace_evacuation_1939`, `saar_offensive_1939`, `polish_army_in_france_1939`, `pcf_dissolution_1939`, `george_vi_front_visit_dec_1939`, `louvre_evacuation_1939`, `heavy_water_1940` (war events): gated on `has_war_with = GER` (the Louvre also on `threat`) inside a narrow window of 1939 or 1940, with texts that date the war ("General mobilisation was ordered on 1 September", "began landing at Boulogne on 12 September") or its preparations ("On 25 August the museum was closed"). In a war that began in 1936 or in November 1939 the texts are false; in a war that begins after the window the events are lost. None checks that France has not capitulated, that Paris, Alsace or Boulogne are French-held, or (the Polish army) that Poland has fallen.

### Important

2. `salengro_affair`: Salengro is a hireable advisor once the Popular Front is done (`common/characters/FRA.txt:1687-1701`); the event reports the suicide of a man the player may have in the cabinet. The focus is permanent, Blum as leader is not.
3. `expo_1937`: "President Albert Lebrun" in a fascist France.
4. `royal_visit_1938`: Edward VIII still king; "the President of the Republic" and the Élysée in a fascist or monarchist France.
5. `bastille_day_1939`: a monarchist France celebrating the taking of the Bastille; British Guards from a Britain that is no friendly democracy; "Let Berlin take note" with France in Germany's faction (`FRA_join_germany`).
6. `cannes_festival_1939`: "after the invasion of Poland" when Poland attacked Germany (`NSB_poland_events.302`); Jean Zay's ministry in a non-democratic France. The ten-day window meets one or two weekly checks.
7. `pcf_dissolution_1939` (also in 1): the party "was banned" after the player banned it in 1936 with `FRA_ban_communism` (`france.txt:5238`, the only setter of `FRA_communism_banned`); "72 deputies" in a non-democratic France.

### Minor

8. `world_cup_1938`: "France beat Belgium" after a fascist France split Belgium. One leaf.
9. `phenix_submarine_loss`: Cam Ranh after Japan was given Indochina (`japan.6`). One leaf.

### Intentionally unchanged

`transindochinois_1936`, `mermoz_disappearance`, `marseille_nouvelles_galeries_fire`, `richelieu_launch_1939`, `family_code_1939`: nothing the trigger leaves open can change before the window closes, or the text names no office holder or regime. `syria_lebanon_treaties_1936`: the checker proposed a Blum gate (Viénot was his under-secretary); the planner leaves the event as it is, because the text names no government, a fascist France cannot exist before the window closes, and the gate would cost the event in every game where the player has not taken the Popular Front by September 1936.

## Decisions

Owner, 2026-11-10:
- War events lose their fixed dates: text without dates, wide window, gate on the state of the war.
- The cheap pins are added.

Owner, 2026-11-10, on the two open points of the trigger check:
- `polish_army_in_france_1939` needs a Poland that has capitulated and is still at war with Germany beside France (a government in exile). `germany.14` does not annex Poland, and the files show no more. The owner has seen it in play: a capitulated Poland stays in the war while France and Britain fight on. No probe.
- `cannes_festival_1939` rests on `has_defensive_war_with` as the Poland plan's `westerplatte` does. The owner accepts the trigger as it stands, on vanilla's own use of it for the country Germany attacks (`events/NewsEvents.txt:5201-5204`), with no probe.

Planner's choices inside those decisions:
- Seven events count as war events, `heavy_water_1940` among them ("At the end of March" made it fire only in a war that is on in April 1940). `cannes_festival_1939` keeps its dates: the festival was set for September 1939 whatever the war did, so its window stays on the calendar (now to 1939.9.21, the day after the festival's planned end) and its gate is the state of the war.
- "How long the war has lasted" is `war_length_with = { tag = GER months > N }`. Measured in the owner's game of 2026-11-05: `months > 0` turns true 30 days after the war began [SCR-107]; that `months > N` steps every 30 days after that is inferred. The brackets: the Alsace evacuation, the Saar offensive and the party ban from day 30 to about day 120; the King's visit from about day 90 to about day 240; the heavy water from about day 150 to about day 360; the Louvre before the war (Germany holds a wargoal on France or Poland, or `GER_danzig_or_war` is past 70 per cent) or in its first 30 days, and never later in a war with Germany.
- Windows open on 1939.1.1 (the men and posts the texts name are those of 1939) and close at the end of 1947, as the Poland pack's war events do.
- The Polish army event has no bracket of war length: its situation is Poland capitulated, still at war with Germany and fighting on France's side (`has_war_together_with = FRA`), with France not capitulated.
- `cannes_festival_1939`: the checker's `GER = { has_offensive_war_with = POL }` became `POL = { has_defensive_war_with = GER }`, the trigger the Poland pack's Westerplatte event gets in its plan of the same day, with the war at most 30 days old.

## Events

Only the events this plan changes. Pictures, options and effects stay as they are.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 3 | salengro_affair | Interior Minister Salengro Takes His Own Life | 1936.11.23 to 1937.1.15 | 50 | unchanged | unchanged |
| 5 | expo_1937 | President Lebrun Opens the Paris Exposition | 1937.5.31 to 1937.8.31 | 25 | unchanged | unchanged |
| 6 | world_cup_1938 | Italy Puts France Out of the World Cup | 1938.6.13 to 1938.7.15 | 50 | unchanged | unchanged |
| 7 | royal_visit_1938 | King George VI and Queen Elizabeth in Paris | 1938.7.22 to 1938.8.31 | 50 | unchanged | unchanged |
| 10 | phenix_submarine_loss | The Submarine Phénix Is Lost off Cam Ranh | 1939.6.16 to 1939.7.31 | 50 | unchanged | unchanged |
| 11 | bastille_day_1939 | British Guards March in the 14 July Parade | 1939.7.14 to 1939.8.15 | 100 | unchanged | unchanged |
| 13 | louvre_evacuation_1939 | 1,862 Cases Leave the Louvre for Chambord (was: The Louvre Sends Its Collections to Chambord) | 1939.1.1 to 1947.12.31 (was 1939.8.31 to 1939.9.30) | 100 | unchanged | unchanged |
| 14 | cannes_festival_1939 | The First Cannes Film Festival Is Called Off | 1939.9.1 to 1939.9.21 (was to 1939.9.10) | 100 | unchanged | unchanged |
| 15 | alsace_evacuation_1939 | Civilians Evacuated from Alsace and Moselle | 1939.1.1 to 1947.12.31 (was 1939.10.18 to 1939.12.31) | 50 | unchanged | unchanged |
| 16 | saar_offensive_1939 | The Army Is Ordered Back Behind the Maginot Line | 1939.1.1 to 1947.12.31 (was 1939.10.4 to 1939.11.30) | 50 | unchanged | unchanged |
| 17 | polish_army_in_france_1939 | The Polish Government Settles at Angers | 1939.1.1 to 1943.6.30 (was 1939.12.21 to 1940.2.28) | 50 | unchanged | unchanged |
| 18 | pcf_dissolution_1939 | The Communist Party Is Banned | 1939.1.1 to 1947.12.31 (was 1939.10.9 to 1939.12.31) | 50 | unchanged | unchanged |
| 19 | george_vi_front_visit_dec_1939 | King George VI Visits the Armies in France | 1939.1.1 to 1947.12.31 (was 1939.12.10 to 1940.2.15) | 50 | unchanged | unchanged |
| 20 | heavy_water_1940 | Norway's Heavy Water Reaches the Collège de France | 1939.1.1 to 1947.12.31 (was 1940.4.1 to 1940.5.9) | 100 | unchanged | unchanged |

New triggers:

| Key | `fire.trigger` |
|---|---|
| salengro_affair | `has_war = no has_completed_focus = FRA_form_the_popular_front has_country_leader = { ruling_only = yes character = FRA_leon_blum } NOT = { FRA_roger_salengro = { is_hired_as_advisor = yes } }` |
| expo_1937 | `has_war = no has_government = democratic` |
| world_cup_1938 | `has_war = no BEL = { exists = yes }` |
| royal_visit_1938 | `has_war = no has_government = democratic ENG = { has_war = no has_government = democratic has_idea = ENG_george_vi }` |
| phenix_submarine_loss | `has_war = no owns_state = 286` |
| bastille_day_1939 | `has_war = no has_government = democratic ENG = { has_government = democratic } NOT = { is_in_faction_with = GER }` |
| louvre_evacuation_1939 | `controls_state = 16 has_capitulated = no NOT = { is_in_faction_with = GER } NOT = { war_length_with = { tag = GER months > 0 } } OR = { GER = { has_wargoal_against = FRA } GER = { has_wargoal_against = POL } GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.7 } } has_war_with = GER }` |
| cannes_festival_1939 | `has_government = democratic POL = { has_defensive_war_with = GER NOT = { war_length_with = { tag = GER months > 0 } } }` |
| alsace_evacuation_1939 | `has_war_with = GER has_capitulated = no owns_state = 28 controls_state = 28 war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }` |
| saar_offensive_1939 | `has_war_with = GER has_capitulated = no controls_state = 28 GER = { controls_state = 42 } war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }` |
| polish_army_in_france_1939 | `has_war_with = GER has_capitulated = no controls_state = 14 controls_state = 23 controls_state = 30 POL = { has_capitulated = yes has_war_with = GER has_war_together_with = FRA NOT = { has_government = communism } NOT = { has_government = fascism } NOT = { has_completed_focus = POL_assemble_the_regency_council } }` |
| pcf_dissolution_1939 | `has_war_with = GER has_capitulated = no has_government = democratic NOT = { has_idea = FRA_communism_banned } GER = { has_non_aggression_pact_with = SOV } war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }` |
| george_vi_front_visit_dec_1939 | `has_war_with = GER has_capitulated = no controls_state = 28 controls_state = 29 GER = { controls_state = 42 } ENG = { has_war_with = GER has_government = democratic has_idea = ENG_george_vi is_in_faction_with = FRA } war_length_with = { tag = GER months > 2 } NOT = { war_length_with = { tag = GER months > 7 } }` |
| heavy_water_1940 | `has_war_with = GER has_capitulated = no controls_state = 16 is_in_faction_with = ENG NOR = { controls_state = 921 } war_length_with = { tag = GER months > 4 } NOT = { war_length_with = { tag = GER months > 11 } }` |

States: 14 Brittany (Coëtquidan), 16 Île de France (Paris), 23 Poitou (Parthenay), 28 Alsace-Lorraine, 29 Nord-Pas-de-Calais (Boulogne), 30 Loire (Angers), 42 Moselland (the Saar, German), 286 South Annam (Cam Ranh), 921 Telemark (Vemork, Norwegian). `NOR` is Norway's tag.

Text changes (dates out, nothing added):
- `louvre_evacuation_1939`: "On 25 August the museum was closed" becomes "The museum was closed"; "The Joconde left the Louvre on 28 August." becomes "The Joconde has left the Louvre."; anchor "25 August" dropped. The editor's rewrite on top of that: the new title; "director of the national museums" becomes "of the national museums"; the last sentence becomes "Much of the collection is trucked to the Château de Chambord: 203 vehicles carry 1,862 wooden cases."
- `alsace_evacuation_1939`: "was ordered on 1 September. On 2 and 3 September at least" becomes "was ordered. In the two days that followed, at least"; "On 18 October the Protestant youth movements founded" becomes "The Protestant youth movements have founded".
- `saar_offensive_1939`: the dates of 5 to 12 September, 30 September and 4 October removed ("Our units moved off by night.", "Within a week the army held", "General Gamelin then stopped", "General Georges has decided to pull ... back behind the Maginot Line."); anchor "12 September" dropped.
- `polish_army_in_france_1939`: "of 9 September", "on 12 September", "on 7 November" and "from 22 November" removed; anchors "9 September" and "22 November" dropped. The editor's rewrite on top of that: "President Raczkiewicz lives at" becomes "The Polish president lives at".
- `pcf_dissolution_1939`: "was banned on 26 September" becomes "has been banned"; "seized on 26 August, three days after" becomes "seized three days after"; the last paragraph becomes "The sapper Maurice Thorez has left his unit by night, without leave. Of the deputies of the Groupe ouvrier et paysan français, 34 have been arrested."; anchor "26 September" dropped.
- `george_vi_front_visit_dec_1939`: "began landing at Boulogne on 12 September. In December King George VI crossed" becomes "have landed at Boulogne. King George VI has crossed"; "On 9 December, with General Gamelin" becomes "With General Gamelin".
- `heavy_water_1940`: "At the end of March the stock was flown" becomes "The stock was flown".

## Pictures

No picture changes.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|

Thumbnail: unchanged

Pack intro: unchanged

Bundle intro: unchanged

## Fact verification

Not run: this audit checked triggers only. No fact is added or changed; the seven rewritten texts drop dates and keep every other claim, so `source/france/fact-sheets.md` stays as it is and no dossier gets a `Checked:` line.

## Trigger verification

Round 1, `trigger-checker` on Opus over `source/france/events.json`, 2026-11-09 (`Test-HoiConditions.ps1 -Events`: 20 open, 0 dead): 5 OK, 13 FIX, 2 OPEN.

| Event | Verdict |
|---|---|
| transindochinois_1936, mermoz_disappearance, marseille_nouvelles_galeries_fire, richelieu_launch_1939, family_code_1939 | OK |
| syria_lebanon_treaties_1936 | FIX proposed (Blum as ruling leader); not taken, see "Intentionally unchanged" |
| salengro_affair | FIX: Blum as ruling leader, Salengro not a hired advisor (the character-scope form of `common/characters/DEN.txt:1694`) |
| expo_1937 | FIX: France democratic |
| world_cup_1938 | OPEN (does `lar_split_belgium.1` erase Belgium?); closed by the free pin `BEL = { exists = yes }`; the checker's `ITA = { exists = yes }` left out (conquest only) |
| royal_visit_1938 | FIX: France democratic, `ENG_george_vi` |
| phenix_submarine_loss | OPEN (how early Japan's Indochina demand can come); closed by the free pin `owns_state = 286` |
| bastille_day_1939 | FIX: France and Britain democratic, France not in Germany's faction |
| cannes_festival_1939 | FIX: France democratic, Germany the attacker; the planner wrote the attacker leaf from Poland's side and widened the window (see "Decisions") |
| louvre_evacuation_1939, alsace_evacuation_1939, saar_offensive_1939, polish_army_in_france_1939, pcf_dissolution_1939, george_vi_front_visit_dec_1939 | FIX for the state pins (Paris, Alsace, Boulogne, the Saar, not capitulated, Poland capitulated, the ban idea, the King); the dated texts were left to the planner, who rewrote them on the owner's decision and added the brackets of war length |
| heavy_water_1940 | FIX: not capitulated, Paris French-held, Telemark Norwegian-held; the planner also took the date out of the text |

Planner's own lookups: `Find-HoiUsage.ps1` for `ENG_george_vi`, `FRA_communism_banned` and `FRA_roger_salengro`; `Get-HoiEvent.ps1 germany.65`; `Find-HoiDoc.ps1 -Name` for `war_length_with`, `is_hired_as_advisor`, `has_capitulated`, `is_in_faction_with`, `has_defensive_war_with`; the register for `war_length_with` [SCR-107].

Round 2, `trigger-checker` on Opus over this plan's block, 2026-11-10 (it reached its turn limit at fourteen events and reported from what it had; points it did not reach are named): 11 OK, 2 FIX, 1 OPEN. No bracket of war age blocks an event in the plain historical game; the upper brackets shut a war begun in 1936 out of Alsace, the Saar, the party ban, the King's visit and the heavy water. Timing below takes the war from 1 to 3 September 1939 and `months > N` as true from about day 30 times N+1.

| Event | Round 2 |
|---|---|
| salengro_affair | OK. The Popular Front is second in the historical plan (`common/ai_strategy_plans/FRA_historical_strategy_plan.txt:43-44`), done about May 1936, and makes Blum leader (`france.txt:1642-1652`). Salengro is recruited at the start (`history/countries/FRA - France.txt:502`), so the character scope exists in every game. About 7 checks at 50 per cent. Not checked: what an election does to Blum in 1936. The lookup lists the character-scope leaf as `UNCLASSIFIED` ("not documented"), a gap of the tool: vanilla writes the form from country scope (`common/national_focus/norway.txt:377`). |
| expo_1937, world_cup_1938, phenix_submarine_loss, bastille_day_1939 | OK. Every pin holds from the start data. |
| royal_visit_1938 | OK. `ENG_george_vi` is there by early 1937 without Man the Guns (`events/Britain.txt:600-665`) and by about July 1936 with it (`events/MTG_Britain.txt:8-199`, `995-1018`). |
| cannes_festival_1939 | OK. Vanilla uses `has_defensive_war_with` for the country Germany attacks (`events/NewsEvents.txt:5201-5204`). 2 to 3 checks at 100 per cent; a war that begins after about 18 September misses, which is right for a festival set for 1 to 20 September. |
| louvre_evacuation_1939 | FIX, applied: the first-30-days limit moved to the top level. Before, the wargoal and focus branches had no limit of war age, so a war the France player opened in 1936 and still fought in 1939 let the event fire in its third year. Fires at the first check: mid to late August 1939 from the 1936 start, 14 to 21 August from the 1939 start (Germany's 1939 history holds the wargoal on Poland, `history/countries/GER - Germany.txt:490-494`). |
| alsace_evacuation_1939, saar_offensive_1939, pcf_dissolution_1939 | OK. About 13 checks at 50 per cent from about 1 October 1939. The pact holds from Germany's 1939 history (`GER - Germany.txt:522`) or `germany.12` (`events/Germany.txt:484`). |
| polish_army_in_france_1939 | FIX, applied, and OPEN. `POL = { is_in_faction_with = FRA }` had one scripted setter, the focus `POL_join_allies` (`common/national_focus/poland.txt:4658-4725`), which cannot finish before the war in a 1939 start; now `has_war_together_with = FRA` (`documentation/triggers_documentation.md:5042`, "fighting on the same side of a war"). OPEN: whether a capitulated Poland stays at war with Germany while France and Britain fight on is engine behaviour. `germany.14` does not annex Poland (`events/Germany.txt:511-989`); the files show no more. Closed by the owner on 2026-11-10, who has seen it in play (see "Decisions"). |
| george_vi_front_visit_dec_1939 | OK. Britain and France share a faction from France's 1939 history (`FRA - France.txt:267`) or `FRA_go_with_britain` (`france.txt:4393-4442`, tenth in the historical plan). About 21 checks at 50 per cent from about 1 December 1939. A France that stays out of the Allies loses the event. |
| heavy_water_1940 | OK, with the planner's change of the lower bracket from `months > 5` to `months > 4` on the checker's note: `GER_operation_weserubung` has no date gate after 1939 (`germany.txt:12378-12426`), so Germany may hold Telemark before March 1940, and the event is then rightly lost. Fires at the first check from about 1 February 1940. |

Unverified and outside the historical game: that `war_length_with` counts only the current war after an earlier war with Germany has ended; that Germany keeps `has_wargoal_against` while already at war.

Round 3, `trigger-checker` on Opus over the two events whose text the editor changed (its questions 3 and 4, and the new leaves), 2026-11-10: 1 OK, 1 FIX, 0 OPEN.

| Event | Round 3 |
|---|---|
| louvre_evacuation_1939 | OK. With no post given to Jaujard no title can go stale; the two sentences hold before the war and in its first 30 days; the title no longer claims the whole collection. Fires at the first check, mid to late August 1939 from the 1936 start. |
| polish_army_in_france_1939 | FIX, applied: `controls_state = 23` added. The places of the text, by the map's geometry (`Get-HoiProvinceMap`; no file names them): Coëtquidan in state 14 Brittany, Angers in state 30 Loire, Parthenay in state 23 Poitou. All three are French-owned and French-controlled from the start with no later history block. The window's end on 1943.6.30 comes from the text's person, not from the war, and leaves more than three years. About 30 checks at 50 per cent from Poland's capitulation to France's. |

Added by the planner after round 3, on the checker's note that "the Polish president" is false for a Poland that took the Regency: `NOT = { has_completed_focus = POL_assemble_the_regency_council }` inside the `POL` block, the leaf the Poland plan of the same day uses and its checker confirmed (`common/national_focus/poland.txt:7592-7674`; the historical Polish AI never takes it). `Test-HoiConditions.ps1 -Events <this plan> -Key polish_army_in_france_1939` gives no dead leaf; it misreads this one focus leaf as `NEVER SET`, the lookup's known defect.

The point round 2 left OPEN (whether a capitulated Poland stays at war with Germany while France and Britain fight on) is closed by the owner's answer of 2026-11-10: it does. No event is OPEN.

## Editor record

`ep-editor`, round 1 over the seven rewritten texts (this plan's block as the draft, `source/france/fact-sheets.md` as the fact sheet), 2026-11-10: 5 KEEP (`alsace_evacuation_1939`, `saar_offensive_1939`, `pcf_dissolution_1939`, `george_vi_front_visit_dec_1939`, `heavy_water_1940`), 2 REWRITE, applied as given:
- `louvre_evacuation_1939`: the title claimed all the collections where the fact says "much of the collection", so "1,862 Cases Leave the Louvre for Chambord"; the last sentence had an abstract subject and blurred that the vehicles carried the cases; "director of the national museums" must hold on every day of a window of several years, so "of the national museums".
- `polish_army_in_france_1939`: "President Raczkiewicz" gives a man a title that does not hold on every day of the window, so "The Polish president". The editor's note on mechanics (Sikorski died in July 1943, so a late war could show him becoming commander-in-chief after his death) is taken as a window: the event's `fire.before` is 1943.6.30.

Round 2 over the two rewritten texts: `polish_army_in_france_1939` KEEP; `louvre_evacuation_1939` REWRITE, applied as given: "of the national museums" cut as well ("Jacques Jaujard has organised the evacuation of the Louvre."), 42 words. The editor's note on mechanics for the Polish event (Angers, Coëtquidan and Parthenay could be German-held while France still fights) is taken as two leaves: `controls_state = 14` (Brittany) and `controls_state = 30` (Loire); the trigger check's round 3 added `controls_state = 23` (Poitou, for Parthenay).

Round 3 over `louvre_evacuation_1939`: KEEP. Every one of the seven texts is KEEP in its latest round.

## Kept on judgment

Three warnings stay, all there before this plan and none about an event it changes; the owner decides on them before a release:
- `[WARN] picture mermoz_disappearance: public domain in the United States only (PD-US); the owner decides before a release`
- `[WARN] picture pcf_dissolution_1939: public domain in the United States only (PD-US-no notice); the owner decides before a release`
- `[WARN] picture richelieu_launch_1939: public domain in the United States only (PD-USGov-Military-Navy); the owner decides before a release`

`-ApplyPlan` (steps 1 and 2) and `-Check` (step 7) print them. The implementer stops on any other warning.

The gate rehearsal of 2026-11-10 (a copy under `scratch\rehearsal`) ran steps 1 to 9 as written: `-ApplyPlan` `Applied`, events 3, 5, 6, 7, 10, 11 and 13 to 20 changed (13: title, desc, anchors, fire; 15, 19, 20: desc, fire; 16, 17, 18: desc, anchors, fire; the others: fire), 6 unchanged; the dry run `0 file(s) would be written`; `-ConvertPictures` `failed=0`; `-Generate` 20 events, 13 files written (the on-actions, the events, the ten localisation files, the Workshop page and the wiki page, which carry the new Louvre title); `-Check` OK with the 3 warnings above, `Bundle 'all': 4 member(s), 0 error(s)`; `-RenderEvents` 20 events with no `[WARN]`; `-ValidateOnly` succeeded. The seven renders that differ from the repository's (13 and 15 to 20) were opened: every title fits its line, no option runs over, each text reads cleanly in the window with its picture. The render hashes are in `scratch\render-hashes-france.txt`.

## Implementation steps

- [x] 1. Write the source from the block below: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-france-trigger-audit.md`: expect `Applied 2026-11-10-france-trigger-audit.md`, with no `[WARN]` outside "Kept on judgment", and the events it lists as changed being ids 3, 5, 6, 7, 10, 11 and 13 to 20. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [x] 2. Check that the source holds the block: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-france-trigger-audit.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [x] 3. No pictures to fetch (the table is empty).
- [x] 4. Thumbnail unchanged: nothing to run.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack france`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack france`: expect `Generated pack 'france'`. The intro texts stay as they are.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack france`: expect `Check OK` and `Bundle 'all': 4 member(s), 0 error(s)`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack france`: expect `Rendered 20 events to ...artifacts\workshop-images\france`, with no `[WARN]` outside "Kept on judgment". The cards of ids 13 and 15 to 20 change; the owner uploads them where the Workshop page shows them.
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly`: expect `Validation succeeded.` (the full suite runs once, in `event-pack-implement` 3.2).
- [x] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `fix(france): tighter triggers, war events without fixed dates`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The Workshop upload is `event-pack-release`.
- [ ] 11. Owner, in game (not the implementer): in a game as France at war with Germany, check that the war events come in their order (the Louvre before or at the start; Alsace, the Saar and the party ban in the second to fourth month; the Polish government after Poland has fallen; the King's visit from the fourth month; the heavy water from the sixth), and in a game where Germany attacks Poland in September 1939, that `cannes_festival_1939` comes in the war's first three weeks (its gate is now `POL = { has_defensive_war_with = GER }`). `ep_fra_all` fires the events without their triggers, so it does not test this.

## Stop conditions

- `-ApplyPlan`, `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.
- `-ApplyPlan` lists an event other than ids 3, 5, 6, 7, 10, 11 and 13 to 20 as changed: stop.

## Outcome

2026-11-10. `-Check -Pack france`: `Check OK: 1 pack(s), 1 bundle(s), 3 warning(s).` (`Bundle 'all': 4 member(s), 0 error(s)`; `Pack 'france': 20 event(s), 18 picture(s), 0 error(s)`; the three warnings are those of "Kept on judgment"). `-ApplyPlan` changed events 3, 5, 6, 7, 10, 11 and 13 to 20, 6 unchanged; dry run `0 file(s) would be written`; `-ConvertPictures` `failed=0`; `-Generate` 20 events, 13 files written; `-RenderEvents` 20 events, no `[WARN]`; `-ValidateOnly` succeeded. No deviation. Steps 10 and 11 (ship, owner in game) stay unticked.

## Fact sheets

No section changes.

## Events source

The fourteen events this plan changes, each as its whole object with its id unchanged (`docs/source-format.md`, "Plans").

```json events
{
    "pack": "france",
    "tag": "FRA",
    "mergeById": true,
    "events": [
        {
            "id": 3,
            "key": "salengro_affair",
            "title": "Interior Minister Salengro Takes His Own Life",
            "desc": "Roger Salengro, Minister of the Interior in the Blum government, killed himself in Lille on 17 November. L'Action française and Gringoire, whose director is Henri Béraud, had accused him of deserting in the Great War, and Gringoire kept up the attacks.\n\nSalengro left a letter to Léon Blum and one to his brother. His funeral was held in Lille on 22 November.",
            "picture": "salengro_affair",
            "factSheet": "salengro_affair",
            "anchors": [
                "Roger Salengro",
                "Gringoire",
                "Henri Béraud",
                "22 November"
            ],
            "fire": {
                "after": "1936.11.23",
                "before": "1937.1.15",
                "chance": 50,
                "trigger": "has_war = no has_completed_focus = FRA_form_the_popular_front has_country_leader = { ruling_only = yes character = FRA_leon_blum } NOT = { FRA_roger_salengro = { is_hired_as_advisor = yes } }"
            },
            "options": [
                {
                    "name": "Make the law on press libel harder.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "The press stays free, even this press.",
                    "ai": 40,
                    "effects": [
                        {
                            "stability": 0.01
                        },
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 5,
            "key": "expo_1937",
            "title": "President Lebrun Opens the Paris Exposition",
            "desc": "President Albert Lebrun opened the Exposition internationale des Arts et Techniques on 24 May, later than the planned date of 1 May. The Palais de Chaillot, the Palais de Tokyo and the Palais de la Découverte were inaugurated right after.\n\nThe Palais de la Découverte is the project of the physicist Jean Perrin, Nobel laureate of 1926. It is installed in the west wing of the Grand Palais, the Palais d'Antin.",
            "picture": "expo_1937",
            "factSheet": "expo_1937",
            "anchors": [
                "Albert Lebrun",
                "24 May",
                "Palais de la Découverte",
                "Jean Perrin"
            ],
            "fire": {
                "after": "1937.5.31",
                "before": "1937.8.31",
                "chance": 25,
                "trigger": "has_war = no has_government = democratic"
            },
            "options": [
                {
                    "name": "Let all Paris come to the fair.",
                    "ai": 50,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Keep Perrin's halls open after the fair.",
                    "ai": 50,
                    "effects": [
                        {
                            "timed_idea": "palais_de_la_decouverte",
                            "days": 180
                        }
                    ]
                }
            ]
        },
        {
            "id": 6,
            "key": "world_cup_1938",
            "title": "Italy Puts France Out of the World Cup",
            "desc": "The World Cup in France began on 4 June. On 5 June France beat Belgium 3-1 at Colombes. On 12 June France met Italy in the quarter-final at Colombes, before more than 58,000 spectators.\n\nColaussi put Italy ahead in the 9th minute, and Heisserer equalised in the 10th. Piola scored in the 51st and the 72nd minutes. Italy won 3-1.",
            "picture": "world_cup_1938",
            "factSheet": "world_cup_1938",
            "anchors": [
                "Colombes",
                "58,000",
                "Heisserer",
                "Piola",
                "12 June"
            ],
            "fire": {
                "after": "1938.6.13",
                "before": "1938.7.15",
                "chance": 50,
                "trigger": "has_war = no BEL = { exists = yes }"
            },
            "options": [
                {
                    "name": "They did the country proud.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Next time we beat the Italians.",
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
            "id": 7,
            "key": "royal_visit_1938",
            "title": "King George VI and Queen Elizabeth in Paris",
            "desc": "King George VI and Queen Elizabeth arrived on 19 July for a state visit. They called on the President of the Republic, received the diplomatic corps, dined at the Élysée and saw Sacha Guitry and Ninon Vallin perform.\n\nOn 20 July they were received at the Hôtel de Ville, returned to the Quai d'Orsay by the Seine and attended a gala at the Opéra. On 21 July at Versailles, 50,000 men paraded before the King, with an air display. Lunch followed in the Hall of Mirrors. The King and Queen left from the Gare des Invalides on 22 July.",
            "picture": "royal_visit_1938",
            "factSheet": "royal_visit_1938",
            "anchors": [
                "George VI",
                "Queen Elizabeth",
                "19 July",
                "Gare des Invalides",
                "Sacha Guitry"
            ],
            "fire": {
                "after": "1938.7.22",
                "before": "1938.8.31",
                "chance": 50,
                "trigger": "has_war = no has_government = democratic ENG = { has_war = no has_government = democratic has_idea = ENG_george_vi }"
            },
            "options": [
                {
                    "name": "London has never been a closer friend.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "A fine visit. Now back to the budget.",
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
            "id": 10,
            "key": "phenix_submarine_loss",
            "title": "The Submarine Phénix Is Lost off Cam Ranh",
            "desc": "The submarine Phénix went down on 15 June in the South China Sea off Cam Ranh. She was on training manoeuvres with the light cruiser Lamotte-Picquet and aircraft. The exercise included a mock attack on the cruiser. The toll is 71 dead: 5 officers and 66 enlisted men.\n\nThe Phénix had been commissioned on 21 October 1932.",
            "picture": "phenix_submarine_loss",
            "factSheet": "phenix_submarine_loss",
            "anchors": [
                "Phénix",
                "Cam Ranh",
                "15 June",
                "Lamotte-Picquet"
            ],
            "fire": {
                "after": "1939.6.16",
                "before": "1939.7.31",
                "chance": 50,
                "trigger": "has_war = no owns_state = 286"
            },
            "options": [
                {
                    "name": "Open an inquiry into the exercise.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "The manoeuvres go on.",
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
            "id": 11,
            "key": "bastille_day_1939",
            "title": "British Guards March in the 14 July Parade",
            "desc": "This 14 July marked the 150th anniversary of the taking of the Bastille. More than 30,000 soldiers took part in the parade, and detachments of the British Brigade of Guards and of the Royal Marines marched in it. Senegalese tirailleurs of the 24th regiment marched on the Champs-Élysées.\n\nGamelin went to London to settle military cooperation between the two countries. He met his counterpart, Gort, on 9 June.",
            "picture": "bastille_day_1939",
            "factSheet": "bastille_day_1939",
            "anchors": [
                "150th anniversary",
                "30,000",
                "Brigade of Guards",
                "Royal Marines"
            ],
            "fire": {
                "after": "1939.7.14",
                "before": "1939.8.15",
                "chance": 100,
                "trigger": "has_war = no has_government = democratic ENG = { has_government = democratic } NOT = { is_in_faction_with = GER }"
            },
            "options": [
                {
                    "name": "Let Berlin take note.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Let Paris enjoy its holiday.",
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
            "id": 13,
            "key": "louvre_evacuation_1939",
            "title": "1,862 Cases Leave the Louvre for Chambord",
            "desc": "Jacques Jaujard has organised the evacuation of the Louvre. The museum was closed for three days, officially for repairs. The Joconde has left the Louvre.\n\nMuch of the collection is trucked to the Château de Chambord: 203 vehicles carry 1,862 wooden cases.",
            "picture": "louvre_evacuation_1939",
            "factSheet": "louvre_evacuation_1939",
            "anchors": [
                "Jacques Jaujard",
                "Joconde",
                "Chambord",
                "1,862"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 100,
                "trigger": "controls_state = 16 has_capitulated = no NOT = { is_in_faction_with = GER } NOT = { war_length_with = { tag = GER months > 0 } } OR = { GER = { has_wargoal_against = FRA } GER = { has_wargoal_against = POL } GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.7 } } has_war_with = GER }"
            },
            "options": [
                {
                    "name": "Empty the galleries. The paintings can wait for peace.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Leave a few masterpieces on show for Parisians.",
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
            "id": 14,
            "key": "cannes_festival_1939",
            "title": "The First Cannes Film Festival Is Called Off",
            "desc": "The festival at Cannes was to run from 1 to 20 September, with Louis Lumière as president and the Coupe Lumière as its prize. Jean Zay approved it last December as an answer to the Venice Mostra. MGM chartered a liner to bring Hollywood stars, and The Wizard of Oz and Goodbye Mr. Chips were in the selection.\n\nThe festival has been cancelled after the invasion of Poland.",
            "picture": "cannes_festival_1939",
            "factSheet": "cannes_festival_1939",
            "anchors": [
                "Louis Lumière",
                "Coupe Lumière",
                "Jean Zay"
            ],
            "fire": {
                "after": "1939.9.1",
                "before": "1939.9.21",
                "chance": 100,
                "trigger": "has_government = democratic POL = { has_defensive_war_with = GER NOT = { war_length_with = { tag = GER months > 0 } } }"
            },
            "options": [
                {
                    "name": "Postpone it to a quieter year.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.01
                        }
                    ]
                },
                {
                    "name": "Hold a few screenings for the town anyway.",
                    "ai": 40,
                    "effects": [
                        {
                            "stability": 0.02
                        },
                        {
                            "war_support": -0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 15,
            "key": "alsace_evacuation_1939",
            "title": "Civilians Evacuated from Alsace and Moselle",
            "desc": "General mobilisation was ordered. In the two days that followed, at least 530,000 Alsatians and Lorrainers, civilians of the Bas-Rhin, the Haut-Rhin and the Moselle, were evacuated to the departments of the south-west.\n\nThe Protestant youth movements have founded the Cimade, the Comité inter-mouvements auprès des évacués. It sends teams to the south-west.",
            "picture": "alsace_evacuation_1939",
            "factSheet": "alsace_evacuation_1939",
            "anchors": [
                "Bas-Rhin",
                "Haut-Rhin",
                "Moselle",
                "530,000",
                "Cimade"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER has_capitulated = no owns_state = 28 controls_state = 28 war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }"
            },
            "options": [
                {
                    "name": "Lodge them at the state's expense.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "evacuee_relief",
                            "days": 120
                        }
                    ]
                },
                {
                    "name": "Every village in the south-west will do its share.",
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
            "id": 16,
            "key": "saar_offensive_1939",
            "title": "The Army Is Ordered Back Behind the Maginot Line",
            "desc": "Our units moved off by night. The 42nd Infantry Division took the Warndt forest, and four R35 tanks of the 20th BCC hit mines north of Bliesbrück. Within a week the army held a strip of ground 25 km long and 5 to 8 km deep.\n\nGeneral Gamelin then stopped the offensive so as not to cut the army off from its rear bases. The Siegfried Line was not attacked. General Georges has decided to pull the units of the 3rd, 4th and 5th Armies back behind the Maginot Line.",
            "picture": "saar_offensive_1939",
            "factSheet": "saar_offensive_1939",
            "anchors": [
                "Warndt",
                "Bliesbrück",
                "General Georges"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER has_capitulated = no controls_state = 28 GER = { controls_state = 42 } war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }"
            },
            "options": [
                {
                    "name": "Behind the Maginot Line we can wait.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "We took the Warndt once. We will again.",
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
            "id": 17,
            "key": "polish_army_in_france_1939",
            "title": "The Polish Government Settles at Angers",
            "desc": "A Franco-Polish military agreement has created the Polish Army in France. The camp at Coëtquidan was placed at its disposal, and Parthenay is its other main centre.\n\nWładysław Sikorski, also minister of military affairs, has become commander-in-chief. The Polish prime minister and his government have settled at Angers. The Polish president lives at the Château de Pignerolle, near Angers.",
            "picture": "polish_army_in_france_1939",
            "factSheet": "polish_army_in_france_1939",
            "anchors": [
                "Coëtquidan",
                "Władysław Sikorski",
                "Angers"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1943.6.30",
                "chance": 50,
                "trigger": "has_war_with = GER has_capitulated = no controls_state = 14 controls_state = 23 controls_state = 30 POL = { has_capitulated = yes has_war_with = GER has_war_together_with = FRA NOT = { has_government = communism } NOT = { has_government = fascism } NOT = { has_completed_focus = POL_assemble_the_regency_council } }"
            },
            "options": [
                {
                    "name": "Arm them from our own stocks.",
                    "ai": 50,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Train them first. Arms come later.",
                    "ai": 50,
                    "effects": [
                        {
                            "stability": 0.01
                        }
                    ]
                }
            ]
        },
        {
            "id": 18,
            "key": "pcf_dissolution_1939",
            "title": "The Communist Party Is Banned",
            "desc": "The French Communist Party has been banned. L'Humanité had been seized three days after the German-Soviet pact, and censorship followed the next day. Of the party's 72 deputies, 21 resigned from it after the pact.\n\nThe sapper Maurice Thorez has left his unit by night, without leave. Of the deputies of the Groupe ouvrier et paysan français, 34 have been arrested.",
            "picture": "pcf_dissolution_1939",
            "factSheet": "pcf_dissolution_1939",
            "anchors": [
                "L'Humanité",
                "Maurice Thorez",
                "Groupe ouvrier et paysan français"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER has_capitulated = no has_government = democratic NOT = { has_idea = FRA_communism_banned } GER = { has_non_aggression_pact_with = SOV } war_length_with = { tag = GER months > 0 } NOT = { war_length_with = { tag = GER months > 3 } }"
            },
            "options": [
                {
                    "name": "Let the courts deal with the deputies.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Welcome back those who broke with Moscow.",
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
            "id": 19,
            "key": "george_vi_front_visit_dec_1939",
            "title": "King George VI Visits the Armies in France",
            "desc": "British troops have landed at Boulogne. King George VI has crossed to Boulogne himself aboard the destroyer HMS Codrington, and Lord Gort met him.\n\nWith General Gamelin and Lord Gort, the King inspected French and British troops in the Saar sector of the front.",
            "picture": "george_vi_front_visit_dec_1939",
            "factSheet": "george_vi_front_visit_dec_1939",
            "anchors": [
                "Boulogne",
                "George VI",
                "Lord Gort",
                "HMS Codrington"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER has_capitulated = no controls_state = 28 controls_state = 29 GER = { controls_state = 42 } ENG = { has_war_with = GER has_government = democratic has_idea = ENG_george_vi is_in_faction_with = FRA } war_length_with = { tag = GER months > 2 } NOT = { war_length_with = { tag = GER months > 7 } }"
            },
            "options": [
                {
                    "name": "Our two armies stand together.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Good. Now send the men home on leave.",
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
            "id": 20,
            "key": "heavy_water_1940",
            "title": "Norway's Heavy Water Reaches the Collège de France",
            "desc": "Raoul Dautry entrusted Jacques Allier with secretly buying the available stock of Norsk Hydro's heavy water: 185 kg, from the Vemork plant. The stock was flown to France by way of Scotland. Allier came back with 26 canisters of seven litres.\n\nThe heavy water went into the cellars of the Collège de France. Joliot-Curie and Kowarski need it in large quantity as a moderator, to slow the neutrons in their experiment.",
            "picture": "heavy_water_1940",
            "factSheet": "heavy_water_1940",
            "anchors": [
                "Jacques Allier",
                "Norsk Hydro",
                "185 kg",
                "Collège de France",
                "Kowarski"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1947.12.31",
                "chance": 100,
                "trigger": "has_war_with = GER has_capitulated = no controls_state = 16 is_in_faction_with = ENG NOR = { controls_state = 921 } war_length_with = { tag = GER months > 4 } NOT = { war_length_with = { tag = GER months > 11 } }"
            },
            "options": [
                {
                    "name": "Give Joliot-Curie's laboratory what it asks for.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "joliot_curie_laboratory",
                            "days": 180
                        }
                    ]
                },
                {
                    "name": "Keep the canisters under guard and say nothing.",
                    "ai": 40,
                    "effects": [
                        {
                            "war_support": 0.01
                        }
                    ]
                }
            ]
        }
    ]
}
```
