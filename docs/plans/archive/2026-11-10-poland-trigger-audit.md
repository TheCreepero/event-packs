# Poland pack: tighter triggers

Status: DONE
Pack: poland (POL, namespace ep_pol)
Kind: audit fixes
Created: 2026-11-10

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block holds, with `"mergeById": true`, only the events this plan changes, each as its whole object. No text, fact-sheet section or picture changes. Step 1 writes the block with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

The owner asked for a check of every released pack's triggers: does each event fire only in a game where its text is true, also off the historical path (a leader replaced, a regime changed, a war that starts the other way round)? A `trigger-checker` agent on Opus checked all 20 Poland events against the game files (1.19.4.2) on 2026-11-09; the planner reviewed its report, settled two of its open points from the documentation and ran the fixes it had not tested. This plan holds the report, the owner's decisions and the approved fixes: ten events get a new trigger, no text changes. The pack's three war events already follow the war rule (wide window, no date in the text).

## Audit report

How a gap was weighed: a human reads an event only while playing Poland. A gap counts when a plain historical game, a non-historical AI or the Poland player's own choice of another branch can open it; a gap that only a human-run other country or a conquest can open gets a pin only when the pin is one cheap leaf.

Facts the findings rest on (checker, `common/national_focus/poland.txt`):
- The Regency: `POL_assemble_the_regency_council` (7593-7673) is a 35-day root focus with no condition and a non-historical AI weight of 2.5. It removes Sanation and the President, from 1936.2.5 at the earliest.
- A communist Poland needs communism above 0.49 (from 19 per cent), a fascist one fascism above 0.5 (from 11 per cent). The fascist path can end in `POL_become_german_puppet_effect`, which hands Germany Danzig (85), Gdynia (807) and Poznań (86) (`common/scripted_effects/POL_scripted_effects.txt:675-712`).
- Germany's `GER_danzig_or_war` has an AI weight of 0 before 1939.1.1, so before 1939 only a human-run Germany takes Danzig and Gdynia by `germany.86`.
- Mościcki can lead only the non-aligned government (`common/characters/POL.txt:167`). Składkowski, Sapieha and Delbos are not characters.

### Critical

1. `westerplatte` (war event): `has_war_with = GER` also holds when Poland started the war (`POL_demand_pomerania` through `pavel_events.3` option b, `NSB_poland_events.302` option a and `NSB_polish_fascist_events.1` give Poland a wargoal on Germany). The text has a German battleship open fire on the garrison in the early morning.

### Important

2. `independence_day_1937`: a state holiday that commemorates Piłsudski, under the Regency, a communist or a fascist Poland.
3. `fon_1936`: "created by a decree of the President" under the Regency, which has no President.
4. `pyry_enigma`: the Enigma methods shared with a France or Britain that went fascist or communist outside Germany's faction, or with a capitulated Britain. The trigger only asks that they exist and are not in Germany's faction.
5. `rambouillet_loan`: Delbos and the Popular Front's loan after France took the National Bloc (`FRA_revive_the_national_bloc`, a 70-day root focus that excludes the Popular Front, `common/national_focus/france.txt:4847-4920`) or left democracy.
6. `zbaszyn_refugees_1938`: Zbąszyń "on the border" with Poznań German and Poland a German puppet.

### Minor

7. `gdynia_boom_1936`, `destroyers_grom_blyskawica` ("Base both at Gdynia"): Gdynia handed to Germany. One leaf each.
8. `wilimowski_brazil_1938`: a World Cup match in Strasbourg in a France at war. `gordon_bennett_1938`: a balloon race from Liège in a Belgium at war. Only a human-run Germany gets there by 1938; one leaf each, added on the owner's word.

### Intentionally unchanged

`kasprowy_cable_car`, `batory_maiden_voyage`, `berlin_olympics_team`, `spitsbergen_crossing`, `pzl37_los_first_flight`, `chopin_competition_1937`, `szymanowski_funeral`, `nanda_devi_east`: nothing the trigger leaves open can change before the window closes, or the text names no office holder or regime. `wawel_coffin_1937`, `hungary_border_1939`: the checker left them open on whether `has_country_leader = { character = ... }` without `ruling_only` also matches a leader out of power. The documentation settles it: `ruling_only = yes/no (default = yes)` (`documentation/triggers_documentation.md:3640`), so the Mościcki and Horthy leaves mean the ruling leader, and both events stay as they are.

