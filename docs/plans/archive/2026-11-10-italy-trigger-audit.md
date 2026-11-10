# Italy pack: tighter triggers

Status: DONE
Pack: italy (ITA, namespace ep_ita)
Kind: audit fixes
Created: 2026-11-10

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block holds, with `"mergeById": true`, only the events this plan changes, each as its whole object. No text, fact-sheet section or picture changes. Step 1 writes the block with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

The owner asked for a check of every released pack's triggers: does each event fire only in a game where its text is true, also off the historical path? His examples were all Italian: an event that names Mussolini while Italy is democratic, "Italy and Germany Conclude a Protocol" when the two no longer share an ideology, and "British Aircraft Strike the Fleet at Taranto" in a war that does not fit it. A `trigger-checker` agent on Opus checked all 20 Italy events against the game files (1.19.4.2) on 2026-11-09; the planner reviewed its report and reran the claims the fixes rest on. This plan holds the report, the owner's decisions and the approved fixes: eight events get a new trigger, no text changes.

## Audit report

How a gap was weighed: a human reads an event only while playing Italy. A gap counts when a plain historical game, a non-historical AI or the Italy player's own choice of another branch can open it; a gap that only a human-run other country or a conquest can open gets a pin only when the pin is one cheap leaf.

The owner's examples:
- Mussolini named while Italy is democratic: cannot happen. Every event that names him (`aoi_empire_proclaimed`, `ciano_foreign_minister`, `axis_protocol_october`, `cinecitta_opens`, `hitler_visit_italy`, `mirafiori_opening`) carries `has_country_leader = { character = ITA_benito_mussolini }`. The trigger means the ruling leader (`ruling_only = yes/no (default = yes)`, `documentation/triggers_documentation.md:3640`), and his only leader role is fascist (`common/characters/ITA.txt:20`). `ITA_depose_mussolini` and the civil war of `ITA_defy_the_duce` both turn the leaf false.
- `axis_protocol_october`: tight as it is. Mussolini ruling, Germany fascist, Italy at peace with everyone but Ethiopia.
- `taranto_night`: see Critical.

### Critical

1. `taranto_night` (war event): it fires with the battleships anywhere and the British carrier anywhere, and after Britain has capitulated (`has_war_with = ENG` and the carriers can both outlast a capitulation). This plan closes the last of the three. The first two need a gate on ships in Puglia's ports and on a carrier in the Mediterranean, and the event then deserves a real effect on the ships; both go to the Modding Manager's plan for stronger effects, with an in-game probe of how often an AI Italy keeps capital ships in those ports.

### Important

2. `aoi_empire_proclaimed`: the opposite fault, in a plain historical game. The trigger asks for the idea `vittorio_emanuele`, which the focus `ITA_the_new_emperor_of_ethiopia` replaces with `vittorio_emanuele_emperor_of_ethiopia` (`common/national_focus/italy.txt:8934-8949`) and every annexation of Albania with another variant (`events/Italy.txt:26-38`). An Italy that takes the focus before the weekly roll succeeds never gets the event.
3. `hitler_visit_italy`: "watched Aida ... with the King" after `ITA_capo_supremo` removed the King while Mussolini rules (`italy.txt:10109-10171`).
4. `albania_landing`: the crown offered to "Italy's King Victor Emmanuel III" after the republic or `ITA_capo_supremo`. `has_character = ITA_vittorio_emanuele_iii` probably stays true in a republic: `ITA_the_italian_republic` removes his role only in a hidden effect (`italy.txt:19018-19045`). And "Zog took refuge in exile in neighbouring Greece" with Greece gone (`ITA_war_with_greece` and others).
5. `guadalajara_ctv`: "Italian anti-fascist volunteers had formed the Garibaldi Battalion" after Italy left fascism; the sister event `spain_sm81_airlift` has the leaf, this one does not.

### Minor

6. `olympic_football_gold`: the final against an Austria already annexed (a non-historical Germany can finish `GER_anschluss` in about 140 days). One leaf.
7. `world_cup_1938`, `bartali_tour_1938`: a World Cup final at Colombes and a Tour de France in a France at war; the peace gate sees only Italy's own wars. One leaf each.

### Intentionally unchanged

`topolino_fiat_500`, `ciano_foreign_minister`, `lira_devaluation_1936`, `axis_protocol_october`, `pirandello_death`, `cinecitta_opens`, `easter_accords`, `mirafiori_opening`, `coffee_sugar_rationing`, `giro_1940_coppi`: the checker found them tight.

