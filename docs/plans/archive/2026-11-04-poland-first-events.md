# Poland pack: the first events

Status: DONE
Pack: poland (POL, namespace ep_pol)
Kind: new pack
Created: 2026-11-04

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/<pack>/events.json`, the `markdown fact-sheets` block holds the sections for `source/<pack>/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

## Context

The first round of events for the Poland pack. The pack's skeleton (`source/poland/`, `packs/poland/`, descriptor, namespace `ep_pol`, placeholder thumbnail, registration in `tools/HoiModBuild.json`) was made with `build.ps1 -NewPack -Pack poland -Tag POL -DisplayName "Poland"` on 2026-11-04, and `source/poland/workshop-intro.bbcode` was written then; the pack has no events yet. Written by the `event-pack-create` skill.


Reopened (2026-11-05). The plan was implemented once (all checks passed). The `ep-reviewer` then found that the Westerplatte trigger could never be true in a normal game: `DNZ = { exists = yes }` asks whether the country Danzig exists, and in the base game Poland owns Danzig (state 85, `history/states/85-Danzig.txt`) and the country does not exist. The planner had turned the editor's "Danzig ownership check" into that trigger without looking up how Danzig is set up. Corrections made here, in the `json events` block only (no event text changed, so no editor round): westerplatte gates on `owns_state = 85`; fon_1936 fires when Germany has a wargoal against Poland or Poland is already at war with Germany (its text holds in both cases), so a fast declaration cannot make it miss; the three state-gated events end on 1947.12.31 instead of 1941.12.31; hungary_border_1939 adds `NOT = { has_war_with = HUN }`, because its text has Polish troops welcoming the Hungarians; pyry_enigma adds `FRA = { exists = yes } ENG = { exists = yes }`, because its text has French and British delegates visiting. Steps 2 to 5 stand from the first implementation (fact sheets, pictures and thumbnail did not change); steps 1 and 6 to 9 run again. Settled afterwards: the Manager session built the `trigger-checker` and the plan went through it in three rounds ("Trigger verification"); the window of fon_1936 and pyry_enigma now follows the Danzig-or-war focus in progress as well as the wargoal, and westerplatte fires within a month of the war's start. Accepted-unverified engine points are listed there, for the owner's in-game check.

## Decisions

Owner's answers, 2026-11-04:
- Country: Poland, tag `POL` (confirmed with `Get-HoiCountry`).
- Number of events: about 20, the same as France.
- Period, kinds and exclusions were not given; the skill's defaults and the planner's reading apply (recorded here so the owner can correct them): 1936 to the German invasion of 1 September 1939, with the first weeks of the September campaign as the only wartime stretch, since the vanilla state of Poland ends there; all four kinds in balance (politics and society; military and defence; culture and everyday life; empire and diplomacy).
- Period confirmed by the owner (2026-11-04). Owner's rule: Germany can invade Poland at a non-historical date that varies from game to game. Any event that refers to the war, or to preparation for it, is gated on the actual situation in the game (for example Germany at war with Poland, or a trigger that shows the war is near), never on a date window. Consequences for the plan: the text of such an event states no historical date for the invasion or for the preparations and must be true whenever it fires; a peacetime event keeps a date window but is also blocked once Poland is at war; a war event's anchor is the war itself, not 1 September 1939. The trigger names are checked with `Find-HoiDoc` and vanilla usage when the events are written (Phase 4).
- Replacement after editor round 1 (2026-11-05): the editor rejected liberia_mission (no dated happening inside its 1936-1937 window; the quotes name no buyer, year or destination). The first alternate, batory_maiden_voyage, took its place, through Phase 3a and a picture search; liberia_mission stays in the dossier for a later round. The Westerplatte trigger first required `DNZ = { exists = yes }`; that was wrong (see Context, "Reopened") and is now `owns_state = 85`, so the event does not fire once Danzig has been ceded.
- Triggers for the state-gated events (owner confirmed the kind, 2026-11-04; names checked with `Find-HoiDoc`): build-up events gate on `GER = { has_wargoal_against = POL }` (`documentation/triggers_documentation.md:5085`), wartime events on `has_war_with = GER` (`:5051`). Whether the build-up trigger also holds for an AI Germany that never gets a wargoal is checked against vanilla usage in Phase 4.
- Events chosen (owner, 2026-11-04), 20 of the 46 candidates in `research/poland/2026-11-04-dossier.md` and `-2` to `-5`: kasprowy_cable_car, gdynia_boom_1936, spitsbergen_crossing, berlin_olympics_team, rambouillet_loan, destroyers_grom_blyskawica, pzl37_los_first_flight, chopin_competition_1937, szymanowski_funeral, independence_day_1937, wawel_coffin_1937, liberia_mission, wilimowski_brazil_1938, gordon_bennett_1938, zbaszyn_refugees_1938, hungary_border_1939, nanda_devi_east, fon_1936, pyry_enigma, westerplatte. State-gated: fon_1936 and pyry_enigma on `GER = { has_wargoal_against = POL }`, westerplatte on `has_war_with = GER`; hungary_border_1939 needs a game-state check (Hungary holding Carpatho-Ukraine) or is replaced by japan_embassies_1937. Alternates, in order: batory_maiden_voyage, pilsudski_mound_1937, pilsudski_name_act_1938, kul_state_rights_1938, japan_embassies_1937, carol_ii_visit_1937, greenland_expedition_1937, last_game_hungary, huberman_orchestra; war and build-up alternates operation_peking, mobilisation_postponed, gold_reserve. Dropped before the choice: air_defence_loan, paris_expo_pavilion_1937, marshal_baton, sejm_election_1938, rhineland_reaction, beck_sejm_speech (vanilla overlap or thin or unverified); warszawa_ii_radio_1937, minorities_declaration_1937, beck_rome_1938, goring_bialowieza, dar_pomorza_horn_1936 (thin or weakly sourced); madagascar_commission and przytyk_aftermath (sensitive, not chosen).
- Excluded: topics vanilla Poland already stages, so the pack fires no duplicate. Events (`events/Poland.txt`): the Four Year Plan (`poland.20`), the Sanation Left and OZN triumphs (`poland.17`, `poland.18`), Sławek's suicide (`poland.19`), the peasants' strike (`poland.24`), industry sabotage (`poland.23`), Danzig (`poland.21`, `poland.2101`, `poland.2102`, `poland.22`), the Międzymorze (`poland.16`), the eastern demands and protection offers (`poland.1` to `poland.7`). Focuses (`common/national_focus/poland.txt`): the Central Industrial Region, the Four Year Plan, the April Constitution, Plan West and Plan East fortifications, the Hel and Silesia fortified areas, the Baltic and Lithuanian ultimatums, Annex Czechoslovakia, Protect Czechoslovakia, the Romanian alliance, foreign motor companies, the Polish School of Mathematics.