## Decisions

Owner, 2026-11-10: the cheap pins are added, the two optional ones (`wilimowski_brazil_1938`, `gordon_bennett_1938`) too.

Owner, 2026-11-10, on the open point of the trigger check: `westerplatte` asks for `has_defensive_war_with = GER` as it stands, with no probe first ("Vanilla game's usage of it is proof enough"). The evidence is vanilla's own use of the trigger for the country Germany attacks (`events/NewsEvents.txt:5203`; `common/peace_conference/cost_modifiers/00_generic_peace.txt:228-232`). No file proves how the engine reads it, and if it read it otherwise the event would never fire: step 11 is where that would show, and the old `has_war_with = GER` is the fallback, in a plan of its own.

Planner's choices:
- The Gdynia pins are `owns_state = 807` alone; the checker's `controls_state = 807` adds nothing in an event that also needs `has_war = no`.
- The two optional pins are one leaf each (`FRA = { has_war = no }`, `BEL = { has_war = no }`), not the checker's state leaves.
- `fon_1936` takes the Regency leaf, not a text change: it blocks the event for a Regency founded after the fund's date, where the text would still be true, which costs less than rewriting a text no fact has changed in.

## Events

Only the events this plan changes. Windows, chances, texts, pictures, options and effects stay as they are.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 5 | rambouillet_loan | France Promises Poland a Loan of Two Billion Francs | 1936.9.7 to 1936.10.31 | 50 | unchanged | unchanged |
| 7 | gdynia_boom_1936 | Gdynia Grows to 102,000 Inhabitants | 1937.1.1 to 1937.3.31 | 50 | unchanged | unchanged |
| 11 | independence_day_1937 | Independence Day Is Celebrated as a State Holiday | 1937.11.11 to 1937.12.15 | 100 | unchanged | unchanged |
| 12 | destroyers_grom_blyskawica | ORP Błyskawica Enters Service in the Polish Navy | 1937.11.26 to 1938.1.31 | 50 | unchanged | unchanged |
| 13 | wilimowski_brazil_1938 | Poland Loses 6-5 to Brazil at the World Cup | 1938.6.6 to 1938.6.30 | 100 | unchanged | unchanged |
| 14 | gordon_bennett_1938 | Janusz and Janik Win the Gordon Bennett Cup | 1938.9.15 to 1938.10.15 | 50 | unchanged | unchanged |
| 15 | zbaszyn_refugees_1938 | Polish Jews Expelled from Germany Are Sent to Zbąszyń | 1938.11.1 to 1938.12.31 | 50 | unchanged | unchanged |
| 18 | fon_1936 | The National Defence Fund Gathers Gifts | 1938.1.1 to 1947.12.31 | 100 | unchanged | unchanged |
| 19 | pyry_enigma | French and British Representatives Come to Pyry | 1939.1.1 to 1947.12.31 | 100 | unchanged | unchanged |
| 20 | westerplatte | Schleswig-Holstein Opens Fire on Westerplatte | 1939.1.1 to 1947.12.31 | 100 | unchanged | unchanged |

New triggers:

| Key | `fire.trigger` |
|---|---|
| rambouillet_loan | `has_war = no FRA = { exists = yes has_government = democratic NOT = { has_completed_focus = FRA_revive_the_national_bloc } }` |
| gdynia_boom_1936 | `has_war = no owns_state = 807` |
| independence_day_1937 | `has_war = no has_government = neutrality NOT = { has_completed_focus = POL_assemble_the_regency_council }` |
| destroyers_grom_blyskawica | `has_war = no owns_state = 807` |
| wilimowski_brazil_1938 | `has_war = no FRA = { has_war = no }` |
| gordon_bennett_1938 | `has_war = no BEL = { has_war = no }` |
| zbaszyn_refugees_1938 | `has_war = no GER = { has_government = fascism } owns_state = 86 NOT = { is_subject_of = GER }` |
| fon_1936 | `OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } has_war_with = GER } has_capitulated = no NOT = { has_completed_focus = POL_assemble_the_regency_council }` |
| pyry_enigma | `has_war = no OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } } FRA = { exists = yes has_capitulated = no has_government = democratic NOT = { is_in_faction_with = GER } } ENG = { exists = yes has_capitulated = no has_government = democratic NOT = { is_in_faction_with = GER } } owns_state = 10` |
| westerplatte | `has_defensive_war_with = GER owns_state = 85 controls_state = 85 NOT = { war_length_with = { tag = GER months > 1 } }` |

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