`spain_sm81_airlift`: the checker proposed to pin the Nationalists to the tag SPA, because the text calls them "the rebel faction" and a Spanish player who sides with the plot keeps the government's tag. Not taken: the Nationalists are the military rising whichever tag the script gives them, and the checker could not tell from the files which option the historical Spanish AI takes, so the pin might block the event in normal games.

`british_somaliland_1940`: the gates already describe the situation (war with Britain, Italy holding Addis Ababa, Britain holding British Somaliland). The checker's two leaves on troops in the states are unverified (does `num_divisions_in_states` count only the scope country's divisions; does an AI Britain garrison the state) and could stop the event firing.

Known and unchanged: `ITA_victory_in_ethiopia_flag` is set only by By Blood Alone scripts, so `aoi_empire_proclaimed`, `easter_accords` and `british_somaliland_1940` need that DLC; the peace gate `NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }` is the owner's decision of 2026-11-08 and reads as it should from the documentation.

## Decisions

Owner, 2026-11-10:
- The cheap pins are added.
- `taranto_night` gets only "Britain has not capitulated" now; its port and carrier gates and its effect are planned in the Modding Manager.

Planner's choices:
- "Victor Emmanuel III is king" is the `OR` of the four idea variants (`vittorio_emanuele`, `vittorio_emanuele_emperor_of_ethiopia`, `vittorio_emanuele_king_of_albania`, `vittorio_emanuele_albania_ethiopia`, `common/ideas/italy.txt:676`, `704`, `732`); `ITA_remove_king_vittorio_emanuele_as_idea` removes whichever is there (`common/scripted_effects/ITA_scripted_effects.txt:3628-3645`).
- `world_cup_1938` gets `FRA = { has_war = no }` only; the checker's `HUN = { exists = yes }` is left out (only a conquest removes Hungary).

## Events

Only the events this plan changes. Windows, chances, texts, pictures, options and effects stay as they are.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 1 | aoi_empire_proclaimed | Empire Proclaimed from Palazzo Venezia | 1936.6.1 to 1939.1.1 | 15 | unchanged | unchanged |
| 5 | olympic_football_gold | Italy Wins Olympic Football Gold | 1936.8.15 to 1936.10.1 | 25 | unchanged | unchanged |
| 8 | guadalajara_ctv | Fog and Sleet Slow the Advance at Guadalajara | 1937.1.1 to 1939.4.1 | 12 | unchanged | unchanged |
| 12 | hitler_visit_italy | Hitler Leaves Italy at the Brenner | 1938.5.9 to 1938.6.15 | 40 | unchanged | unchanged |
| 13 | world_cup_1938 | Italy Keeps the World Cup | 1938.6.19 to 1938.7.31 | 40 | unchanged | unchanged |
| 14 | bartali_tour_1938 | Bartali Wins the Tour de France | 1938.7.31 to 1938.9.15 | 40 | unchanged | unchanged |
| 15 | albania_landing | Albania Offers Its Crown to the King | 1939.1.1 to 1941.1.1 | 50 | unchanged | unchanged |
| 20 | taranto_night | British Aircraft Strike the Fleet at Taranto | 1940.1.1 to 1945.1.1 | 8 | unchanged | unchanged |

New triggers (KING stands for `OR = { has_idea = vittorio_emanuele has_idea = vittorio_emanuele_emperor_of_ethiopia has_idea = vittorio_emanuele_king_of_albania has_idea = vittorio_emanuele_albania_ethiopia }`, PEACE for `NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }`; the block below holds them written out):

| Key | `fire.trigger` |
|---|---|
| aoi_empire_proclaimed | `has_country_flag = ITA_victory_in_ethiopia_flag` KING `has_country_leader = { character = ITA_benito_mussolini }` |
| olympic_football_gold | PEACE `AUS = { exists = yes }` |
| guadalajara_ctv | `has_global_flag = spanish_civil_war NOT = { has_global_flag = scw_over } has_government = fascism any_country = { has_idea = SPA_death_before_surrender has_volunteers_amount_from = { tag = ROOT count > 0 } }` |
| hitler_visit_italy | PEACE `has_country_leader = { character = ITA_benito_mussolini }` KING `GER = { has_government = fascism has_country_leader = { character = GER_adolf_hitler } }` |
| world_cup_1938 | PEACE `FRA = { has_war = no }` |
| bartali_tour_1938 | PEACE `FRA = { has_war = no }` |
| albania_landing | `NOT = { country_exists = ALB } 44 = { is_owned_by = ROOT } has_character = ITA_vittorio_emanuele_iii NOT = { has_country_flag = ITA_deposed_the_king }` KING `GRE = { exists = yes }` |
| taranto_night | `has_war_with = ENG 849 = { is_controlled_by = ROOT } has_navy_size = { size > 1 unit = battleship } ENG = { has_capitulated = no has_navy_size = { size > 0 unit = carrier } }` |