## Events

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| ep_pol.1 | kasprowy_cable_car | Cable Car Opens on Kasprowy Wierch | 1936.3.16 to 1936.4.30 | 50 | kasprowy_cable_car | Keep the fares low enough for ordinary skiers. -> stability 0.02; Our ski patrols will use it too. -> war_support 0.01 |
| ep_pol.2 | batory_maiden_voyage | MS Batory Begins Her Maiden Voyage | 1936.5.19 to 1936.5.31 | 100 | batory_maiden_voyage | Let her sail as the nation's showpiece. -> stability 0.02; She must pay her way on the Atlantic. -> political_power 10 |
| ep_pol.3 | berlin_olympics_team | Poland Brings Six Medals Home from the Olympics | 1936.8.17 to 1936.9.30 | 50 | berlin_olympics_team | Honour every medallist and every competitor. -> stability 0.02; Gold will come. Fund the clubs for the next Games. -> political_power -15, war_support 0.01 |
| ep_pol.4 | spitsbergen_crossing | Three Men Complete the First Traverse of Spitsbergen | 1936.9.2 to 1936.10.31 | 50 | spitsbergen_crossing | Receive them in Warsaw with honours. -> war_support 0.01; Let the mountaineering clubs celebrate their own. -> political_power 10 |
| ep_pol.5 | rambouillet_loan | France Promises Poland a Loan of Two Billion Francs | 1936.9.7 to 1936.10.31 | 50 | rambouillet_loan | Order the guns and aircraft the army lacks. -> war_support 0.02; Take care to stay independent of Paris. -> stability 0.01 |
| ep_pol.6 | pzl37_los_first_flight | The PZL.37 Łoś Bomber Flies for the First Time | 1936.12.14 to 1937.1.31 | 50 | pzl37_los_first_flight | Fix the shortcomings before it reaches the squadrons. -> air_experience 5; Put it into production now. -> war_support 0.02 |
| ep_pol.7 | gdynia_boom_1936 | Gdynia Grows to 102,000 Inhabitants | 1937.1.1 to 1937.3.31 | 50 | gdynia_boom_1936 | Build streets and houses for the new workers. -> idea gdynia_housing 150d; Housing can wait. The quays cannot. -> political_power 15 |
| ep_pol.8 | chopin_competition_1937 | Yakov Zak Wins the Third Chopin Competition | 1937.3.14 to 1937.4.15 | 50 | chopin_competition_1937 | The jury has spoken. Congratulate the winner. -> stability 0.02; Found a prize for Polish music beside the competition. -> political_power -10, stability 0.01 |
| ep_pol.9 | szymanowski_funeral | Karol Szymanowski Is Buried at Skałka | 1937.4.10 to 1937.5.10 | 50 | szymanowski_funeral | Keep the Crypt of the Distinguished for such men. -> stability 0.02; Print his scores at the state's expense. -> political_power -10, stability 0.01 |
| ep_pol.10 | wawel_coffin_1937 | Archbishop Sapieha Moves Piłsudski's Coffin | 1937.7.1 to 1937.8.15 | 50 | wawel_coffin_1937 | Stand with the committee and the President. -> political_power 15, stability -0.01; Settle it quietly with the archbishop. -> stability 0.02 |
| ep_pol.11 | independence_day_1937 | 11 November Is Celebrated as a State Holiday | 1937.11.11 to 1937.12.15 | 100 | vanilla:GFX_report_event_soldiers_parade | A parade of the army through Warsaw. -> war_support 0.02; A holiday for every town and village. -> stability 0.02 |
| ep_pol.12 | destroyers_grom_blyskawica | ORP Błyskawica Enters Service in the Polish Navy | 1937.11.26 to 1938.1.31 | 50 | destroyers_grom_blyskawica | Base both at Gdynia to guard the coast. -> war_support 0.02; Train the crews at sea before anything else. -> navy_experience 5 |
| ep_pol.13 | wilimowski_brazil_1938 | Poland Loses 6-5 to Brazil at the World Cup | 1938.6.6 to 1938.6.30 | 50 | wilimowski_brazil_1938 | They gave the Brazilians a fight. Well played. -> stability 0.02; Five goals and still beaten. The defence must improve. -> war_support 0.01 |
| ep_pol.14 | gordon_bennett_1938 | Janusz and Janik Win the Gordon Bennett Cup | 1938.9.15 to 1938.10.15 | 50 | gordon_bennett_1938 | Praise the airmen who flew it. -> war_support 0.01; Fund the balloon crews for next year's race. -> air_experience 5 |
| ep_pol.15 | zbaszyn_refugees_1938 | Polish Jews Expelled from Germany Are Sent to Zbąszyń | 1938.11.1 to 1938.12.31 | 50 | vanilla:GFX_report_event_german_polish_border | Admit them and organise relief at Zbąszyń. -> political_power -20, stability 0.01; Keep the border shut until Berlin negotiates. -> political_power 10 |
| ep_pol.16 | hungary_border_1939 | Polish and Hungarian Soldiers Meet at the Border | 1939.3.17 to 1947.12.31 | 50 | vanilla:GFX_report_event_generic_handshake | A common border with Hungary is a gain. -> war_support 0.02; Keep the celebrations quiet. Berlin is watching. -> stability 0.02 |
| ep_pol.17 | nanda_devi_east | Nanda Devi East Climbed, Two Climbers Lost | 1939.7.20 to 1939.9.30 | 50 | nanda_devi_east | Honour the two who died and the two who stood on top. -> stability 0.02; Fund the next Polish expedition to the Himalaya. -> political_power -10, war_support 0.01 |
| ep_pol.18 | fon_1936 | The National Defence Fund Gathers Gifts | 1938.1.1 to 1947.12.31 | 100 | fon_1936 | Put collection boxes in every shop and school. -> war_support 0.02; Ask the firms and the councils to give first. -> political_power -10, stability 0.01 |
| ep_pol.19 | pyry_enigma | French and British Representatives Come to Pyry | 1939.1.1 to 1947.12.31 | 100 | pyry_enigma | Share everything with Paris and London. -> idea pyry_cooperation 120d; Show them only what they need to see. -> command_power 5 |
| ep_pol.20 | westerplatte | Schleswig-Holstein Opens Fire on Westerplatte | 1939.1.1 to 1947.12.31 | 100 | westerplatte | Hold to the last man. -> war_support 0.02; Save the men if the position cannot be held. -> stability 0.01 |

## Pictures

Every row passed `build.ps1 -FetchPicture ... -DryRun` while planning (`ACCEPTED`); the licence column is what it printed.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|
| kasprowy_cable_car | File:Henryk Poddębski - Sport narciarski (131-G-34-12).jpg | PD (Public domain), 3500x2489, Henryk Poddębski | 50 | warm | kasprowy_cable_car |
| gdynia_boom_1936 | File:Gdynia - P. J. M. 1938 (87071907).jpg | PD (Public domain), 5135x3398, Leonard Durczykiewicz | 50 | warm | gdynia_boom_1936 |
| spitsbergen_crossing | File:Polska wyprawa naukowa na Spitsbergen (1-N-980-3).jpg | PD (Public domain), 3500x2488, unknown photographer | 50 | warm | spitsbergen_crossing |
| berlin_olympics_team | File:PIC 1-M-878-213 Berlin 1936 women 100 m Helen Stephens Stella Walasiewicz.JPG | PD (Public domain), 297x400, Koncern Ilustrowany Kurier Codzienny | 30 | warm | berlin_olympics_team |
| rambouillet_loan | File:Smigly-Rydz and Gamelin.jpg | PD (Public domain), 432x506, unknown author | 40 | warm | rambouillet_loan |
| pzl37_los_first_flight | File:PZL.37 lot.jpg | PD (Public domain), 3433x2289, unknown author | 50 | warm | pzl37_los_first_flight |
| chopin_competition_1937 | File:Jakow Zak1937.jpg | PD (Public domain), 3500x2582, Koncern Ilustrowany Kurier Codzienny | 50 | warm | chopin_competition_1937 |
| szymanowski_funeral | File:Taüt amb el cos de Karol Szymanowski.jpg | CC0 (CC0), 640x469, Photo Gerber - Lausana | 50 | warm | szymanowski_funeral |
| wawel_coffin_1937 | File:Adam Stefan Sapieha 1.jpg | PD (Public domain), 500x700, unknown author | 20 | warm | wawel_coffin_1937 |
| destroyers_grom_blyskawica | File:ORP Blyskawica dok.jpg | PD (Public domain), 3500x2771, unknown author | 50 | warm | destroyers_grom_blyskawica |
| batory_maiden_voyage | File:Gdynia, MS Batory w porcie ante 1939 (67264496).jpg | PD (Public domain), 5892x4243, Henryk Poddębski | 50 | warm | batory_maiden_voyage |
| wilimowski_brazil_1938 | File:Brazil v Poland WC 1938 (3).jpg | PD (Public domain), 3500x2414, unknown author | 50 | warm | wilimowski_brazil_1938 |
| gordon_bennett_1938 | File:Start balonów.jpg | PD (Public domain), 872x451, unknown author | 50 | warm | gordon_bennett_1938 |
| nanda_devi_east | File:Polish Himalayan Expedition (1939)18.jpg | PD (Public domain), 2515x1457, unknown author | 50 | warm | nanda_devi_east |
| fon_1936 | File:Kosztowności od podoficerów 4 dak ofiarowane na FON NAC 1-W-3037-1.jpg | PD (Public domain), 3500x2489, Czesław Pudłowski | 50 | warm | fon_1936 |
| pyry_enigma | File:Polish copy of Enigma made by Biuro Szyfrow.jpg | PD (Public domain), 403x583, uploader Listowy | 50 | none | pyry_enigma |
| westerplatte | File:Westerplatte brama.jpg | PD (Public domain), 468x656, nieznani | 40 | warm | westerplatte |

Vanilla pictures (no accepted Commons file; the picture researcher found only CC BY-SA files or modern photographs): independence_day_1937 uses `vanilla:GFX_report_event_soldiers_parade`, zbaszyn_refugees_1938 uses `vanilla:GFX_report_event_german_polish_border`, hungary_border_1939 uses `vanilla:GFX_report_event_generic_handshake` (names from `interface/eventpictures.gfx`).

Thumbnail: chopin_competition_1937, crop center

## Fact verification

Four `ep-audit-researcher` agents ran in parallel on 2026-11-04, five events each, every fact re-read on its page: A (kasprowy_cable_car, gdynia_boom_1936, spitsbergen_crossing, berlin_olympics_team, rambouillet_loan), B (destroyers_grom_blyskawica, pzl37_los_first_flight, chopin_competition_1937, szymanowski_funeral, independence_day_1937), C (wawel_coffin_1937, liberia_mission, wilimowski_brazil_1938, gordon_bennett_1938, zbaszyn_refugees_1938), D (hungary_border_1939, nanda_devi_east, fon_1936, pyry_enigma, westerplatte). A fact the checker could not read on a page counts as dropped. One event was replaced after the editor's first round (liberia_mission by batory_maiden_voyage, see the last row); the other 19 keep at least 40 words of verified detail.

| Event | KEEP | FIX | DROP |
|---|---|---|---|
| kasprowy_cable_car | 5 | 0 | 1 |
| gdynia_boom_1936 | 4 | 0 | 1 |
| spitsbergen_crossing | 3 | 0 | 2 |
| berlin_olympics_team | 5 | 0 | 0 |
| rambouillet_loan | 3 | 0 | 1 |
| destroyers_grom_blyskawica | 12 | 1 | 1 |
| pzl37_los_first_flight | 5 | 0 | 1 |
| chopin_competition_1937 | 8 | 0 | 1 |
| szymanowski_funeral | 6 | 0 | 2 |
| independence_day_1937 | 6 | 1 | 0 |
| wawel_coffin_1937 | 7 | 0 | 0 |
| liberia_mission (replaced after editor round 1) | 8 | 1 | 1 |
| wilimowski_brazil_1938 | 4 | 0 | 1 |
| gordon_bennett_1938 | 6 | 0 | 1 |
| zbaszyn_refugees_1938 | 7 | 1 | 1 |
| hungary_border_1939 | 6 | 1 | 1 |
| nanda_devi_east | 3 | 2 | 1 |
| fon_1936 | 6 | 2 | 0 |
| pyry_enigma | 5 | 0 | 2 |
| westerplatte | 3 | 3 | 2 |
| batory_maiden_voyage (replacement; one more `ep-audit-researcher`) | 7 | 0 | 1 |
| Total | 119 | 12 | 21 |