Round 1, `trigger-checker` on Opus over `source/poland/events.json`, 2026-11-09: 8 OK, 9 FIX, 3 OPEN. The checker stopped its lookups when `Test-HoiConditions.ps1` contradicted its reference (below), so five of its fixes reached the planner untested; the planner ran them.

| Event | Verdict |
|---|---|
| kasprowy_cable_car, batory_maiden_voyage, berlin_olympics_team, spitsbergen_crossing, pzl37_los_first_flight, chopin_competition_1937, szymanowski_funeral, nanda_devi_east | OK |
| wawel_coffin_1937, hungary_border_1939 | OPEN on `ruling_only`; closed by the documentation (default `yes`): OK, unchanged |
| rambouillet_loan | FIX: France democratic and not on the National Bloc |
| gdynia_boom_1936, destroyers_grom_blyskawica | FIX: Gdynia (807) Polish |
| independence_day_1937 | FIX: non-aligned government and no Regency |
| wilimowski_brazil_1938 | OPEN (can France be at war or lose Alsace by June 1938?); closed by the pin `FRA = { has_war = no }` |
| gordon_bennett_1938 | FIX: Belgium at peace |
| zbaszyn_refugees_1938 | FIX: Poznań (86) Polish, Poland no subject of Germany |
| fon_1936 | FIX: no Regency |
| pyry_enigma | FIX: France and Britain democratic, Britain not capitulated |
| westerplatte | FIX: `has_defensive_war_with = GER` (`documentation/triggers_documentation.md:3711`); how it reads for a country that joined an ally's war is unverified, and it fails closed |

Planner's run of the five untested fixes (`Test-HoiConditions.ps1 -Trigger ... -Root POL`, 2026-11-09): `fon_1936` at 1939.1.1, `pyry_enigma` at 1939.1.1, `westerplatte` at 1939.9.1, `zbaszyn_refugees_1938` at 1938.11.1, `gdynia_boom_1936` at 1937.1.1: every result OPEN on run-time leaves only, the state and government leaves HOLD, no dead leaf except the one below.

A defect of the lookup, reported to the owner and to the Manager: `Test-HoiConditions.ps1` reads `has_completed_focus = POL_assemble_the_regency_council` as `NEVER SET | focus ... is in tree polish_focus, which is not the tree of POL`, and `FRA_revive_the_national_bloc` as "not in the tree of FRA". Both focuses are in their country's tree (`common/national_focus/poland.txt:4-15` and `7592`, `france.txt:4-11` and `4847`; `Get-HoiFocusTree.ps1` reads them right). The two leaves are valid; the tool's verdict on them is not used.

Round 2, `trigger-checker` on Opus over this plan's block, 2026-11-10 (`Test-HoiConditions.ps1 -Events`, no dead leaf; the two `has_completed_focus` leaves confirmed with `Get-HoiFocusTree.ps1 -Focus`): 9 OK, 0 FIX, 1 OPEN.