## Pictures

No picture changes.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|

Thumbnail: unchanged

Pack intro: unchanged

Bundle intro: unchanged

## Fact verification

Not run: this audit checked triggers only, and no text changes.

## Trigger verification

Round 1, `trigger-checker` on Opus over `source/italy/events.json`, 2026-11-09 (`Test-HoiConditions.ps1 -Events`: 20 open, 0 dead): 10 OK, 10 FIX, 0 OPEN. Every replacement it proposed ran through `-Trigger ... -Root ITA -Date <fire.after>` with no dead leaf.

| Event | Verdict |
|---|---|
| topolino_fiat_500, ciano_foreign_minister, lira_devaluation_1936, axis_protocol_october, pirandello_death, cinecitta_opens, easter_accords, mirafiori_opening, coffee_sugar_rationing, giro_1940_coppi | OK |
| aoi_empire_proclaimed | FIX (too tight): the King as any of the four idea variants |
| olympic_football_gold | FIX: Austria exists |
| guadalajara_ctv | FIX: Italy fascist |
| hitler_visit_italy | FIX: the King |
| world_cup_1938 | FIX: France at peace; the checker's `HUN = { exists = yes }` left out |
| bartali_tour_1938 | FIX: France at peace |
| albania_landing | FIX: the King, Greece exists |
| taranto_night | FIX: Britain not capitulated taken; the port gate `ships_in_state_ports = { type = capital_ship state = 849 size > 1 }` not taken here (see Critical) |
| spain_sm81_airlift | FIX proposed (the tag SPA); not taken, see "Intentionally unchanged" |
| british_somaliland_1940 | FIX proposed (troops in the states); not taken, see "Intentionally unchanged" |

Planner's own lookups: `Find-HoiDoc.ps1 -Name has_country_leader`; `Find-HoiUsage.ps1` for the three other idea variants; `Find-HoiDoc.ps1 -Name` for `ships_in_state_ports`, `ships_in_area`, `damage_units`, `destroy_ships`; `Get-HoiDecision.ps1 ITA_human_torpedo_raid`.

Round 2, `trigger-checker` on Opus over this plan's block, 2026-11-10 (`Test-HoiConditions.ps1 -Events`: 8 open, 0 dead): 7 OK, 1 FIX, 0 OPEN. No leaf blocks the plain historical game.

| Event | Round 2 |
|---|---|
| aoi_empire_proclaimed | OK. The flag's only setter is `ITA_end_the_italo_ethiopian_war` (`common/scripted_effects/ITA_scripted_effects.txt:35`), never cleared; the trigger holds whether or not the focus is done. Up to about 134 weekly checks at 15 per cent. |
| olympic_football_gold | OK. Austria owns 6 states at 1936.8.15. About 6 checks at 25 per cent. |
| guadalajara_ctv | OK. Italy is fascist at 1937.1.1 (`history/countries/ITA - Italy.txt:750`). |
| hitler_visit_italy | OK. Only `ITA_capo_supremo` or the German coup (`wtt_germany.11`) removes the King before mid 1938, neither in a historical game. About 5 checks at 40 per cent. |
| world_cup_1938, bartali_tour_1938 | OK. No historical script puts France at war in 1938; a French civil war also counts as `has_war`. |
| albania_landing | FIX, applied: `NOT = { has_country_flag = ITA_deposed_the_king }` added. On the papal path (`ITA_seek_papal_support`, then `BBA_italy_interaction_events.38`, `events/BBA_Italy.txt:12638`) the King is deposed by flag only: no idea is removed and the character is not retired, so the idea gate alone would let the event through. The flag is the game's own mark of a deposed King (`events/BBA_NewsEvents.txt:355-357`); its setters are that event and `ITA_remove_king_vittorio_emanuele_as_idea` (`ITA_scripted_effects.txt:3653`), and `ITA_add_king_vittorio_emanuele_back_as_idea` clears it (`:3682-3684`). It is never set in a historical game. The event still fires after every way Italy takes Albania (`italy.1`, `ITA_albanian_occupation` through `italy.3`, a war), and from 1939.8.14 in the 1939 start. The checker's optional widening (the King as country leader inside the `OR`) is not taken. |
| taranto_night | OK. Britain starts with carriers in every naval history file; the capitulation gap is closed. Up to about 235 checks at 8 per cent. |