Fixes (the corrected fact is the one in the fact sheet):
- destroyers_grom_blyskawica: Błyskawica entered service on 25 November 1937 (dzieje.pl and the English Wikipedia infobox agree; the article body's "1 October 1937" is dropped).
- independence_day_1937: the holiday was meant to link sovereignty with the end of the First World War and to commemorate Piłsudski (the page adds the second aim).
- liberia_mission: the League's Brazilian settlement project, not "Morska Wola" (not used in the text).
- zbaszyn_refugees_1938: the border was "quickly" closed, not "after the first day".
- hungary_border_1939: the border was "only 180 km" long.
- nanda_devi_east: the avalanche killed Karpiński and Bernadzikiewicz; the night of 18/19 July and the heights 7074/7161 m are not on the page (dropped).
- fon_1936: Kusociński's ring "o wadze 9,5 grama" (wording); Kiepura's permission has no years (not used).
- westerplatte: Schleswig-Holstein opened fire at 04:45 (timeline page); the "04:00" variant, Najsarek's 05:15 time and Kleikamp's rank are dropped; no clock time of the surrender is given.

Drops (not in any fact sheet): kasprowy_cable_car cost, 51 percent and the FIS link; gdynia_boom_1936 the 9.3 million tons figure; spitsbergen_crossing 800 km, six weeks and the Sørkapp to Verlegenhuken route; rambouillet_loan the 2.6 billion figure; destroyers_grom_blyskawica the 28 May date for Grom; pzl37_los_first_flight the 7 November 1936 crash; chopin_competition_1937 the Tamarkina nationality discrepancy; szymanowski_funeral the attendees, honours and crowds and the "national manifestation"; liberia_mission the Cameroons claims and Beck at Geneva; wilimowski_brazil_1938 the "unique record"; gordon_bennett_1938 the landing at Troyan; zbaszyn_refugees_1938 the camp closure date; hungary_border_1939 Horthy's visit to Kraków; nanda_devi_east Karpiński as a pilot; pyry_enigma the August delivery of the replicas and the 26-27 July date.

Caveats the editor should weigh: the fetch tool returns summaries, so several quotes are fragments of the page line or the checker's rendering (marked as such by the checkers); the quote of westerplatte's commanders is the infobox, not a sentence; the quotes of berlin_olympics_team's medallists are the table rows beside their names. liberia_mission has no dated event inside 1936-1938, so its text states only what is past by 1936 (the 1934 sailing and plantations) and the mission as a standing series of initiatives. pyry_enigma and westerplatte keep only facts that hold without a calendar date for the war.

Quote-repair round (2026-11-05). The editor judged many quotes to be fragments that name neither who nor what, so three `ep-audit-researcher` agents re-read the flagged facts for complete lines, and one follow-up agent checked three more. Results used in the fact sheets: wawel_coffin_1937 (verbatim sentences naming Sapieha, the committee, Mościcki and Składkowski, with "the President did not accept it"); independence_day_1937 (the pre-1937 celebrations were military ceremonies in Warsaw); gordon_bennett_1938 (the table row with Liège, 11 September 1938, SP-BCU LOPP, 37:47, 1,692 km); zbaszyn_refugees_1938 (verbatim: about 17,000 arrested and expelled; the Polish Government quickly closed the border; the barracks); hungary_border_1939 (verbatim: Hungarian patrols reached the Werecka (Tucholska) Pass, the Polish delegation under Boruta-Spiechowicz, Horthy's telegram, the demonstration at the legation, the 180 km border); nanda_devi_east (the Polish Wikipedia page gives the summit of Bujak and Klarner on 2 July 1939 and the avalanche of 18 July that buried Bernadzikiewicz and Karpiński; the 5.20 p.m. of the Himalayan Journal and the 17:30 of the Polish page differ, so no time is stated); pyry_enigma (verbatim: Ciężki's lecture on the Polish struggle with the Enigma, Langer's answer, the two copies); westerplatte (verbatim: the broadside, Sucharski and Dąbrowski, Najsarek; the 04:45 is only the planned time, the guns fired at about 04:48, so no clock time is stated); chopin_competition_1937 (Hara acclaimed, reached the final, honourable mention; Meyer's award); berlin_olympics_team (the medal-table rows with the names); spitsbergen_crossing (a fourth fact: the expedition relied on its own resources). Dropped on the strength of the re-read: the 400 km/h of the Łoś (the page does not tie it to the first flight), the Chiczewski sentence (no verbatim line), the burial day of Szymanowski (only the arrival on 7 April is stated).

Still not a verbatim whole sentence (the fetch tool caps its quotes at about 125 characters and returns summaries): the scorer minutes of wilimowski_brazil_1938 (the match box as rendered; the page of Wilimowski states four goals), the March 1938 law and the passport stamp of zbaszyn_refugees_1938 (fragments), the "17 marca" demonstration sentence (the sentence says "the largest demonstration", the text says only "a demonstration"), and the batory_maiden_voyage dzieje.pl sentences (the end of the sentence is a fragment).

## Trigger verification

Round 1 (2026-11-05, `trigger-checker`, after the Manager session that built it; it ran `Test-HoiConditions.ps1` and the vanilla lookups on all 20 events, Poland's scope, `date` windows as in the events block): 17 OK, 2 FIX, 1 OPEN.

- **OK (17):** every date-gated peacetime event (kasprowy_cable_car, batory_maiden_voyage, berlin_olympics_team, spitsbergen_crossing, rambouillet_loan, pzl37_los_first_flight, gdynia_boom_1936, chopin_competition_1937, szymanowski_funeral, wawel_coffin_1937, independence_day_1937, destroyers_grom_blyskawica, wilimowski_brazil_1938, gordon_bennett_1938, zbaszyn_refugees_1938, nanda_devi_east: trigger `has_war = no`, each window opens after the last date of its text) and fon_1936 (its `OR` also holds for the whole war, so a fast declaration cannot make it miss).
- **FIX applied (2):**
  - westerplatte: `has_war_with = GER owns_state = 85` became `has_war_with = GER owns_state = 85 controls_state = 85`. Reason: `owns_state` stays true after Danzig is taken, so the event would ask for orders to a garrison that is gone. Cost: it is dropped when Danzig falls inside the war's first week.
  - hungary_border_1939: the trigger now also requires `owns_state = 89` (Stanisławów, with Kraków the Polish states that border state 73, so Polish troops can stand at the pass), `has_country_leader = { character = POL_ignacy_moscicki }` and `HUN = { ... has_country_leader = { character = HUN_miklos_horthy } }`, because the text names both men. Reason: the old trigger held whenever Hungary owned state 73, also when Poland had lost the border states or the leaders had changed.
- **Round 2:** see the paragraph after this list.
- **OPEN (1), settled by the owner's decision (2026-11-05):** pyry_enigma. The owner accepted the checker's proposed trigger below, with the window start moved from 1939.4.1 to 1939.1.1 (the AI never takes the focus earlier, so an earlier start only matters for a player Germany). The weekly chance stays 100 for it and for fon_1936: in a game started in 1939 the wargoal exists from day one, and a lower chance could miss that short window. The current gate (`has_war = no`, Germany holds a wargoal against Poland) holds only from the wargoal (created one day after Poland refuses the Danzig demand, `events/Germany.txt:8740`, `8894`) until Germany declares war, and no file says how long that is; in a game started in 1939 the wargoal exists from day one. The checker's proposal, which keeps the wargoal branch and adds the vanilla focus state (`common/ai_strategy/GER.txt:704-711`, the focus is 70 days, `common/national_focus/germany.txt:11850`) and guards for the text's assumptions (France and Britain not on Germany's side, France not capitulated, Warsaw Polish):
  `has_war = no OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } } FRA = { exists = yes has_capitulated = no NOT = { is_in_faction_with = GER } } ENG = { exists = yes NOT = { is_in_faction_with = GER } } owns_state = 10`
  The checker also asks the owner about the window start: with the focus branch, a player Germany that runs the whole crisis before 1939.4.1 skips the event.
- **fon_1936, improvement accepted by the owner (2026-11-05) and applied:** add the same focus branch and `has_capitulated = no`: `OR = { GER = { focus_progress = { focus = GER_danzig_or_war progress > 0.01 } } GER = { has_wargoal_against = POL } has_war_with = GER } has_capitulated = no`. It moves the event to the start of the 70-day crisis, where its present-tense donation text fits best. The focus alone would miss the 1939 start, the Slovakia path and wargoals the AI justifies itself, so the branches stay `OR`ed.
- **Unverified engine points (the checker's):** that dated history blocks do not apply during play (state 73 for a 1936 start); how `focus_progress` reads a completed or switched focus; when the first `on_weekly_POL` tick falls after a war starts. The probes of the Manager plan settle them (`Config/trigger-probes/poland-first-events.json`; the checker proposes three more: P9 focus in progress, P9 weekly, P11 France and Britain not on Germany's side); no probe has run yet. The owner chose to implement now and check in game afterwards (the test mod `ep_pol_all`, and the probes of the Manager plan if a doubt remains).

Round 2 (2026-11-05, `trigger-checker` on the two changed events): hungary_border_1939 OK (both character ids are right: `HUN_miklos_horthy` at `common/characters/HUN.txt:3`, `POL_ignacy_moscicki` at `common/characters/POL.txt:167`; `has_country_leader = { character = ... }` is the documented COUNTRY form, `documentation/triggers_documentation.md:3640`; state 89 is Stanisławów, the longest border of state 73). westerplatte FIX, applied in the form below: the war must be at most a month old, so the event cannot fire weeks into the war after Danzig is lost and retaken, or on 1 January 1939 for a war that began earlier: `has_war_with = GER owns_state = 85 controls_state = 85 NOT = { war_length_with = { tag = GER months > 1 } }`. The checker proposed `war_length_with = { tag = GER months < 1 }` (documented form `war_length_with = { tag = X months > Y }`, `documentation/triggers_documentation.md:7704`; vanilla writes only `>`); the planner used the `NOT` with `>` instead, and `Test-HoiConditions.ps1` reports it without a dead leaf at 1939.1.1. Unverified in game: how `months` is read (whole months or fractions), so the guard may hold longer than a month; the checker's probe `P-westerplatte-war-length` settles it. Residual, accepted by the planner as marginal (the checker's judgment): hungary_border_1939 can fire after the historical date if Hungary takes state 73 before 1939.3.17 or while Poland is at war, and "the border with Czecho-Slovakia" is loose if Hungary takes 73 from an owner other than Czechoslovakia.

Round 3 (2026-11-05, `trigger-checker` on pyry_enigma, fon_1936 and westerplatte in their final forms): 3 OK, 0 FIX, 0 OPEN. `Test-HoiConditions.ps1` ran at each window start and at 1939.8.14: no dead leaf, every trigger used is a documented COUNTRY trigger in a country scope (`focus_progress` `documentation/triggers_documentation.md:2882`, `has_capitulated` `:3352`, `controls_state` `:2329`, `war_length_with` `:7704`, `is_in_faction_with` `:5695`, `has_wargoal_against` `:5085`, `owns_state` `:7001`); the focus id and its 70 days are `common/national_focus/germany.txt:11840`, `:11850`, and vanilla writes the same `focus_progress` form at `common/ai_strategy/GER.txt:704-707`. The AI does not take the focus before 1939.1.1 (`germany.txt:11914`), which is why pyry_enigma opens then.

Accepted-unverified by the owner's decision (no probe before implementation; the owner checks in game afterwards, test mod `ep_pol_all` and the probes of the Manager plan if a doubt remains): the first weekly `on_weekly_POL` tick against an immediate German declaration in a game started in 1939 (pyry_enigma); how `focus_progress` reads a completed or switched focus (pyry_enigma, fon_1936; the wargoal branch covers the time after, and neither event can miss because of it); how `months` is read in `war_length_with` (westerplatte); that dated history blocks such as the 1939.1.1 block of Germany do not apply in a 1936 game (if they did, pyry_enigma and fon_1936 would fire in the first week of 1939, which their texts allow). Residual and marginal, from the checker: Britain has no capitulation guard in pyry_enigma; a France hostile to Poland outside Germany's faction is not excluded; a much later war in 1944-47 under another Polish government could still show fon_1936.

## Editor record

Round 1 (2026-11-05, `ep-editor`): 1 KEEP (szymanowski_funeral), 18 REWRITE, 1 REJECT (liberia_mission). Every REWRITE was applied as given, except where the quote-repair round gave a quote that lets a cut claim return (berlin_olympics_team medallists, chopin_competition_1937 Hara, gordon_bennett_1938 Liège and the balloon, independence_day_1937 military ceremonies, wawel_coffin_1937 "did not accept", hungary_border_1939 pass, nanda_devi_east summit, wilimowski_brazil_1938 date); the claims the repair round could not support stayed cut (the speed of the Łoś, Chiczewski, the Westerplatte clock time and the 182-240 garrison count). The editor's note on Westerplatte was taken: the trigger then also required `DNZ = { exists = yes }` (later replaced by the ownership of state 85, see Context and "Trigger verification"). liberia_mission was replaced by batory_maiden_voyage. The anchors lost by the rewrites were removed from the `anchors` arrays.

Round 2 (`ep-editor`, 20 events): 10 KEEP, 9 REWRITE, 1 REJECT (fon_1936: a quote repair, not a replacement, since two donor quotes named no giver). All rewrites were applied as given; the fon_1936 quotes were repaired with the whole page sentences naming Kusociński and Kurkowska-Spychajowa. The windows the editor flagged were moved: gdynia_boom_1936 opens 1937.1.1, szymanowski_funeral 1937.4.10, wawel_coffin_1937 1937.7.1, westerplatte 1939.1.1.

Round 3 (`ep-editor`, the 10 events changed since round 2): 8 KEEP (batory_maiden_voyage, berlin_olympics_team, spitsbergen_crossing, destroyers_grom_blyskawica, wilimowski_brazil_1938, zbaszyn_refugees_1938, hungary_border_1939, westerplatte), 2 REWRITE (wawel_coffin_1937: the order is dated by the quote's word order, and the crypt is no longer placed at Wawel; fon_1936: the diplomas sentence dropped, because the page dates them to the late 1930s, and "The Ministry of National Defence manages it" added). Both rewrites were applied as the editor wrote them and, to make the gifts of Kusociński and Kurkowska-Spychajowa safe on every day of the window, fon_1936 opens on 1938.1.1 instead of 1936.4.10 (the editor's suggestion). The two rewritten events were not sent back for a fourth round, since three rounds is the limit and the editor wrote both texts. Final tally over the 20 events: every event KEEP in its latest round or rewritten by the editor in round 3 and applied verbatim.

## Kept on judgment

No `[WARN]` was printed by `build.ps1 -Check -Pack poland` (`Check OK: 1 pack(s), 0 warning(s).`) or by `-RenderEvents -Pack poland` in the rehearsal, so the implementer stops on any warning. Judgment calls that are not warnings:
- Owner's decision (2026-11-05), for the audit of this pack: independence_day_1937 uses the vanilla picture `GFX_report_event_soldiers_parade`, whose troops wear German-looking helmets, which fits a Polish state holiday badly. It was found while verifying the implementation; the owner left it as it is and will have it fixed (a Commons picture of a Warsaw parade of 11 November, or another vanilla picture) when the pack is audited.
- For the pack's audit (reviewer findings of 2026-11-05, left for it by the owner): the Zbąszyń picture `GFX_report_event_german_polish_border` shows soldiers moving a frontier post, not refugees or a closed border; the Commons licence provenance of two pictures is thin (the Enigma replica photograph: PD-Polish added by its 2006 uploader without a source; the Szymanowski coffin photograph: CC0 on a 1937 studio photograph credited to Photo Gerber), and the licence gate accepted both as Commons tags them.
- Three events use vanilla pictures (independence_day_1937, zbaszyn_refugees_1938, hungary_border_1939): the picture researcher found no Commons file under an acceptable licence (only CC BY-SA files and modern photographs). The Zbąszyń picture shows border soldiers at a Polish border post, a neutral picture for a sensitive subject.
- westerplatte fires on `has_war_with = GER` while Poland owns and controls Danzig (`owns_state = 85 controls_state = 85`), within a month of the war's start (`NOT = { war_length_with = { tag = GER months > 1 } }`), from 1939.1.1 to 1947.12.31. It cannot tell a war that Germany starts from one that Poland starts, and it is dropped when Danzig falls inside the war's first week. The month guard is unverified in game (how `months` is read); the Manager plan's war-start record would replace it.
- fon_1936 fires while Germany works on the Danzig-or-war focus (`focus_progress` above 0.01), holds a wargoal against Poland, or Poland is at war with Germany, and Poland has not capitulated. pyry_enigma fires only while Poland is at peace and Germany works on that focus or holds the wargoal, with France and Britain not on Germany's side, France not capitulated and Warsaw Polish, from 1939.1.1 to 1947.12.31; the focus is 70 days and vanilla's own AI tests the same state (`common/ai_strategy/GER.txt:704-711`). Unverified in game: how `focus_progress` reads a completed or switched focus (the wargoal branch covers the time after). In a game where Germany never takes the focus or gets a wargoal, neither fires. hungary_border_1939 fires only when Hungary owns state 73 (Carpathian Ruthenia, a Czechoslovak state at the start; the transfer comes from a German focus with no fixed date, normally March 1939), Poland owns state 89, Poland is not at war with Hungary, and Mościcki and Horthy lead their countries (the text names both).
- Some fact lines carry fragments of the page line, not whole sentences (the fetch tool caps quotes at about 125 characters): see "Fact verification". The pack's `-Check` accepts them; a later `-Audit` should recheck these facts on their pages: the scorer minutes of wilimowski_brazil_1938, the passport stamp and the citizenship law of zbaszyn_refugees_1938, the dzieje.pl sentences of batory_maiden_voyage.
- The thumbnail is the Chopin competition photograph (chopin_competition_1937), crop center: the pianist sits in the upper middle, the title plate and the flag cover nothing of him (preview checked in the rehearsal).

## Implementation steps

- [x] 1. Write the events: replace `source/poland/events.json` with the `json events` block below, whole.
- [x] 2. Write the fact sheets: add each section of the `markdown fact-sheets` block below to `source/poland/fact-sheets.md`, replacing a section of the same key.
- [x] 3. Fetch the pictures, one command per row of the picture table, each expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Henryk Poddębski - Sport narciarski (131-G-34-12).jpg" -Key kasprowy_cable_car -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Gdynia - P. J. M. 1938 (87071907).jpg" -Key gdynia_boom_1936 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Polska wyprawa naukowa na Spitsbergen (1-N-980-3).jpg" -Key spitsbergen_crossing -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:PIC 1-M-878-213 Berlin 1936 women 100 m Helen Stephens Stella Walasiewicz.JPG" -Key berlin_olympics_team -Crop 30 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Smigly-Rydz and Gamelin.jpg" -Key rambouillet_loan -Crop 40 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:PZL.37 lot.jpg" -Key pzl37_los_first_flight -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Jakow Zak1937.jpg" -Key chopin_competition_1937 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Taüt amb el cos de Karol Szymanowski.jpg" -Key szymanowski_funeral -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Adam Stefan Sapieha 1.jpg" -Key wawel_coffin_1937 -Crop 20 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:ORP Blyskawica dok.jpg" -Key destroyers_grom_blyskawica -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Gdynia, MS Batory w porcie ante 1939 (67264496).jpg" -Key batory_maiden_voyage -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Brazil v Poland WC 1938 (3).jpg" -Key wilimowski_brazil_1938 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Start balonów.jpg" -Key gordon_bennett_1938 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Polish Himalayan Expedition (1939)18.jpg" -Key nanda_devi_east -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Kosztowności od podoficerów 4 dak ofiarowane na FON NAC 1-W-3037-1.jpg" -Key fon_1936 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Polish copy of Enigma made by Biuro Szyfrow.jpg" -Key pyry_enigma -Crop 50 -Tone none`
  - `powershell -File .\build.ps1 -FetchPicture -Pack poland -File "File:Westerplatte brama.jpg" -Key westerplatte -Crop 40 -Tone warm`
- [x] 4. Make the thumbnail from the picture fetched in step 3:
  - In `assets/thumbnail.json`, set `packs.poland.background` to `{ "path": "sources-cache/poland/chopin_competition_1937.*", "crop": "center" }`, adding the pack's entry under `packs` when it has none.
  - `powershell -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack poland`: expect the pack's line with `new` or `changed` and no `Warning:` line; open the preview it names with the Read tool.
  - `powershell -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack poland -Apply`: expect the pack's line with `new` or `changed`.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack poland`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack poland`: expect `Generated pack 'poland'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack poland`: expect `Check OK`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack poland`: expect `Rendered 20 events to ...artifacts\workshop-images\poland`, with no `[WARN]` outside "Kept on judgment".
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 10. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(poland): the first 20 events`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

Date: 2026-11-05. Second run after the trigger corrections (steps 1 and 6 to 9). `-Generate -Pack poland`: `Generated pack 'poland': 20 event(s), 3 file(s) written, 0 removed.` `-Check -Pack poland`: `Check OK: 1 pack(s), 0 warning(s).` (20 events, 17 pictures, 0 errors). `-RenderEvents` rendered 20 events with no `[WARN]`. `-ValidateOnly` ended `Validation succeeded.` (the three PD-US warnings are France pictures (mermoz_disappearance, pcf_dissolution_1939, richelieu_launch_1939), not poland). `-Test`: 264 passed, 0 failed. Thumbnail preview checked in the first run (Chopin photograph, pianist visible above the title plate). No deviations from the plan. Step 10 (ship) left for the caller.

## Fact sheets

```markdown fact-sheets
## kasprowy_cable_car

- The cable car from Kuźnice to Kasprowy Wierch opened on 15 March 1936. Source: https://radiokrakow.pl/aktualnosci/nowy-sacz/podhale/85-lat-temu-uruchomiono-kolej-linowa-z-kuznic-na-kasprowy-wierch (85 lat temu uruchomiono kolej linową z Kuźnic na Kasprowy Wierch). Quote: «85 lat temu, 15 marca 1936 roku, w Tatrach uruchomiono kolej linową z Kuźnic na Kasprowy Wierch.»
- Work began on 1 August 1935 and lasted over seven months. Source: https://radiokrakow.pl/aktualnosci/nowy-sacz/podhale/85-lat-temu-uruchomiono-kolej-linowa-z-kuznic-na-kasprowy-wierch (85 lat temu uruchomiono kolej linową z Kuźnic na Kasprowy Wierch). Quote: «Prace rozpoczęły się 1 sierpnia 1935 roku i trwały ponad 7 miesięcy.»
- The line is nearly 4300 metres long. Source: https://radiokrakow.pl/aktualnosci/nowy-sacz/podhale/85-lat-temu-uruchomiono-kolej-linowa-z-kuznic-na-kasprowy-wierch (85 lat temu uruchomiono kolej linową z Kuźnic na Kasprowy Wierch). Quote: «Ma długość niemal 4300 metrów.»
- It was the first investment of its kind in Poland and the 60th in the world. Source: https://radiokrakow.pl/aktualnosci/nowy-sacz/podhale/85-lat-temu-uruchomiono-kolej-linowa-z-kuznic-na-kasprowy-wierch (85 lat temu uruchomiono kolej linową z Kuźnic na Kasprowy Wierch). Quote: «Była to pierwsza inwestycja tego typu w Polsce, a 60. na świecie.»
- It was built on the initiative of the president of the Polish Ski Association. Source: https://radiokrakow.pl/aktualnosci/nowy-sacz/podhale/85-lat-temu-uruchomiono-kolej-linowa-z-kuznic-na-kasprowy-wierch (85 lat temu uruchomiono kolej linową z Kuźnic na Kasprowy Wierch). Quote: «Kolej na Kasprowy Wierch została wybudowana z inicjatywy prezesa Polskiego Związku Narciarskiego.»

## batory_maiden_voyage

- The liner Batory left the Gdynia maritime station on 18 May 1936 with 600 passengers aboard. Source: https://dzieje.pl/node/103962 (MS Batory na pocztówce (dzieje.pl)). Quote: «18 maja 1936 r. "Batory", z 600 pasażerami na pokładzie, wyruszył sprzed Dworca Morskiego w Gdyni»
- The maiden voyage began on 18 May 1936. Source: https://en.wikipedia.org/wiki/MS_Batory (MS Batory). Quote: «Maiden voyage: 18 May 1936» (infobox row)
- She began regular service on the Gdynia to New York run in May 1936. Source: https://en.wikipedia.org/wiki/MS_Batory (MS Batory). Quote: «She began regular service in May 1936 on the Gdynia — New York run»
- She was launched on 3 July 1935. Source: https://en.wikipedia.org/wiki/MS_Batory (MS Batory). Quote: «She was launched on 3 July 1935.»
- Her tonnage is 14,287 GRT and her owner is the Gdynia-America Line. Source: https://en.wikipedia.org/wiki/MS_Batory (MS Batory). Quote: «Tonnage: 14,287 GRT»; «Owner: Gdynia-America Line (1936–45)» (infobox rows)
- She is the sister ship of MS Piłsudski. Source: https://en.wikipedia.org/wiki/MS_Batory (MS Batory). Quote: «She was the sister ship of MS Piłsudski.»
- Between 1936 and the summer of 1939 her route was Gdynia, Copenhagen, New York, Halifax (not used in the text). Source: https://dzieje.pl/node/103962 (MS Batory na pocztówce (dzieje.pl)). Quote: «Do lata 1939 r. statek na trasie Gdynia - Kopenhaga - Nowy Jork - Halifax odbył 38 rejsów.»

## berlin_olympics_team

- Poland sent 144 competitors, 127 men and 17 women, to 55 events in 15 sports. Source: https://en.wikipedia.org/wiki/Poland_at_the_1936_Summer_Olympics (Poland at the 1936 Summer Olympics). Quote: «144 competitors, 127 men and 17 women took part in 55 events in 15 sports»
- The Games ran from 1 to 16 August 1936 (the page is about the 1936 Summer Olympics, held in Berlin). Source: https://en.wikipedia.org/wiki/Poland_at_the_1936_Summer_Olympics (Poland at the 1936 Summer Olympics). Quote: «1 August 1936 (1936-08-01) – 16 August 1936 (1936-08-16)»
- Poland won no gold medal, three silver and three bronze, and ranked 22nd. Source: https://en.wikipedia.org/wiki/Poland_at_the_1936_Summer_Olympics (Poland at the 1936 Summer Olympics). Quote: «Gold 0, Silver 3, Bronze 3, Total 6»; «Ranked 22nd»
- Stanisława Walasiewicz won silver in the women's 100 metres and Jadwiga Wajs silver in the women's discus throw. Source: https://en.wikipedia.org/wiki/Poland_at_the_1936_Summer_Olympics (Poland at the 1936 Summer Olympics). Quote: «Silver | Stanisława Walasiewicz | Athletics | Women's 100 metres»; «Silver | Jadwiga Wajs | Athletics | Women's discus throw» (medallist table rows)

## spitsbergen_crossing

- In 1936 Stanisław Siedlecki, Stefan Bernadzikiewicz and Konstanty Narkiewicz-Jodko made the first traverse of Spitsbergen, from 7 July to 1 September. Source: https://theexplorersclubpolska.pl/en/explorers-list/stanislaw-siedlecki-1912-2002-2.html (Polski Oddział The Explorers Club - STANISŁAW SIEDLECKI (1912-2002)). Quote: «In 1936, Stanisław Siedlecki, Stefan Bernadzikiewicz and Konstanty Narkiewicz-Jodko made the first traverse»; «of Spitsbergen from 7 July to 1 September.»
- They crossed about 850 km. Source: https://theexplorersclubpolska.pl/en/explorers-list/stanislaw-siedlecki-1912-2002-2.html (Polski Oddział The Explorers Club - STANISŁAW SIEDLECKI (1912-2002)). Quote: «They had crossed about 850 km.»
- The expedition was relying on its own resources, without any communication and support. Source: https://theexplorersclubpolska.pl/en/explorers-list/stanislaw-siedlecki-1912-2002-2.html (Polski Oddział The Explorers Club - STANISŁAW SIEDLECKI (1912-2002)). Quote: «The expedition was relying on its own resources, without any communication and support.»

## rambouillet_loan

- Delbos gave a lunch for Rydz-Śmigły at the Quai d'Orsay on 5 September 1936. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «le déjeuner qui lui fut offert par Delbos, au Quai d'Orsay, le 5 septembre 1936»
- The agreement is known as the Rambouillet agreement. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «Accord de Rambouillet» (chapter heading)
- France committed itself to a loan of two billion francs to Poland for its armament. Source: https://books.openedition.org/psorbonne/53213 (Chapitre XI. Rydz-Smigly en France. Accord de Rambouillet. Profits qu'en tire Beck, La Pologne entre deux mondes). Quote: «l'accord portant engagement par la France d'un prêt de deux milliards de francs à la Pologne pour son armement»

## pzl37_los_first_flight

- The prototype first flew on 13 December 1936. Source: https://dlapilota.pl/wiadomosci/polska/rocznica-oblotu-legendarnego-samolotu-pzl37-los (Rocznica oblotu legendarnego samolotu PZL.37 "Łoś"). Quote: «Oblot prototypu odbył się 13 grudnia 1936 roku.»
- The pilot, Jerzy Widawski, reported several shortcomings. Source: https://dlapilota.pl/wiadomosci/polska/rocznica-oblotu-legendarnego-samolotu-pzl37-los (Rocznica oblotu legendarnego samolotu PZL.37 "Łoś"). Quote: «Pilot Jerzy Widawski zgłosił wówczas szereg niedomagań.»
- The plans were prepared by engineer Jerzy Dąbrowski, assisted by Piotr Kubicki and Franciszek Misztal. Source: https://dlapilota.pl/wiadomosci/polska/rocznica-oblotu-legendarnego-samolotu-pzl37-los (Rocznica oblotu legendarnego samolotu PZL.37 "Łoś"). Quote: «Plany konstrukcyjne nowego samolotu przygotowali inż. Jerzy Dąbrowski, wspierany przez inż. Piotra Kubickiego i Franciszka Misztala.»
- The order was for a modern, fast bomber to replace the outdated Fokker F.VII machines. Source: https://dlapilota.pl/wiadomosci/polska/rocznica-oblotu-legendarnego-samolotu-pzl37-los (Rocznica oblotu legendarnego samolotu PZL.37 "Łoś"). Quote: «zamówienie na nowoczesny, szybki bombowiec, który miał zastąpić przestarzałe maszyny Fokker F.VII»

## gdynia_boom_1936

- Gdynia had 83,000 inhabitants in May 1936, 102,000 in December 1936 and 127,000 in 1939. Source: https://pl.wikipedia.org/wiki/Historia_Gdyni (Historia Gdyni). Quote: «W maju 1936 roku miasto liczyło 83 tys. mieszkańców, w grudniu tego samego roku 102 tys., zaś w 1939 roku już 127 tys.»
- The growth was caused by workers arriving from almost the whole country. Source: https://pl.wikipedia.org/wiki/Historia_Gdyni (Historia Gdyni). Quote: «Gwałtowny wzrost liczby mieszkańców spowodowany był napływem rąk do pracy z całego prawie kraju»
- In the 1930s about 30 percent of the people lived in some 2,500 primitive huts and shacks. Source: https://pl.wikipedia.org/wiki/Historia_Gdyni (Historia Gdyni). Quote: «Pomimo rozwoju, w latach 30. około 30% ludności mieszkało w ok. 2,5 tys. prymitywnych bud i baraków»

## chopin_competition_1937

- The third Chopin Competition was held in Warsaw from 21 February to 13 March 1937. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «was held from 21 February to 13 March 1937 in Warsaw»
- Eighty pianists from 22 countries took part. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «80 pianists from 22 countries took part in the competition.»
- The Soviet pianist Yakov Zak was awarded the first prize. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «Soviet pianist Yakov Zak was awarded the first prize.»
- Adam Wieniawski was the chairman of the jury. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «Adam Wieniawski (chairman)»
- The Japanese pianists Miwa Kai and Chieko Hara received great acclaim among critics and the public. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «The two female Japanese pianists Miwa Kai and Chieko Hara received great acclaim among critics and the public.»
- Hara reached the final but was awarded only an honourable mention, and a commotion broke out. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «When news broke that Hara, who reached the final, was not among the prize-winners»; «and was merely awarded an honorable mention, a commotion broke out.»
- Fearing that the crowd would damage the Philharmonic, the industrialist Stanisław Meyer sponsored a special audience award for Hara. Source: https://en.wikipedia.org/wiki/III_International_Chopin_Piano_Competition (III International Chopin Piano Competition). Quote: «Fearing that the frenzied crowd would cause damage to the Philharmonic, industrialist Stanisław Meyer sponsored a special»; «"audience award" for Hara.»

## szymanowski_funeral

- Szymanowski died on 29 March 1937 in a sanatorium at Lausanne. Source: https://www.radiokrakow.pl/aktualnosci/kultura/80-lat-temu-w-lozannie-zmarl-karol-szymanowski (80 lat temu w Lozannie zmarł Karol Szymanowski, Radio Kraków). Quote: «Szymanowski zmarł 29 marca 1937 r. w sanatorium w Lozannie.»
- He is buried in the Crypt of the Distinguished at Skałka in Kraków. Source: https://www.radiokrakow.pl/aktualnosci/kultura/80-lat-temu-w-lozannie-zmarl-karol-szymanowski (80 lat temu w Lozannie zmarł Karol Szymanowski, Radio Kraków). Quote: «Jest pochowany w Krypcie Zasłużonych na Skałce w Krakowie.»
- The train carrying his body stopped for commemorative ceremonies in Berlin, at the German-Polish border and in Poznań. Source: https://onpolishmusic.com/2012/04/06/%e2%80%a2-szymanowskis-funerals/ (Szymanowski's Funerals, On Polish Music). Quote: «The train stopped for commemorative ceremonies in Berlin, at the German-Polish border, and in Poznań in central Poland.»
- The Warsaw funeral took place on the morning of Tuesday 6 April in the Church of the Holy Cross. Source: https://onpolishmusic.com/2012/04/06/%e2%80%a2-szymanowskis-funerals/ (Szymanowski's Funerals, On Polish Music). Quote: «The Warsaw funeral took place on the morning of Tuesday, 6 April, in the Church of the Holy Cross»
- The coffin arrived in Kraków early on Wednesday 7 April and was carried past Wawel to the church on Skałka. Source: https://onpolishmusic.com/2012/04/06/%e2%80%a2-szymanowskis-funerals/ (Szymanowski's Funerals, On Polish Music). Quote: «Szymanowski's coffin arrived in Kraków early on Wednesday, 7 April»; «south-west past Wawel castle and on to St Stanisław church on Skałka»

## wawel_coffin_1937

- Archbishop Adam Sapieha ordered, against the state authorities, that the coffin be moved to the prepared crypt on 22 June 1937. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Abp Sapieha wydał wtedy, wbrew władzom państwowym, polecenie, aby przenieść trumnę do przygotowanej krypty 22 czerwca 1937 r.»
- The coffin of Marshal Piłsudski was to be moved to the crypt under the Silver Bells Tower. Source: https://pl.wikipedia.org/wiki/1937 (1937). Quote: «przeniesieniu trumny marszałka Piłsudskiego do krypty pod Wieżą Srebrnych Dzwonów»
- The Marshal's memorial committee and President Ignacy Mościcki opposed the archbishop's decision. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Tak samo postąpił Naczelny Komitet Uczczenia Pamięci Marszałka Józefa Piłsudskiego oraz prezydent Ignacy Mościcki.» (the sentence before it: the committee's executive chairman «wystąpił przeciw decyzji arcybiskupa»)
- Because of the conflict Prime Minister Składkowski demonstratively handed in the resignation of his government, and the President did not accept it. Source: https://pl.wikipedia.org/wiki/Konflikt_wawelski (Konflikt wawelski). Quote: «Ze względu na trwający konflikt wawelski Felicjan Sławoj Składkowski demonstracyjnie złożył dymisję swojego rządu, która nie została jednak przyjęta przez Prezydenta RP Ignacego Mościckiego.»

## independence_day_1937

- The Independence Day was given the rank of a state holiday by a law of 23 April 1937. Source: https://pl.wikipedia.org/wiki/Narodowe_Święto_Niepodległości (Narodowe Święto Niepodległości). Quote: «Rangę święta państwowego nadano Świętu Niepodległości dopiero ustawą z dnia 23 kwietnia 1937 r.»
- The holiday was meant to link the regaining of state sovereignty with the end of the First World War and to commemorate Józef Piłsudski. Source: https://pl.wikipedia.org/wiki/Narodowe_Święto_Niepodległości (Narodowe Święto Niepodległości). Quote: «Miało ono łączyć odzyskanie suwerenności państwowej z zakończeniem I wojny światowej oraz upamiętniać Józefa Piłsudskiego.»
- From 1919 to 1936 the anniversaries were celebrated in Warsaw as military ceremonies, usually on the first Sunday after 11 November. Source: https://pl.wikipedia.org/wiki/Narodowe_Święto_Niepodległości (Narodowe Święto Niepodległości). Quote: «W latach 1919–1936 rocznice odzyskania niepodległości świętowano w Warszawie jako uroczystości o charakterze wojskowym.»; «Organizowano je zazwyczaj w pierwszą niedzielę po 11 listopada.»
- In 1937 the celebration included the unveiling of a monument to General Józef Sowiński. Source: https://pl.wikipedia.org/wiki/Narodowe_Święto_Niepodległości (Narodowe Święto Niepodległości). Quote: «w 1937 r. uświetniono je odsłonięciem pomnika gen. Józefa Sowińskiego.»

## destroyers_grom_blyskawica

- ORP Błyskawica entered service in the Polish Navy on 25 November 1937. Source: https://dzieje.pl/node/144060 (85 lat temu do służby w Marynarce Wojennej wszedł ORP „Błyskawica"). Quote: «25 listopada 1937 r. ORP "Błyskawica" rozpoczął służbę w Marynarce Wojennej.»
- The firm J. Samuel White & Co Ltd in Cowes on the Isle of Wight is named in the account of Błyskawica (not used in the text). Source: https://dzieje.pl/node/144060 (85 lat temu do służby w Marynarce Wojennej wszedł ORP „Błyskawica"). Quote: «firmę J. Samuel White & Co Ltd w Cowes na wyspie Wight»
- Her first commander was Commander Tadeusz Podjazd-Morgenstern. Source: https://dzieje.pl/node/144060 (85 lat temu do służby w Marynarce Wojennej wszedł ORP „Błyskawica"). Quote: «Pierwszym dowódcą jednostki był kmdr por. Tadeusz Podjazd-Morgenstern.»
- Her maximum speed was 39.6 knots. Source: https://dzieje.pl/node/144060 (85 lat temu do służby w Marynarce Wojennej wszedł ORP „Błyskawica"). Quote: «Maksymalna prędkość niszczyciela wynosiła 39,6 węzłów (ok. 73 km/h).»
- Błyskawica's main gun armament was seven 120 mm guns. Source: https://en.wikipedia.org/wiki/ORP_B%C5%82yskawica (ORP Błyskawica). Quote: «Main gun armament consisted of seven 120 mm (4.7 in) guns.»
- Grom was ordered from the British shipyard of J. Samuel White at Cowes and was commissioned in 1937. Source: https://en.wikipedia.org/wiki/ORP_Grom_(1936) (ORP Grom (1936)). Quote: «ordered from the British J. Samuel White shipyard in Cowes»; «The destroyer was commissioned in 1937.»
- The Grom class was designed to fulfil both the role of shore defence and convoy escort. Source: https://en.wikipedia.org/wiki/ORP_Grom_(1936) (ORP Grom (1936)). Quote: «the Grom class was designed to fulfill both the role of shore defence and convoy escort»

## wilimowski_brazil_1938

- Brazil beat Poland 6-5 at the Stade de la Meinau in Strasbourg. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Stade de la Meinau, Strasbourg.»; «Brazil 6–5 Poland»
- The match was played on 5 June 1938. Source: https://en.wikipedia.org/wiki/Ernest_Wilimowski (Ernest Wilimowski). Quote: «June 5, 1938» (results table, with «Stade de la Meinau»)
- Wilimowski scored in the 53rd, 59th, 89th and 118th minutes. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Wilimowski 53', 59', 89', 118'» (scorers cell of the match box, as rendered)
- Wilimowski became the first player ever to score four goals in a single World Cup match. Source: https://en.wikipedia.org/wiki/Ernest_Wilimowski (Ernest Wilimowski). Quote: «put on a stunning display by becoming the first player ever to score four goals in a single World Cup match.»
- It was the first ever World Cup match of Poland. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Poland's first ever FIFA World Cup match.»
- The attendance was 13,452. Source: https://en.wikipedia.org/wiki/Poland_v_Brazil_(1938) (Brazil v Poland (1938 FIFA World Cup)). Quote: «Attendance: 13,452.»

## gordon_bennett_1938

- The race of 11 September 1938 started at Liège; Antoni Janusz and Franciszek Janik flew the balloon SP-BCU LOPP for 37 hours and 47 minutes over 1,692 km. Source: https://en.wikipedia.org/wiki/Antoni_Janusz (Antoni Janusz). Quote: «11 September 1938 | Liège (Belgium) | 1 | Antoni Janusz, Franciszek Janik | SP-BCU LOPP | 37:47 | 1,692.00» (row of the table of his Gordon Bennett races)
- Janusz was an officer in the Polish Air Force. Source: https://en.wikipedia.org/wiki/Antoni_Janusz (Antoni Janusz). Quote: «Janusz was an officer in the Polish Air Force (1919–1947)»
- The Gordon Bennett Cup was held in Warsaw in 1934, 1935 and 1936. Source: https://muzeumlotnictwa.pl/en/exhibitions/polish-achievements-gordon-bennett-cup/ (Polish Achievements in the Gordon Bennett Cup). Quote: «in 1934, 1935, and 1936 the Gordon Bennett Cup was held in Warsaw»
- In 1938 the cup was won by Franciszek Janik and Antoni Janusz. Source: https://muzeumlotnictwa.pl/en/exhibitions/polish-achievements-gordon-bennett-cup/ (Polish Achievements in the Gordon Bennett Cup). Quote: «In 1938 — Franciszek Janik and Antoni Janusz»

## zbaszyn_refugees_1938

- About 17,000 Polish Jews living in Germany were arrested and expelled in October 1938. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «In October 1938, about 17,000 Jewish Poles living in Nazi Germany were arrested and expelled.»
- The arrests ran in the days from 27 to 29 October (not used in the text). Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «From October 27 until October 29»
- Polish citizenship could be revoked of people who had lived abroad for more than five years. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «enabling the revocation of Polish citizenship if the person had been living abroad for more than five years»
- Polish citizens living outside Poland had to obtain an endorsement stamp on their passports before 30 October. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «Polish citizens living outside Poland obtain an endorsement stamp on their passports before October 30»
- The Polish Government quickly closed the border. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «However, the Polish Government quickly responded by closing the border down and denying any further access.»
- 8,000 of the expelled were sent to the town of Zbąszyń. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «8,000 were sent to the town of Zbąszyń.»
- For months the refugees at Zbąszyń slept in poorly constructed barracks with very few provisions. Source: https://en.wikipedia.org/wiki/1938_expulsion_of_Polish_Jews_from_Germany (1938 expulsion of Polish Jews from Germany). Quote: «For months, refugees in Zbąszyń slept in poorly constructed barracks with very few provisions.»

## hungary_border_1939

- Hungarian patrols reached the Werecka Pass, also called the Tucholska Pass, on what had been the border of Poland with Czecho-Slovakia. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Po południu 16 marca patrole węgierskie dotarły do Przełęczy Wereckiej, nazywanej również Tucholską, na nieistniejącej już granicy Polski z Czecho-Słowacją.»
- At the Tucholska Pass in the Carpathians Polish troops welcomed the Hungarians coming from the south. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «na Przełęczy Tucholskiej w Karpatach oddziały polskie powitały nadciągających z południa Węgrów.»
- On the Polish side, Polish troops and an official delegation led by General Mieczysław Boruta-Spiechowicz awaited the Hungarians. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Po polskiej stronie na Węgrów oczekiwały oddziały Wojska Polskiego i oficjalna delegacja z gen. Mieczysławem Borutą-Spiechowiczem na czele.»
- Regent Horthy telegraphed his greetings to President Mościcki at the historic moment when a Hungarian soldier shakes the right hand of a Polish soldier on the Polish-Hungarian border. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Regent Królestwa Węgier admirał Miklós Horthy wystosował depeszę do prezydenta Ignacego Mościckiego, w której stwierdził: „W historycznej chwili, gdy na granicy polsko-węgierskiej żołnierz węgierski ściska prawicę żołnierza polskiego, przesyłam Waszej Ekscelencji i Narodowi polskiemu jak najserdeczniejsze pozdrowienia tak w swoim, jak i Narodu węgierskiego imieniu”.»
- A demonstration was held outside the Hungarian legation in Koszykowa street. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «17 marca pod siedzibą poselstwa węgierskiego przy ul. Koszykowej doszło do największej manifestacji.»
- The new border was only 180 km long. Source: https://radiokrakow.pl/aktualnosci/80-lat-temu-16-marca-1939-r-polska-znow-zaczela-graniczyc-z-wegrami (80 lat temu, 16 marca 1939 r., Polska znów zaczęła graniczyć z Węgrami). Quote: «Nowa granica licząca zaledwie 180 km długości przetrwała do ostatnich dni września 1939 r.»

## nanda_devi_east

- The Polish Himalayan expedition was led by Adam Karpiński; its members were Jakub Bujak, Stefan Bernadzikiewicz, Janusz Klarner and Major J. R. Foy. Source: https://www.himalayanclub.org/hj/12/6/the-polish-ascent-of-nanda-devi-east-1939/ (The Polish Ascent of Nanda Devi East, 1939). Quote: «M. Adam Karpinski, leader, Dr. Jakub Bujak, M. Stefan Bernadzikiewicz, M. Janusz Klarner, and Major J. R. Foy.»
- On 2 July 1939 Jakub Bujak and Janusz Klarner reached the 7434 m summit of Nanda Devi East. Source: https://pl.wikipedia.org/wiki/Nanda_Devi_East (Nanda Devi East). Quote: «2 lipca 1939 r. o godzinie 17:30 dwójce z nich, Jakubowi Bujakowi i Januszowi Klarnerowi, udało się wejść na dziewiczy, liczący 7434 m n.p.m. szczyt Nanda Devi East»
- On 18 July an avalanche came down on Camp III and buried Bernadzikiewicz and Karpiński. Source: https://pl.wikipedia.org/wiki/Nanda_Devi_East (Nanda Devi East). Quote: «18 lipca 1939 r. na założony na wysokości 6150 m. przez Bernadzikiewicza i Karpińskiego III obóz zeszła lawina, która pogrzebała obu himalaistów.»
- An ice avalanche killed the leader and one member of the expedition. Source: https://www.himalayanclub.org/hj/12/6/the-polish-ascent-of-nanda-devi-east-1939/ (The Polish Ascent of Nanda Devi East, 1939). Quote: «The ice-avalanche which resulted in the death of the leader and one member of the Polish Himalayan Expedition of 1939»
- The party started early on 19 July and reached the edge of the hanging glacier by noon, and saw only a huge avalanche covering the site. Source: https://www.himalayanclub.org/hj/12/6/the-polish-ascent-of-nanda-devi-east-1939/ (The Polish Ascent of Nanda Devi East, 1939). Quote: «We started early on the 19th and reached the edge of the hanging glacier by noon.»; «From here we expected to see the tent, but we only saw a huge avalanche covering the site.»

## fon_1936

- The National Defence Fund was created by a decree of the President on 9 April 1936. Source: https://pl.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «Fundusz Obrony Narodowej (FON) – fundusz utworzony na mocy dekretu Prezydenta RP z 9 kwietnia 1936 roku»
- Its purpose was extra money for the rearmament of the army and a military investment programme. Source: https://pl.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «w celu uzyskania dodatkowych środków na dozbrojenie armii i wojskowy program inwestycyjny.»
- Schoolchildren gave their pocket money, and people gave jewellery, precious coins and gold earrings. Source: https://en.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «children in schools gave their pocket money»; «people gave their jewellery, precious coins, gold earrings»
- Among the individual donors of the Fund, Janusz Kusociński gave a gold signet ring of 9.5 grams. Source: https://pl.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «Ofiarodawcami indywidualnymi FON byli m.in.: Janusz Kusociński (przekazał złoty sygnet o wadze 9,5 grama),»
- Among the individual donors of the Fund, Janina Kurkowska-Spychajowa gave eight silver cups. Source: https://pl.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «i Janina Kurkowska-Spychajowa (przekazała 8 srebrnych pucharów).»
- The Ministry of National Defence managed the Fund; in the late 1930s it began to issue special diplomas to donors (the diplomas are not used in the text). Source: https://pl.wikipedia.org/wiki/Fundusz_Obrony_Narodowej (Fundusz Obrony Narodowej). Quote: «Zarządzające Fundusz Obrony Narodowej przedwojenne Ministerstwo Obrony Narodowej pod koniec lat 30.»; «przystąpiło do wydawania ofiarodawcom na FON specjalnych dyplomów,»

## pyry_enigma

- The Polish methods were revealed to French and British intelligence representatives in a meeting at Pyry, south of Warsaw. Source: https://en.wikipedia.org/wiki/Marian_Rejewski (Marian Rejewski). Quote: «The Polish methods were revealed to French and British intelligence representatives in a meeting at Pyry, south of Warsaw,»
- The French and British delegates arrived in Warsaw, and at seven in the morning they got into cars provided by the Polish staff. Source: https://dzieje.pl/podzielic-sie-tajemnica (Podzielić się tajemnicą). Quote: «przybywają do Warszawy 24 lipca»; «Już o 7 rano Francuzi i Brytyjczycy wsiedli do podstawionych przez polski sztab samochodów»
- Major Maksymilian Ciężki gave a three-hour lecture on the history of the Polish struggle with the Enigma. Source: https://dzieje.pl/podzielic-sie-tajemnica (Podzielić się tajemnicą). Quote: «Major Maksymilian Ciężki wygłosił trzy godzinny referat, w którym opisał historię polskich zmagań z Enigmą.»
- After the lecture the device was presented. Source: https://dzieje.pl/podzielic-sie-tajemnica (Podzielić się tajemnicą). Quote: «Po prelekcji Ciężkiego, nastąpiło clou programu – prezentacja urządzenia.»
- Asked where they got it, the head of the cipher bureau, Colonel Gwido Langer, answered that they made it themselves. Source: https://dzieje.pl/podzielic-sie-tajemnica (Podzielić się tajemnicą). Quote: «„Skąd to wzięliście?” – zapytał Bertrand. „Sami zrobiliśmy” – odrzekł kierownik biura szyfrów płk Gwido Langer.»
- Two copies were intended for the French and British visitors, one for Paris and one for London. Source: https://dzieje.pl/podzielic-sie-tajemnica (Podzielić się tajemnicą). Quote: «Bertrand pisze, że nie mogli uwierzyć własnym uszom, że „dwa egzemplarze są przeznaczone dla nas, jeden dla Paryża i jeden dla Londynu”.»

## westerplatte

- In the early morning Schleswig-Holstein fired a broadside at the Polish garrison. Source: https://en.wikipedia.org/wiki/Battle_of_Westerplatte (Battle of Westerplatte). Quote: «On the early morning of 1 September 1939, Schleswig-Holstein fired a broadside at the Polish garrison.»
- Major Henryk Sucharski commanded the garrison and Captain Franciszek Dąbrowski was his second-in-command. Source: https://en.wikipedia.org/wiki/Battle_of_Westerplatte (Battle of Westerplatte). Quote: «Controversy surrounds the Polish garrison's commanding officer, Sucharski.»; «Major Henryk Sucharski, his second-in-command Captain Franciszek Dąbrowski,»
- Staff Sergeant Wojciech Najsarek was killed by machine-gun fire. Source: https://en.wikipedia.org/wiki/Battle_of_Westerplatte (Battle of Westerplatte). Quote: «a Polish soldier, Staff Sergeant Wojciech Najsarek, was killed by machine-gun fire.»
- Older sources count 182 men in the garrison, recent research 210 to 240. Source: https://en.wikipedia.org/wiki/Battle_of_Westerplatte (Battle of Westerplatte). Quote: «older sources speak of 182 men but more recent research suggests something in the range of 210 to 240.»
```

## Events source

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
                    "name": "Let the mountaineering clubs celebrate their own.",
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
            "desc": "On 5 September Delbos gave a lunch for Rydz-Śmigły at the Quai d'Orsay.\n\nThe Rambouillet agreement commits France to a loan of two billion francs to Poland for its armament. Should the army spend it at once, or should we take care not to depend on Paris?",
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
                    "name": "Order the guns and aircraft the army lacks.",
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
            "desc": "The order was for a modern, fast bomber to replace the outdated Fokker F.VII machines. Engineer Jerzy Dąbrowski prepared the plans, assisted by Piotr Kubicki and Franciszek Misztal.\n\nThe prototype of the PZL.37 Łoś made its first flight on 13 December. The pilot, Jerzy Widawski, reported several shortcomings. Should the bomber go into production at once?",
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
                    "name": "Housing can wait. The quays cannot.",
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
                    "name": "Print his scores at the state's expense.",
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
            "desc": "Archbishop Adam Sapieha ordered, against the state authorities, that Marshal Piłsudski's coffin be moved to the prepared crypt under the Silver Bells Tower on 22 June.\n\nThe Marshal's memorial committee and President Mościcki opposed the archbishop's decision. Because of the Wawel conflict, Prime Minister Składkowski demonstratively handed in the resignation of his government. The President did not accept it.",
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
                "trigger": "has_war = no"
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
            "title": "11 November Is Celebrated as a State Holiday",
            "desc": "The law of 23 April gave Independence Day on 11 November the rank of a state holiday. It is meant to link the regaining of state sovereignty with the end of the First World War and to commemorate Józef Piłsudski.\n\nUntil this year the celebrations in Warsaw were military ceremonies, usually held on the first Sunday after 11 November. This year they included the unveiling of a monument to General Józef Sowiński.",
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
            "desc": "ORP Błyskawica entered service in the Polish Navy on 25 November. Her first commander is Tadeusz Podjazd-Morgenstern. She carries seven 120 mm guns and has a maximum speed of 39.6 knots.\n\nGrom was ordered from the British J. Samuel White shipyard in Cowes and was commissioned in 1937. The Grom class was designed both for shore defence and for convoy escort.",
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
            "desc": "On 5 June, at the Stade de la Meinau in Strasbourg, Brazil beat Poland 6-5. It was Poland's first ever World Cup match. The attendance was 13,452.\n\nWilimowski scored four times, in the 53rd, 59th, 89th and 118th minutes. No player before him has scored four goals in a single World Cup match.",
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
                "chance": 50,
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
                    "name": "Five goals and still beaten. The defence must improve.",
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
            "desc": "In October about 17,000 Polish Jews living in Germany were arrested and expelled. Polish citizenship can be revoked if the citizen has lived abroad for more than five years. Polish citizens living outside Poland had to obtain an endorsement stamp on their passports before 30 October.\n\nOf the expelled, 8,000 were sent to the town of Zbąszyń, where they sleep in poorly constructed barracks with very few provisions. The Polish Government quickly closed the border and denied any further access.",
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
                "trigger": "has_war = no"
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
            "desc": "Hungarian patrols have reached the Werecka Pass, also called the Tucholska Pass, on what was the border of Poland with Czecho-Slovakia. There, in the Carpathians, Polish troops welcomed the Hungarians coming from the south. An official delegation led by General Mieczysław Boruta-Spiechowicz awaited them.\n\nRegent Horthy telegraphed his greetings to President Mościcki 'at the historic moment when a Hungarian soldier shakes the right hand of a Polish soldier on the Polish-Hungarian border'. A demonstration was held outside the Hungarian legation in Koszykowa street. The new border is only 180 km long.",
            "picture": "vanilla:GFX_report_event_generic_handshake",
            "factSheet": "hungary_border_1939",
            "anchors": [
                "Werecka Pass",
                "Boruta-Spiechowicz",
                "Horthy",
                "Mościcki",
                "180 km",
                "Koszykowa"
            ],
            "fire": {
                "after": "1939.3.17",
                "before": "1947.12.31",
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