| Event | Round 2 |
|---|---|
| rambouillet_loan | OK. The historical French AI takes `FRA_begin_rearmament`, then the Popular Front (`common/ai_strategy_plans/FRA_historical_strategy_plan.txt:43-44`), which excludes the National Bloc (`france.txt:4898`, `1617`); the National Bloc is only in the alternate plans. 7 to 8 checks at 50 per cent. |
| gdynia_boom_1936, destroyers_grom_blyskawica | OK. Every script that moves state 807 is off the historical path before 1939. |
| independence_day_1937 | OK. The historical Polish AI starts with `POL_complete_april_constitution` (`POL_historical_strategy_plan.txt:29`), which excludes the Regency (`poland.txt:2008`); the Regency branch needs No Step Back (`poland.txt:7595`). Sławek or Rydz-Śmigły as leader keep the non-aligned government (`events/Poland.txt:1281-1302`, `1374-1395`), and the text stays true under them. Fires at the first check. |
| wilimowski_brazil_1938, gordon_bennett_1938 | OK. Nothing on the historical path puts France or Belgium at war in 1938. |
| zbaszyn_refugees_1938 | OK. `is_subject_of = <TAG>` from country scope is documented (`documentation/triggers_documentation.md:6285`) and used by vanilla (`common/achievements.txt:1964`). |
| fon_1936 | OK in both starts; the 1939 start has `POL_complete_april_constitution` done (`history/countries/POL - Poland.txt:148`). |
| pyry_enigma | OK. France and Britain are democratic in 1939 with the historical AI. In the 1939 start the event can be lost if Germany declares war before the first weekly check (unchanged from the shipped event). |
| westerplatte | OPEN. Germany is the attacker in the historical chain (`germany.88` creates the wargoal in Germany's scope, `events/Germany.txt:8843-8948`; the 1939 start holds it in Germany's history, `GER - Germany.txt:490-494`), and vanilla uses `has_defensive_war_with` for the country Germany attacks (`events/NewsEvents.txt:5203`; `common/peace_conference/cost_modifiers/00_generic_peace.txt:228-232`, "Attacked by country directly"). The files cannot show that the engine gives Poland the defender's role when the German AI declares. If it did not, the event would never fire. Closed by the owner's decision of 2026-11-10 (see "Decisions"): accepted on vanilla's use, no probe. The checker's probe list is below the table. |

The probe list for `westerplatte`, not run: the owner accepted the trigger without it. It is kept for the case that the event does not come in step 11 (a list for `New-HoiTriggerProbe.ps1`, checked by the checker with `-WhatIf`; run the 1939.8.14 bookmark and a 1936 game with historical focus, Poland under AI or observer, sampled daily). It is settled when `P9_pol_defensive_at_p2` logs 1 and the hook logs ROOT=GER, FROM=POL:

```json
{
    "probes": [
        { "name": "P2_pol_at_war_with_ger", "scope": "POL", "trigger": "has_war_with = GER" },
        { "name": "P9_pol_defensive_war_with_ger", "scope": "POL", "trigger": "has_defensive_war_with = GER" },
        { "name": "P9_pol_defensive_at_p2", "scope": "POL", "with": "P2_pol_at_war_with_ger", "trigger": "has_defensive_war_with = GER" },
        { "name": "P9_pol_offensive_at_p2", "scope": "POL", "with": "P2_pol_at_war_with_ger", "trigger": "has_offensive_war_with = GER" },
        { "name": "P9_westerplatte_gate_at_p2", "scope": "POL", "with": "P2_pol_at_war_with_ger", "trigger": "has_defensive_war_with = GER owns_state = 85 controls_state = 85" },
        { "name": "P9_westerplatte_gate", "scope": "POL", "trigger": "has_defensive_war_with = GER owns_state = 85 controls_state = 85 NOT = { war_length_with = { tag = GER months > 1 } }" },
        { "name": "P9_pol_lost_danzig_in_war", "scope": "POL", "trigger": "has_war_with = GER NOT = { controls_state = 85 }" },
        { "name": "P8_on_war_relation_added", "hook": "on_war_relation_added" }
    ]
}
```

## Editor record

No text changes: the editor has nothing to judge.

## Kept on judgment

None. The gate rehearsal of 2026-11-10 (a copy under `scratch\rehearsal`) ran steps 1 to 9 as written: `-ApplyPlan` `Applied`, events 5, 7, 11, 12, 13, 14, 15, 18, 19 and 20 changed (fire), 10 unchanged; the dry run `0 file(s) would be written`; `-ConvertPictures` `failed=0`; `-Generate` 20 events, 1 file written (`common/on_actions/ep_pol_on_actions.txt`); `-Check` OK with 0 warnings, `Bundle 'all': 4 member(s), 0 error(s)`; `-RenderEvents` 20 events with no `[WARN]`, every render byte for byte the one the repository has now; `-ValidateOnly` succeeded. The render hashes are in `scratch\render-hashes-poland.txt`.