The King gate, checked once: the four ideas are every form the King takes (`common/ideas/italy.txt:654`, `676`, `704`, `732`); every swap between them is one `swap_ideas` in one effect, so no day is without one. Unverified, and outside the historical game: whether the 1939 start really holds two of the ideas at once, and whether `has_idea` stays true while the government is non-aligned (each idea has `available = { NOT = { has_government = neutrality } }`).

## Editor record

No text changes: the editor has nothing to judge.

## Kept on judgment

None. The gate rehearsal of 2026-11-10 (a copy under `scratch\rehearsal`) ran steps 1 to 9 as written: `-ApplyPlan` `Applied`, events 1, 5, 8, 12, 13, 14, 15 and 20 changed (fire), 12 unchanged; the dry run `0 file(s) would be written`; `-ConvertPictures` `failed=0`; `-Generate` 20 events, 1 file written (`common/on_actions/ep_ita_on_actions.txt`); `-Check` OK with 0 warnings, `Bundle 'all': 4 member(s), 0 error(s)`; `-RenderEvents` 20 events with no `[WARN]`, every render byte for byte the one the repository has now; `-ValidateOnly` succeeded. The render hashes are in `scratch\render-hashes-italy.txt`.

## Implementation steps

- [x] 1. Write the source from the block below: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-italy-trigger-audit.md`: expect `Applied 2026-11-10-italy-trigger-audit.md`, with no `[WARN]` outside "Kept on judgment", and the events it lists as changed being ids 1, 5, 8, 12, 13, 14, 15 and 20. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [x] 2. Check that the source holds the block: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-italy-trigger-audit.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [x] 3. No pictures to fetch (the table is empty).
- [x] 4. Thumbnail unchanged: nothing to run.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack italy`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack italy`: expect `Generated pack 'italy'`. The intro texts stay as they are.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack italy`: expect `Check OK` and `Bundle 'all': 4 member(s), 0 error(s)`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack italy`: expect `Rendered 20 events to ...artifacts\workshop-images\italy`, with no `[WARN]` outside "Kept on judgment". No text changes, so no card changes.
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly`: expect `Validation succeeded.` (the full suite runs once, in `event-pack-implement` 3.2).
- [x] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `fix(italy): tighter triggers`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The Workshop upload is `event-pack-release`.
- [ ] 11. Owner, in game (not the implementer): in a game as Italy with By Blood Alone, complete "The New Emperor of Ethiopia" before `aoi_empire_proclaimed` has fired and check that the event still comes. `ep_ita_all` fires the events without their triggers, so it does not test this.

## Stop conditions