## Implementation steps

- [x] 1. Write the source from the block below: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-poland-trigger-audit.md`: expect `Applied 2026-11-10-poland-trigger-audit.md`, with no `[WARN]` outside "Kept on judgment", and the events it lists as changed being ids 5, 7, 11, 12, 13, 14, 15, 18, 19 and 20. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [x] 2. Check that the source holds the block: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-10-poland-trigger-audit.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [x] 3. No pictures to fetch (the table is empty).
- [x] 4. Thumbnail unchanged: nothing to run.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack poland`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack poland`: expect `Generated pack 'poland'`. The intro texts stay as they are.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack poland`: expect `Check OK` and `Bundle 'all': 4 member(s), 0 error(s)`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack poland`: expect `Rendered 20 events to ...artifacts\workshop-images\poland`, with no `[WARN]` outside "Kept on judgment". No text changes, so no card changes.
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly`: expect `Validation succeeded.` (the full suite runs once, in `event-pack-implement` 3.2).
- [x] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `fix(poland): tighter triggers`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The Workshop upload is `event-pack-release`.
- [ ] 11. Owner, in game (not the implementer): in a 1939-start game as Poland, check that `westerplatte` still fires in the first week of the German attack (its gate is now `has_defensive_war_with = GER`). `ep_pol_all` fires the events without their triggers, so it does not test this.

## Stop conditions

- `-ApplyPlan`, `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.
- `-ApplyPlan` lists an event other than ids 5, 7, 11, 12, 13, 14, 15, 18, 19 and 20 as changed: stop.

## Outcome

2026-11-10. `-Check -Pack poland`: `Check OK: 1 pack(s), 1 bundle(s), 0 warning(s).` (`Bundle 'all': 4 member(s), 0 error(s)`; `Pack 'poland': 20 event(s), 17 picture(s), 0 error(s)`). `-ApplyPlan` changed events 5, 7, 11, 12, 13, 14, 15, 18, 19, 20; dry run 0 files; `-ConvertPictures` failed=0; `-Generate` 1 file written; `-RenderEvents` 20 events, no `[WARN]`; `-ValidateOnly` succeeded (its three `[WARN]` lines are France picture licences, not Poland). Steps 10 and 11 left unticked (ship and owner's in-game check). No deviations.

## Fact sheets

No section changes.

## Events source

The ten events this plan changes, each as its whole object with its id unchanged (`docs/source-format.md`, "Plans").

```json events
{
    "pack": "poland",
    "tag": "POL",
    "mergeById": true,
    "events": [
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
                "trigger": "has_war = no FRA = { exists = yes has_government = democratic NOT = { has_completed_focus = FRA_revive_the_national_bloc } }"
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
                "trigger": "has_war = no owns_state = 807"
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
                "trigger": "has_war = no has_government = neutrality NOT = { has_completed_focus = POL_assemble_the_regency_council }"
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
                "trigger": "has_war = no owns_state = 807"
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
                "trigger": "has_war = no FRA = { has_war = no }"
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
                "trigger": "has_war = no BEL = { has_war = no }"
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
                "trigger": "has_war = no GER = { has_government = fascism } owns_state = 86 NOT = { is_subject_of = GER }"
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
                "trigger": "OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } has_war_with = GER } has_capitulated = no NOT = { has_completed_focus = POL_assemble_the_regency_council }"
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
                "trigger": "has_war = no OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } } FRA = { exists = yes has_capitulated = no has_government = democratic NOT = { is_in_faction_with = GER } } ENG = { exists = yes has_capitulated = no has_government = democratic NOT = { is_in_faction_with = GER } } owns_state = 10"
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
                "trigger": "has_defensive_war_with = GER owns_state = 85 controls_state = 85 NOT = { war_length_with = { tag = GER months > 1 } }"
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
    ]
}
```