- `-ApplyPlan`, `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.
- `-ApplyPlan` lists an event other than ids 1, 5, 8, 12, 13, 14, 15 and 20 as changed: stop.

## Outcome

2026-11-10. `-Check -Pack italy`: `Check OK: 1 pack(s), 1 bundle(s), 0 warning(s).` (`Bundle 'all': 4 member(s), 0 error(s)`). `-ApplyPlan` changed events 1, 5, 8, 12, 13, 14, 15 and 20; the dry run wrote 0 files; `-ConvertPictures` `failed=0`; `-Generate` wrote 1 file (`ep_ita_on_actions.txt`); `-RenderEvents` rendered 20 events with no `[WARN]`; `-ValidateOnly` succeeded (its all-pack check printed three PD-US picture warnings for the France pack, none for Italy). No deviations. Steps 10 (ship) and 11 (owner, in game) stay unticked.

## Fact sheets

No section changes.

## Events source

The eight events this plan changes, each as its whole object with its id unchanged (`docs/source-format.md`, "Plans").

```json events
{
    "pack": "italy",
    "tag": "ITA",
    "mergeById": true,
    "events": [
        {
            "id": 1,
            "key": "aoi_empire_proclaimed",
            "title": "Empire Proclaimed from Palazzo Venezia",
            "desc": "'Ethiopia is Italian! Italian in fact, because it is occupied by our victorious armies,' Mussolini said. From the balcony of Palazzo Venezia he proclaimed the formation of the Italian Empire, and King Victor Emmanuel III assumed the additional title of Emperor of Ethiopia.\n\nA decree unified the three territories of Ethiopia, Eritrea and Somalia into a single legal and political entity, Italian East Africa. The colony was divided into six governorates.",
            "picture": "vanilla:GFX_report_event_generic_italian_celebration",
            "factSheet": "aoi_empire_proclaimed",
            "anchors": [
                "Palazzo Venezia",
                "Emperor of Ethiopia",
                "six governorates"
            ],
            "fire": {
                "after": "1936.6.1",
                "before": "1939.1.1",
                "chance": 15,
                "trigger": "has_country_flag = ITA_victory_in_ethiopia_flag OR = { has_idea = vittorio_emanuele has_idea = vittorio_emanuele_emperor_of_ethiopia has_idea = vittorio_emanuele_king_of_albania has_idea = vittorio_emanuele_albania_ethiopia } has_country_leader = { character = ITA_benito_mussolini }"
            },
            "options": [
                {
                    "name": "Celebrate it in every town.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.03
                        }
                    ]
                },
                {
                    "name": "Name the governors without delay.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 20
                        }
                    ]
                }
            ]
        },
        {
            "id": 5,
            "key": "olympic_football_gold",
            "title": "Italy Wins Olympic Football Gold",
            "desc": "In the Olympiastadion in Berlin, Italy overcomes Austria in the final of the Olympic football tournament. Midway through the second half Frossi scores first for the Azzurri, and he gets the winning goal just as extra time begins. Vittorio Pozzo is the coach.\n\nEarlier in the tournament Italy defeated Japan after Pozzo decided to include Biagi. How does Rome greet the team?",
            "picture": "olympic_team_1936",
            "factSheet": "olympic_football_gold",
            "anchors": [
                "Frossi",
                "Pozzo",
                "Olympiastadion"
            ],
            "fire": {
                "after": "1936.8.15",
                "before": "1936.10.1",
                "chance": 25,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } AUS = { exists = yes }"
            },
            "options": [
                {
                    "name": "Receive the team at Palazzo Venezia.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Let the football federation thank them.",
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
            "id": 8,
            "key": "guadalajara_ctv",
            "title": "Fog and Sleet Slow the Advance at Guadalajara",
            "desc": "At Guadalajara the advance of the Italian forces, 26,000 soldiers under General Roatta, was slowed by fog and sleet. The dirt airfields were flooded with mud.\n\nItalian anti-fascist volunteers had formed the Garibaldi Battalion. How do we answer the delay?",
            "picture": "vanilla:GFX_report_event_spr_italian_volunteers",
            "factSheet": "guadalajara_ctv",
            "anchors": [
                "Roatta",
                "Garibaldi Battalion",
                "26,000"
            ],
            "fire": {
                "after": "1937.1.1",
                "before": "1939.4.1",
                "chance": 12,
                "trigger": "has_global_flag = spanish_civil_war NOT = { has_global_flag = scw_over } has_government = fascism any_country = { has_idea = SPA_death_before_surrender has_volunteers_amount_from = { tag = ROOT count > 0 } }"
            },
            "options": [
                {
                    "name": "Press on with the advance.",
                    "ai": 50,
                    "effects": [
                        {
                            "army_experience": 5
                        }
                    ]
                },
                {
                    "name": "Hold the column until the weather clears.",
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
            "key": "hitler_visit_italy",
            "title": "Hitler Leaves Italy at the Brenner",
            "desc": "Hitler's train left Florence after midnight and reached the Brenner on the morning of 9 May. His visit had taken him to Rome, Naples and Florence.\n\nMussolini waited for him at the Ostiense station, built for the occasion and not yet finished. A display was given by 50,000 balilla and avanguardisti. The best of the Regia Marina took part in a naval parade, and on the evening of 5 May Hitler watched Aida at the Teatro San Carlo with the King.",
            "picture": "naples_fleet_1938",
            "factSheet": "hitler_visit_italy",
            "anchors": [
                "Ostiense",
                "Teatro San Carlo",
                "Brenner"
            ],
            "fire": {
                "after": "1938.5.9",
                "before": "1938.6.15",
                "chance": 40,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini } OR = { has_idea = vittorio_emanuele has_idea = vittorio_emanuele_emperor_of_ethiopia has_idea = vittorio_emanuele_king_of_albania has_idea = vittorio_emanuele_albania_ethiopia } GER = { has_government = fascism has_country_leader = { character = GER_adolf_hitler } }"
            },
            "options": [
                {
                    "name": "A fine display of friendship.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "The guests have gone. Back to work.",
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
            "key": "world_cup_1938",
            "title": "Italy Keeps the World Cup",
            "desc": "At the Stade Olympique de Colombes, in front of 45,000 spectators, Italy defended its title. After six minutes Gino Colaussi opened the scoring, and Pál Titkos equalised for Hungary two minutes later. Piola scored his second goal to complete a 4-2 win.\n\nThe referee was Georges Capdeville of France. How does Rome receive the champions?",
            "picture": "italy_team_1938",
            "factSheet": "world_cup_1938",
            "anchors": [
                "Colombes",
                "Colaussi",
                "Titkos"
            ],
            "fire": {
                "after": "1938.6.19",
                "before": "1938.7.31",
                "chance": 40,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } FRA = { has_war = no }"
            },
            "options": [
                {
                    "name": "Receive the team in Rome.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Let the football speak for itself.",
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
            "key": "bartali_tour_1938",
            "title": "Bartali Wins the Tour de France",
            "desc": "Gino Bartali wins the Tour de France, which ran from 5 to 31 July over 4,694 km, and also takes the mountains classification. He had been close to winning in 1937 until he crashed. This year he was asked to skip the Giro d'Italia.\n\nWhat will Rome make of an Italian winner in France?",
            "picture": "bartali_1936",
            "factSheet": "bartali_tour_1938",
            "anchors": [
                "Bartali",
                "4,694 km",
                "Giro d'Italia"
            ],
            "fire": {
                "after": "1938.7.31",
                "before": "1938.9.15",
                "chance": 40,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } FRA = { has_war = no }"
            },
            "options": [
                {
                    "name": "Send a telegram of congratulation.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Remind the papers that he rode for Italy.",
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
            "id": 15,
            "key": "albania_landing",
            "title": "Albania Offers Its Crown to the King",
            "desc": "The Albanian parliament voted to depose Zog and to unite the nation with Italy. The Albanian crown was offered to Italy's King Victor Emmanuel III.\n\nZog took refuge in exile in neighbouring Greece. How should we answer the offer of the crown?",
            "picture": "durres_1939",
            "factSheet": "albania_landing",
            "anchors": [
                "Zog",
                "Victor Emmanuel III"
            ],
            "fire": {
                "after": "1939.1.1",
                "before": "1941.1.1",
                "chance": 50,
                "trigger": "NOT = { country_exists = ALB } 44 = { is_owned_by = ROOT } has_character = ITA_vittorio_emanuele_iii NOT = { has_country_flag = ITA_deposed_the_king } OR = { has_idea = vittorio_emanuele has_idea = vittorio_emanuele_emperor_of_ethiopia has_idea = vittorio_emanuele_king_of_albania has_idea = vittorio_emanuele_albania_ethiopia } GRE = { exists = yes }"
            },
            "options": [
                {
                    "name": "Accept the crown for the King.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.03
                        }
                    ]
                },
                {
                    "name": "The crown can wait; the army will garrison Albania.",
                    "ai": 40,
                    "effects": [
                        {
                            "army_experience": 5
                        }
                    ]
                }
            ]
        },
        {
            "id": 20,
            "key": "taranto_night",
            "title": "British Aircraft Strike the Fleet at Taranto",
            "desc": "Enemy aircraft attack the naval base of Taranto in the first hours of the night. The attack is launched from a British carrier. A torpedo hits one of our battleships and blows a large hole in her hull. Another battleship escapes undamaged.\n\nWhat are our orders?",
            "picture": "taranto_aftermath",
            "factSheet": "taranto_night",
            "anchors": [
                "Taranto",
                "naval base"
            ],
            "fire": {
                "after": "1940.1.1",
                "before": "1945.1.1",
                "chance": 8,
                "trigger": "has_war_with = ENG 849 = { is_controlled_by = ROOT } has_navy_size = { size > 1 unit = battleship } ENG = { has_capitulated = no has_navy_size = { size > 0 unit = carrier } }"
            },
            "options": [
                {
                    "name": "Issue a short communique.",
                    "ai": 55,
                    "effects": [
                        {
                            "political_power": 15
                        }
                    ]
                },
                {
                    "name": "Move the undamaged ships out of Taranto.",
                    "ai": 45,
                    "effects": [
                        {
                            "navy_experience": 5
                        }
                    ]
                }
            ]
        }
    ]
}
```
