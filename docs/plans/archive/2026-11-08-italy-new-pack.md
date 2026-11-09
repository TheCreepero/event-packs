# Italy pack: new pack, 20 events 1936-1940

Status: DONE
Pack: italy (ITA, namespace ep_ita)
Kind: new pack
Created: 2026-11-08

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/italy/events.json` (in an audit plan with `"mergeById": true`, only the events it changes), the `markdown fact-sheets` block holds the sections for `source/italy/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Step 1 writes both blocks with `build.ps1 -ApplyPlan`, never by hand. Decide nothing; stop and report when something does not fit.

## Context

New pack "Event Pack: Italy" (ITA, namespace ep_ita), written by the event-pack-create skill. `build.ps1 -NewPack` created `source/italy/`, `packs/italy/` and added `italy` to the members of the bundle `all`. There is no earlier Italy dossier and no earlier event; ids start at 1.

## Decisions

2026-11-08, from the owner's command: country Italy (tag ITA); period 1936 to 1940; 20 events. No kinds to stress or avoid and nothing to leave untouched were given: the default mix of peacetime flavor and war-state events applies, and the kinds are confirmed with the owner when the shortlist is shown (Phase 2). The owner's war rule holds: no war event is dated or gated on a date alone.

- The owner chose the recommended 20 of the 32 dossier candidates on 2026-11-08. One change came later: balbo_tobruk was replaced by taranto_night, because the pack's effects (`data/effect-caps.json`) have no `retire_character` (the event could not remove Balbo) and By Blood Alone already ships its own Balbo accident events. The owner is told in the hand-off.
- Peacetime gate for Italy: Italy starts at war with Ethiopia, so `has_war = no` would block every 1936 event. Peacetime events use 'at war with nobody but Ethiopia' (`NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }`). The owner confirmed it on 2026-11-08.
- albania_landing: the owner decided on 2026-11-08 to drop the condition on Durrës and gate on war with Albania with Italy attacking (`has_war_with = ALB has_offensive_war_with = ALB`); the text is in the past tense so it holds on every day of the war.
- albania_landing, second decision (2026-11-09): the trigger-checker found that in a normal AI game Albania probably yields to the ultimatum and is annexed without a war, so the war gate rarely holds. The owner chose to widen the trigger. A landing text is false after a peaceful yield, so the event was recast on the three facts that are true on every path (the parliament's vote, the crown offered to Victor Emmanuel III, Zog's exile): title 'Albania Offers Its Crown to the King', trigger `NOT = { country_exists = ALB } 44 = { is_owned_by = ROOT } has_character = ITA_vittorio_emanuele_iii` (Albania is gone, Italy owns its capital state and the King is still in office, whether Italy got it by war or by yield), chance 50, window 1939.1.1 to 1941.1.1. The key `albania_landing` and the picture `durres_1939` stay; the effects are unchanged. The text went through `ep-editor` (REWRITE applied as given: 42 words, one question for both options) and the trigger through `trigger-checker` (FIX applied: the King guard).
- Events 15 (key `albania_landing`) and 20 are named in the plan as the dossier candidate `albania_ultimatum` and `taranto_night`; the Albania event was recast as the landing because the ultimatum had no verbatim wording.

## Events

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 1 | aoi_empire_proclaimed | Empire Proclaimed from Palazzo Venezia | 1936.6.1 to 1939.1.1 | 15 | vanilla:GFX_report_event_generic_italian_celebration | war_support 0.03; political_power 20 |
| 2 | topolino_fiat_500 | Fiat Launches the Topolino | 1936.7.1 to 1936.8.15 | 20 | topolino_1936 | stability 0.02; political_power 20 |
| 3 | ciano_foreign_minister | Ciano Takes the Foreign Ministry | 1936.6.9 to 1936.9.1 | 20 | ciano_1936 | political_power 20; stability 0.02 |
| 4 | spain_sm81_airlift | Rome Orders Twelve SM.81 Bombers Sent | 1936.1.1 to 1939.4.1 | 12 | sm81_spain | political_power 25; air_experience 5 |
| 5 | olympic_football_gold | Italy Wins Olympic Football Gold | 1936.8.15 to 1936.10.1 | 25 | olympic_team_1936 | war_support 0.02; stability 0.02 |
| 6 | lira_devaluation_1936 | Lira Devalued by About 41 Per Cent | 1936.10.5 to 1936.12.15 | 20 | vanilla:GFX_report_event_generic_stock_traders | stability 0.02; political_power 20 |
| 7 | axis_protocol_october | Italy and Germany Conclude a Protocol | 1936.11.2 to 1937.3.1 | 20 | vanilla:GFX_report_event_german_italian_pact | stability 0.02; political_power 20 |
| 8 | guadalajara_ctv | Fog and Sleet Slow the Advance at Guadalajara | 1937.1.1 to 1939.4.1 | 12 | vanilla:GFX_report_event_spr_italian_volunteers | army_experience 5; stability 0.02 |
| 9 | pirandello_death | Luigi Pirandello Dies in Rome | 1936.12.10 to 1937.2.1 | 30 | pirandello_study | stability 0.02; political_power 15 |
| 10 | cinecitta_opens | Cinecittà Opens With Mussolini | 1937.4.28 to 1937.6.30 | 20 | cinecitta_1937 | stability 0.02; political_power 25 |
| 11 | easter_accords | Britain and Italy Conclude the Easter Accords | 1938.4.16 to 1938.11.30 | 15 | vanilla:GFX_report_event_generic_sign_treaty2 | stability 0.02; political_power 20 |
| 12 | hitler_visit_italy | Hitler Leaves Italy at the Brenner | 1938.5.9 to 1938.6.15 | 40 | naples_fleet_1938 | war_support 0.02; political_power 15 |
| 13 | world_cup_1938 | Italy Keeps the World Cup | 1938.6.19 to 1938.7.31 | 40 | italy_team_1938 | war_support 0.02; stability 0.02 |
| 14 | bartali_tour_1938 | Bartali Wins the Tour de France | 1938.7.31 to 1938.9.15 | 40 | bartali_1936 | stability 0.02; war_support 0.02 |
| 15 | albania_landing | Albania Offers Its Crown to the King | 1939.1.1 to 1941.1.1 | 50 | durres_1939 | war_support 0.03; army_experience 5 |
| 16 | mirafiori_opening | Mussolini Inaugurates Mirafiori | 1939.5.15 to 1939.7.1 | 40 | mirafiori_aerial | political_power 20; stability 0.02 |
| 17 | coffee_sugar_rationing | Coffee and Sugar Are Rationed | 1940.2.1 to 1940.5.31 | 15 | vanilla:GFX_report_event_generic_factory | stability 0.02; political_power 15 |
| 18 | giro_1940_coppi | Coppi Takes the Pink Jersey | 1940.5.29 to 1940.6.9 | 60 | coppi_bartali_1940 | war_support 0.02; stability 0.02 |
| 19 | british_somaliland_1940 | Aosta Urges Haste on British Somaliland | 1940.1.1 to 1945.1.1 | 15 | vanilla:GFX_report_event_african_soldiers | army_experience 5; political_power 15 |
| 20 | taranto_night | British Aircraft Strike the Fleet at Taranto | 1940.1.1 to 1945.1.1 | 8 | taranto_aftermath | political_power 15; navy_experience 5 |

## Pictures

Every row passed `build.ps1 -FetchPicture ... -DryRun` while planning; the licence column is what it printed.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|
| topolino_1936 | File:Fiat 500 Topolino-1936 Centro Storico Fiat.jpg | PD (Public domain) | 50 | warm | topolino_fiat_500 |
| olympic_team_1936 | File:Équipe d'Italie championne olympique de football, en 1936 à Berlin.jpg | PD (Public domain) | 50 | warm | olympic_football_gold |
| ciano_1936 | File:Galeazzo Ciano 1936.jpg | PD (Public domain) | 25 | warm | ciano_foreign_minister |
| sm81_spain | File:Savoia Marchetti S.81 in Spagna.jpg | PD (Public domain) | 50 | warm | spain_sm81_airlift |
| pirandello_study | File:Luigi Pirandello 1934 - office.jpg | PD (Public domain) | 50 | warm | pirandello_death |
| cinecitta_1937 | File:Linauguration de Cinecitta par B. Mussolini en 1937 (5855634665).jpg | CC BY (CC BY 2.0) | 50 | warm | cinecitta_opens |
| naples_fleet_1938 | File:Altair altre tp Cesare e Cavour a Napoli fine anni Trenta (Naval History and Heritage Command).jpg | PD (Public domain) | 50 | warm | hitler_visit_italy |
| italy_team_1938 | File:L'équipe d'Italie championne du monde de football en 1938 à Paris.jpg | PD (Public domain) | 50 | warm | world_cup_1938 |
| bartali_1936 | File:Gino Bartali, vainqueur du Tour de Lombardie en novembre 1936.jpg | PD (Public domain) | 30 | warm | bartali_tour_1938 |
| durres_1939 | File:Italian troops in Durrës.jpg | PD (Public domain) | 50 | warm | albania_landing |
| mirafiori_aerial | File:Stabilimento Fiat Mirafiori, veduta aerea, Torino 1942 - san dl SAN IMG-00001319.jpg | PD (Public domain) | 50 | warm | mirafiori_opening |
| coppi_bartali_1940 | File:Coppi Bartali 1940.jpg | PD (Public domain) | 50 | warm | giro_1940_coppi |
| taranto_aftermath | File:Italian ship BB LIttorio on November 12, 1940, after Taranto attack (P00090.091).jpg | PD (Public domain) | 50 | warm | taranto_night |

Thumbnail: naples_fleet_1938, crop center

Pack intro: Historical flavor events for Italy, from 1936 to the British attack on Taranto in November 1940. Each event is drawn from a sourced moment of the period, from politics and sport to the economy, culture, the army and the navy. Most show a photograph; the rest use the game's own event art.

Bundle intro: Historical flavor events for Finland, France, Italy and Poland in one item: every Event Pack of the series, set between 1936 and November 1940.

## Fact verification

Four `ep-audit-researcher` agents checked five events each (A: topolino_fiat_500, olympic_football_gold, lira_devaluation_1936, ciano_foreign_minister, aoi_empire_proclaimed; B: axis_protocol_october, spain_sm81_airlift, pirandello_death, cinecitta_opens, guadalajara_ctv; C: hitler_visit_italy, easter_accords, world_cup_1938, bartali_tour_1938, albania_ultimatum; D: mirafiori_opening, coffee_sugar_rationing, giro_1940_coppi, balbo_tobruk, british_somaliland_1940). Three more agents then filled gaps that the first pass had left as a tool paraphrase without the page's words (olympic final, Easter Accords, Berlin protocol, Tour 1938, rationing, Giro 1940, Albania, Somaliland) and checked taranto_night in full. The fetch tool returns summaries with short quoted fragments: a fact is in a fact sheet only with a fragment the tool printed in quotation marks as the page's words, and a fact whose only support was a paraphrase was left out of the texts.

Counts per checked event (KEEP / FIX / DROP; an UNVERIFIED fact counts as dropped):

| Event | K | F | D | Fixed or dropped |
|---|---|---|---|---|
| topolino_fiat_500 | 5 | 1 | 1 | FIX: the brief to Giacosa is not Agnelli's quoted words (Fessia's brief: four passengers, 5,000 lire); DROP: presentation on 10 June at Villa Torlonia |
| olympic_football_gold | 5 | 2 | 0 | FIX: the Austrian scorer is disputed (not named); the quarter-final goal counts per player dropped from the text (8-0 and the date hold) |
| lira_devaluation_1936 | 5 | 1 | 1 | FIX: the gate was the Tripartite Agreement of September 1936, not sterling and francs leaving gold; DROP: decree gold weights (unreadable pages) |
| ciano_foreign_minister | 4 | 1 | 1 | FIX: the silver medals were not confirmed, left out; DROP: Suvich's departure (not fetched) |
| aoi_empire_proclaimed | 5 | 1 | 1 | FIX: the 1 June decree wording (no name in the quote); DROP: the crowd figure (200,000 against 400,000) |
| axis_protocol_october | 6 | 0 | 0 | wording kept to 'protocol' and 'restoration of Germany's colonies'; Milan named without a square |
| spain_sm81_airlift | 4 | 3 | 0 | FIX: Bonomi and Muti were picked up at Orbetello; CR.32 came by ship on 14 August; some planes were lost on the way (no count given) |
| pirandello_death | 3 | 0 | 4 | DROP: refusal of a state funeral (sources conflict), ashes buried 1947, the will, the torn party card of 1927 |
| cinecitta_opens | 5 | 0 | 0 | 21 stages held back (a page says 19 today); only '73 buildings' used |
| guadalajara_ctv | 6 | 0 | 1 | DROP: casualty and tank counts (the page contradicts itself); '26,000' used as the page's own figure |
| hitler_visit_italy | 9 | 0 | 1 | DROP: the station architect (no page names one); the text says no day for the youth display |
| easter_accords | 6 | 0 | 2 | DROP: a Red Sea understanding and a Spanish-volunteers precondition (not on the page); the signing itself had no verbatim line, so the text says 'concluded' without a day or signatory |
| world_cup_1938 | 7 | 0 | 1 | DROP: black shirts or protests in Marseille; the 'win or die' telegram is used only as the page's 'no record remains' |
| bartali_tour_1938 | 5 | 1 | 1 | FIX: Galibier and Iseran were on stage 15 only (not used); DROP: regime reaction |
| albania_ultimatum (event albania_landing) | 9 | 1 | 0 | FIX: Abaz Kupi and Mujo Ulqinaku led fewer than 500; the event was recast as the landing because the ultimatum had no verbatim wording |
| mirafiori_opening | 4 | 1 | 0 | FIX: the million square metres was a plan ('sarebbe stato edificato'), worded as 'is to be built' |
| coffee_sugar_rationing | 4 | 1 | 1 | FIX: the year of the October suspension is not on the page (the text gives none); DROP: the law of 6 May 1940 |
| giro_1940_coppi | 5 | 0 | 0 | stage 11 was 29 May 1940, which sets the window start |
| british_somaliland_1940 | 5 | 2 | 0 | FIX: Aosta overall commander with Nasi his deputy (not Nasi in the field); casualty totals differ by source and are not used |
| taranto_night | 7 | 1 | 0 | FIX: Littorio took three torpedo hits (two bow, one stern), a fourth torpedo did not explode; casualty totals differ and are not used |
| balbo_tobruk (replaced) | 5 | 2 | 0 | FIX: Governor of Libya without a start date; the SM.79 type rests on one page |

Replaced: balbo_tobruk by taranto_night. Reason: the pack's effects (`data/effect-caps.json`) have no `retire_character`, so the event could not remove Balbo from the game, and By Blood Alone already ships its own Balbo accident events (`BBA_italy_air_accident.01` to `.03`, which retire him through `retire_character`). Candidates left in the dossiers for later: giro_bartali_1936, sanctions_lifted, triennale_rural_architecture, mostra_augustea, mussolini_germany_visit, league_exit, manifesto_razza, libya_fourth_shore, camera_fasci_corporazioni, pact_of_steel, brescia_1940_race.

## Trigger verification

`Test-HoiConditions.ps1 -Events` was run on the plan (every trigger is valid script, 0 dead) and the `trigger-checker` agent resolved every `fire.trigger` against the game files in four rounds. Findings that shaped the triggers:

- **Italy starts the game at war with Ethiopia** (`history/countries/ITA - Italy.txt:487`), so `has_war = no` is false from the first day. Every peacetime event therefore uses `NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }` (at war with nobody but Ethiopia), which holds at the start and is blocked once Italy fights anyone else. This is a reading of the owner's rule 'a peacetime event is blocked once its country is at war'; the owner confirms it (see "Decisions").
- `ITA_victory_in_ethiopia_flag` (set only in `ITA_end_the_italo_ethiopian_war` when Italy or a subject holds Shewa, state 271) gates the events that assume Ethiopia is won: aoi_empire_proclaimed, easter_accords, british_somaliland_1940. The flag's setters sit in By Blood Alone files; without that DLC these three events do not fire (unverified).
- `has_global_flag = spanish_civil_war` is set when the civil war starts (`LAR_Spain.txt:2480`, `Spain.txt`) and never cleared; the war's end sets `scw_over`.

Verdict per event, final round (OK, or the FIX that was applied):

| Event | Verdict | Trigger |
|---|---|---|
| aoi_empire_proclaimed | OK after FIX | the Ethiopia victory flag, the King still in office (`has_idea = vittorio_emanuele`), Mussolini as leader; was `any_owned_state = { is_core_of = ETH }`, which holds while the war runs; window 1936.6.1 to 1939.1.1; the text names no decree date |
| topolino_fiat_500, olympic_football_gold, lira_devaluation_1936, pirandello_death, bartali_tour_1938, coffee_sugar_rationing, giro_1940_coppi | OK | peace gate; the Topolino window opens 1 July because the text says 'debuted in June' |
| ciano_foreign_minister, cinecitta_opens, mirafiori_opening | OK | peace gate and Mussolini as leader |
| spain_sm81_airlift | OK after FIX | civil war running (global flag, not `scw_over`), fascist Italy, a Nationalist side exists, Italy not sending volunteers to the Republic; window 1936.1.1 to 1939.4.1 |
| guadalajara_ctv | OK after FIX | civil war running and Italian volunteers with the Nationalist side (`any_country = { has_idea = SPA_death_before_surrender has_volunteers_amount_from = { tag = ROOT count > 0 } }`); the first draft looked only at the SPR tag |
| axis_protocol_october | OK after FIX | peace gate, fascist Germany, Mussolini |
| easter_accords | OK after FIX | peace gate, Britain exists, the Ethiopia victory flag; the Spain sentence was cut from the text |
| hitler_visit_italy | OK after FIX | peace gate, Mussolini and Hitler as leaders, fascist Germany |
| world_cup_1938 | OK | peace gate |
| albania_landing | OK after FIX (round 2026-11-09) | `NOT = { country_exists = ALB } 44 = { is_owned_by = ROOT } has_character = ITA_vittorio_emanuele_iii` (state 44 is Central Albania with Tirana and Durrës; the guard is there because the text names the King; the first draft of this trigger lacked it), chance 50, window 1939.1.1 to 1941.1.1. Round 1 (the war gate `has_war_with = ALB has_offensive_war_with = ALB`) was dropped by the owner's second decision of 2026-11-09: in an AI game Albania probably yields without a war, so that gate rarely held. The text no longer says 'landed', so it holds after a war and after a yield |
| british_somaliland_1940 | OK after FIX | war with Britain, Ethiopia won, Italy holds Shewa, Britain still holds British Somaliland (state 269); window opens 1940.1.1 only as the lower bound for Aosta and Nasi in their posts, not as a war date |
| taranto_night | OK after FIX; OPEN (run time), owner accepted 2026-11-09 | war with Britain, Italy controls Puglia (849), Italy has at least two battleships, Britain has a carrier; the text needs only two battleships |

Final pass (axis_protocol_october, albania_landing, taranto_night, after the last text changes): all OK.

Round of 2026-11-09 (after the reviewer's findings): `guadalajara_ctv` OK with its window from 1937.1.1; `taranto_night` window from 1940.1.1, OPEN on run time only (the length of Italy's war with Britain at 8 a week), accepted by the owner on 2026-11-09, no probe run; `albania_landing` recast and OK after the king guard (above). Open points the checker left, not fixed: the focus that annexes Albania can finish before 1939.1.1, so the event may fire in early January 1939 after an earlier annexation (the window stays at 1939.1.1 so that the Workshop list shows the year of the historical event); `country_exists = GRE` was not added; whether `has_character` turns false after `retire_character` is unverified (then the event just does not fire). The vanilla decision `ITA_establish_the_regno_albania` can make Albania exist again as a subject, which ends the condition; it never makes the text false.

Unverified engine behaviour, accepted as run-time: whether the country holding tag SPR reports `has_civil_war`, which the final triggers no longer use; whether `has_navy_size` counts ships in production (the start has two deployed battleships); whether `has_offensive_war_with` is true for the side that joined a war later; how `is_controlled_by` resolves for a state split between two controllers (states 849 and 271). `Test-HoiConditions` reports `has_completed_focus = ITA_albanian_occupation` as NEVER SET for ITA, a tool artefact (the focus is in `italian_focus`); no trigger uses it.

## Editor record

Round 1 (`ep-editor`, 20 events): 5 KEEP (olympic_football_gold, lira_devaluation_1936, pirandello_death, cinecitta_opens, bartali_tour_1938), 14 REWRITE, 1 REJECT (world_cup_1938: the telegram paragraph was hindsight and left under 40 words of facts). All rewrites were applied as given, with these exceptions: taranto_night keeps no ship names (no trigger can show that a named ship is in service); easter_accords keeps no Spain sentence and its second option was reworded; aoi_empire_proclaimed waited for the page's words that name the King and the decree. world_cup_1938 was rewritten around the final's own facts (scorers, attendance, referee) after a quote check, and its picture changed to the Italian team as champions in Paris.

Round 2 (15 events sent back): 5 KEEP, 10 REWRITE, applied as given (past tense for events whose window outlasts the dated fact; fact lines corrected to their quotes; Ciano without the unquoted 'Mussolini'; axis title without a signatory; Hitler's option without 'decorations').

Round 3 (11 events): 8 KEEP, 3 REWRITE (axis_protocol_october without the joined trip clause; albania_landing with a title that names the coast and a text of 40 words or more; taranto_night needing only two battleships), applied as given. Trigger-checker points that changed texts in between: aoi_empire_proclaimed without 'dated 1 June'; albania_landing recast as the landing only (the fall of Durazzo cannot be shown by a trigger); british_somaliland_1940 window from 1940.1.1.

Round 4 (axis_protocol_october, albania_landing, taranto_night): 2 KEEP (axis_protocol_october, albania_landing), 1 REWRITE (taranto_night: the carrier and the time of night are two facts, now two sentences, and the question covers both options). The rewrite is applied as the editor gave it. It is the fourth round on that event, past the limit of three, so it did not go back to the editor; the owner is told in the hand-off. Every other event has the editor's KEEP of its latest round.

Round 5 (2026-11-09, after the reviewer's findings): spain_sm81_airlift and guadalajara_ctv (tense, the facts their quotes support): 2 REWRITE, applied as given; albania_landing (recast on the owner's second decision, three facts true after a war and after a yield): 1 REWRITE (42 words, one question for both options), applied as given. None of the three went back to the editor after its rewrite.

Workshop intro texts (`workshop-editor`, mod mode, round 1): the pack intro and the bundle intro were both REWRITE (the period ended at 'the end of 1940', but the files end with the Taranto event in November 1940); both rewrites are applied. Round 2 below.

## Kept on judgment

The rehearsal printed no `[WARN]` in `-Check -Pack italy` or `-RenderEvents -Pack italy`, so the implementer stops on any warning. Notes that are not warnings:

- The picture `mirafiori_aerial` carries a faint 'Archivio Storico Fiat' watermark of the archive's own scan; the file is public domain under the licence gate.
- The picture `taranto_aftermath` is a dark aerial photograph with a small subject; it is the only accepted period picture of the raid's aftermath.
- The picture `sm81_spain` shows an SM.81 in Nationalist markings over Spain; the event's text does not claim the pictured aircraft.
- `pictures.json` will record a pictureYear of 1896 for `olympic_team_1936` and 1937 for `taranto_aftermath`; the Workshop page makes no claim from them.
- `albania_landing` no longer depends on how Italy gets Albania: the text of 2026-11-09 holds after a war and after a yield (see "Decisions"). Its picture `durres_1939` shows Italian troops at Durrës, which sits better with a war than with a yield; the picture stays.
- `taranto_night` stays OPEN on run time only (the length of Italy's war with Britain at 8 a week); the owner accepted it on 2026-11-09 and no probe was run.
- `spain_sm81_airlift` and `guadalajara_ctv` need the La Resistance DLC: the idea `SPA_death_before_surrender` is added only by `events/LAR_Spain.txt`, and the civil war without that DLC (`events/Spain.txt` `spain.1`) adds neither idea, so without the DLC both triggers are always false. The idea also lasts 900 days, so in a long civil war both events stop being possible after that (from the files; the engine side is unverified). The owner accepted the dependency on 2026-11-09. The three Ethiopia-flag events likewise need By Blood Alone.
- The reviewer's findings of 2026-11-09 were applied on the owner's word: the `taranto_night` quote now cites the Littorio page; `spain_sm81_airlift` and `guadalajara_ctv` are in the past tense; the windows of `guadalajara_ctv` (1937.1.1), `albania_landing` (1939.1.1) and `taranto_night` (1940.1.1) open nearer their historical years, so the Workshop event list reads right. The war events stay gated on the game state. The changed texts, triggers and the fact sheet went through `ep-editor`, `trigger-checker` and `ep-audit-researcher` before the implementer runs again (results below).
- Gate results of 2026-11-09: `ep-audit-researcher` on `taranto_night`: 6 KEEP, the Littorio quote is on its new page. `ep-audit-researcher` on the two SM.81 quotes: the full sentences from the Legionary Air Force page are in the fact sheet now (the page gives no count of planes that left on 30 July). `ep-editor` on events 4 and 8: REWRITE for both, applied as given (title of event 4 is now "Rome Orders Twelve SM.81 Bombers Sent"; `guadalajara_ctv` no longer says the Garibaldi Battalion stood across the line or whose airfields; the fact lines were corrected to what their quotes say). It is a new editor round for these two events, not re-judged after the rewrite. The editor notes that `guadalajara_ctv` is not tied to a season, so it can fire in summer while "Hold the column until the weather clears" treats the weather as present; nothing was changed. `trigger-checker` on the three new windows: the later start dates stop none of them from firing; `guadalajara_ctv` OK; `albania_landing` and `taranto_night` OPEN for run-time reasons that the date change did not cause.
- Superseded on 2026-11-09: the war gate of `albania_landing` (`has_war_with = ALB`) was replaced by the owner's second decision (see "Decisions" and the first note above), and `taranto_night` was accepted OPEN on run time by the owner.
- The last editor rewrite of `taranto_night` went in without a further editor round (the limit of three rounds was passed); the trigger-checker's last pass is OK.

## Implementation steps

- [x] 1. Write the source from the blocks below (run again on 2026-11-09 after the owner's second decision on `albania_landing`: its title, text, option and trigger changed, so expect `events 1 changed` and `fact-sheet sections 0 replaced`): `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-08-italy-new-pack.md`: expect `Applied 2026-11-08-italy-new-pack.md`, with no `[WARN]` outside "Kept on judgment", and with the events and fact-sheet sections it lists as changed or added being the ones this plan changes. It writes `source/italy/events.json` from the `json events` block (the whole file; a `"mergeById": true` block puts its events in place of those of the same id) and puts each section of the `markdown fact-sheets` block in place of the section of the same key in `source/italy/fact-sheets.md`, adding new keys. An `[ERROR]` (`ApplyPlan refused`) is a stop condition.
- [x] 2. Check that the source holds the blocks: `powershell -File .\build.ps1 -ApplyPlan -Plan docs\plans\2026-11-08-italy-new-pack.md -DryRun`: expect `Dry run: 0 file(s) would be written`.
- [x] 3. Fetch the pictures as one loop in one tool call, not one call per picture: a PowerShell `foreach` over the rows of the picture table, running the command below for each row and printing its output. The loop stops at the first row whose output has no `ACCEPTED` (`$out = powershell -File ...; $out; if (-not ($out -cmatch '\bACCEPTED\b')) { break }`); a retry after a failure reruns the loop over the remaining rows only, the failed row onward, not over all of them. Each row is expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack italy -File "<File:...>" -Key <key> -Crop <crop> -Tone <tone>`, with `<crop>` the row's number from the "Crop" column (50, 25 for ciano_1936, 30 for bartali_1936)
- [x] 4. Make the thumbnail from the picture fetched in step 3 (when "Thumbnail" says unchanged, this step reads `Thumbnail unchanged: nothing to run.`):
  - In `assets/thumbnail.json`, set `packs.italy.background` to `{ "path": "sources-cache/italy/naples_fleet_1938.*", "crop": "center" }`, adding the pack's entry under `packs` when it has none.
  - `powershell -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack italy`: expect the pack's line with `new` or `changed` and no `Warning:` line; open the preview it names with the Read tool.
  - `powershell -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Showcase\New-HoiThumbnail.ps1" -Path . -Pack italy -Apply`: expect the pack's line with `new` or `changed`.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack italy`: expect `failed=0`.
- [x] 6. (Run again: `-Generate -Pack italy` and the text check only; the intro files are already in place, and an event text changed.) When "Pack intro" gives text, replace the intro text of `source/italy/workshop-intro.bbcode` with it, and when "Bundle intro" gives a sentence, replace the first sentence of the intro of `source/all/workshop-intro.bbcode` with it (the lines around each stay: region markers, the info lines). Then `powershell -File .\build.ps1 -Generate -Pack italy`: expect `Generated pack 'italy'`; it also writes the bundle page `packs/all/WORKSHOP_DESCRIPTION_GUIDELINES.md` with this pack's event count. When "Pack intro" gave text: `powershell -NoProfile -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Workshop\Sync-WorkshopRegions.ps1" -ModName "Event Packs"` and `powershell -NoProfile -File "C:\dev\Hearts of Iron IV Modding Manager\Scripts\Workshop\Test-WorkshopText.ps1" -Mod "Event Packs" -Pack italy -TextOnly`: expect the second to report `no problem found (the description Steam gets, apart from the cross-link block)`. Image addresses and cross-links stay with the release preflight. (The planning rehearsal skips these two: they act on the registered repository, not on its copy.)
- [x] 7. `powershell -File .\build.ps1 -Check -Pack italy`: expect `Check OK` and `Bundle 'all': <n> member(s), 0 error(s)`, with no warning outside "Kept on judgment". A new pack is already in the bundle's `members` (`-NewPack` added it).
- [x] 8. `powershell -File .\build.ps1 -RenderEvents -Pack italy`: expect `Rendered <n> events to ...artifacts\workshop-images\italy` (the folder gets one render per event, `00-overview` and `contact-sheet-NOT-FOR-WORKSHOP`), with no `[WARN]` outside "Kept on judgment".
- [x] 9. `powershell -File .\build.ps1 -ValidateOnly`: expect `Validation succeeded.` (the full suite runs once, in `event-pack-implement` 3.2).
- [x] 10. Ship, after the user confirms, through the shared `ship` skill: commit with the message `feat(italy): <summary>`. `ship` archives this plan, pushes the repository and its wiki, and writes the in-game row when one is due. The commit holds the bundle's files too (`tools/HoiModBuild.json`, `source/all/`, `packs/all/`). The Workshop upload is `event-pack-release`: one `Publish-Mod.ps1 -Pack italy` run uploads the pack and then the bundle, and a new country is released with its Commanders Pack in the same session.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

Date: 2026-11-09. Steps 1 to 9 done (steps 1, 2, 6 to 9 run again after the reviewer's fixes and again after the owner's change to event 15; steps 3 to 5 kept, the pictures unchanged); step 10 (ship) left for the caller.

`-Check` summary: `Check OK: 1 pack(s), 1 bundle(s), 0 warning(s).` (`Bundle 'all': 4 member(s), 0 error(s)`; `Pack 'italy': 20 event(s), 13 picture(s), 0 error(s)`.)

Deviations:
- After the owner's change to event 15 (albania_landing: new title, text, second option and trigger): `-ApplyPlan` printed "events 1 changed, 0 added, 19 unchanged; fact-sheet sections 0 replaced, 0 added, 20 unchanged"; the dry run wrote nothing; `-Generate` wrote 13 files; `-Check` gave `Check OK: 1 pack(s), 1 bundle(s), 0 warning(s).`; `-RenderEvents` had no warning; `-ValidateOnly` gave "Validation succeeded." with the same three finland PD-US warnings as before.
- After the reviewer's fixes: `-ApplyPlan` changed events 4, 8, 15 and 20 and fact-sheet sections spain_sm81_airlift, guadalajara_ctv and taranto_night; the dry run then wrote nothing. `-Generate` wrote 13 files. `-ValidateOnly` again printed the three finland PD-US `[WARN]` lines and no italy warning.
- Step 3: the first run stopped at step 3 before any fetch, because the step's literal `-Crop "center"` is rejected by the tool (crop is 0 to 100 or fit). The owner approved the per-row crop from the picture table (50; 25 for ciano_1936; 30 for bartali_1936), the plan was corrected, and the loop ran from row 1 over all 13 rows, all ACCEPTED.
- Step 6: `Sync-WorkshopRegions.ps1` listed "Event Pack: Italy ... Stale ... Written"; the text check then reported no problem.
- Step 9: `-ValidateOnly` printed `[WARN]` lines for finland (mermoz_disappearance, pcf_dissolution_1939, richelieu_launch_1939: public domain in the US only). They are not in this plan's scope and are not italy warnings; the italy pack printed none.

## Fact sheets

```markdown fact-sheets
## aoi_empire_proclaimed

- Mussolini proclaimed the formation of the Italian Empire from the balcony of Palazzo Venezia. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «Mussolini proclaimed the formation of the Italian Empire from the balcony of Palazzo Venezia»
- Mussolini said: Ethiopia is Italian, because it is occupied by Italian armies. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «Ethiopia is Italian! Italian in fact, because it is occupied by our victorious armies.»
- King Victor Emmanuel III assumed the additional title of Emperor of Ethiopia. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «King Victor Emmanuel III assumed the additional title of Emperor of Ethiopia»
- A decree dated 1 June 1936 unified Ethiopia, Eritrea and Somalia. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «A decree dated 1 June 1936 unified the three territories of Ethiopia, Eritrea, and Somalia»
- The entity was a single legal and political entity designated Italian East Africa. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «into a single legal and political entity designated Italian East Africa.»
- The colony was divided into six governorates. Source: https://en.wikipedia.org/wiki/Italian_East_Africa (Italian East Africa). Quote: «The colony was divided into six governorates»

## topolino_fiat_500

- The Fiat 500 debuted in June 1936. Source: https://www.italpress.com/torino-celebra-i-primi-90-anni-della-fiat-500-topolino/ (Torino celebra i primi 90 anni della Fiat 500 Topolino). Quote: «Nel giugno del 1936 debuttava la Fiat 500.»
- Engine of 569 cc and 13 horsepower. Source: https://it.motor1.com/news/617812/fiat-topolino-storia-evoluzione/ (Fiat Topolino, la prima auto moderna di Mirafiori). Quote: «569 cc e 13 CV di potenza»
- Top speed 85 km/h. Source: https://www.italpress.com/torino-celebra-i-primi-90-anni-della-fiat-500-topolino/ (Torino celebra i primi 90 anni della Fiat 500 Topolino). Quote: «raggiungere 85 km/h»
- Fiat's brief called for a car able to carry four passengers. Source: https://it.motor1.com/news/617812/fiat-topolino-storia-evoluzione/ (Fiat Topolino, la prima auto moderna di Mirafiori). Quote: «in grado di trasportare quattro passeggeri»
- The target price was 5,000 lire. Source: https://it.motor1.com/news/617812/fiat-topolino-storia-evoluzione/ (Fiat Topolino, la prima auto moderna di Mirafiori). Quote: «venduta a un prezzo di 5.000 lire»
- The simplest version cost 8,900 lire. Source: https://it.motor1.com/news/617812/fiat-topolino-storia-evoluzione/ (Fiat Topolino, la prima auto moderna di Mirafiori). Quote: «ben 8.900 per la versione più semplice»

## ciano_foreign_minister

- Ciano was named foreign minister on 9 June 1936, aged 33. Source: https://www.universalis.fr/encyclopedie/galeazzo-ciano/ (Galeazzo Ciano). Quote: «À trente-trois ans, le 9 juin 1936, il est nommé ministre des Affaires étrangères.»
- Ciano was born on 18 March 1903. Source: https://en.wikipedia.org/wiki/Galeazzo_Ciano (Galeazzo Ciano). Quote: «18 March 1903»
- Ciano was minister of press and propaganda in the government of his father-in-law. Source: https://en.wikipedia.org/wiki/Galeazzo_Ciano (Galeazzo Ciano). Quote: «Ciano became the minister of press and propaganda in the government of his father-in-law.»
- Ciano volunteered for the Ethiopian campaign as a bomber squadron commander. Source: https://en.wikipedia.org/wiki/Galeazzo_Ciano (Galeazzo Ciano). Quote: «He volunteered for action in the Italian invasion of Ethiopia (1935–36) as a bomber squadron commander.»

## spain_sm81_airlift

- Mussolini ordered the undersecretary to send twelve SM.81 bombers. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «On 27 July, Mussolini ordered the undersecretary for the Regia Aeronautica, General Giuseppe Valle, to send 12 three-engined Savoia-Marchetti SM.81 bombers with crews and relevant specialists to Franco.»
- The bombers were three-engined Savoia-Marchetti SM.81, twelve of them. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «to send 12 three-engined Savoia-Marchetti SM.81 bombers»
- The first unit set out at dawn from Cagliari-Elmas on Sardinia. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «They would form the first unit, initially known as Aviación del Tercio, and set out at dawn on 30 July from Cagliari–Elmas on Sardinia»
- Italian insignia were blotted out. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «All Italian insignia on the planes had been blotted out.»
- The planes were presented as sold to the journalist Luis Bolín. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «being sold to the Spanish journalist Luis Bolín»
- Not all the planes reached Morocco. Source: https://en.wikipedia.org/wiki/Legionary_Air_Force (Legionary Air Force). Quote: «Not all of the Italian planes sent to aid the rebel faction reached Morocco.»

## olympic_football_gold

- The final was Italy against Austria. Source: https://en.wikipedia.org/wiki/Football_at_the_1936_Summer_Olympics (Football at the 1936 Summer Olympics). Quote: «In the final, Italy overcame Austria in a match refereed by Peco Bauwens.»
- Frossi scored first for Italy midway through the second half. Source: https://en.wikipedia.org/wiki/Football_at_the_1936_Summer_Olympics (Football at the 1936 Summer Olympics). Quote: «Midway through the second half, Frossi scored first for the Azzurri.»
- Frossi got the winning goal as extra time began. Source: https://en.wikipedia.org/wiki/Football_at_the_1936_Summer_Olympics (Football at the 1936 Summer Olympics). Quote: «Frossi got the winning goal for Italy just as extra time got underway»
- Frossi scored two goals, one of them in extra time. Source: https://www.glieroidelcalcio.com/?p=26839 (15 Agosto 1936: l'oro olimpionico). Quote: «Due gol, di cui uno nei tempi supplementari.»
- The coach was Vittorio Pozzo. Source: https://www.glieroidelcalcio.com/?p=26839 (15 Agosto 1936: l'oro olimpionico). Quote: «un certo Vittorio Pozzo come commissario tecnico»
- The final was played in the Olympiastadion in Berlin. Source: https://www.glieroidelcalcio.com/?p=26839 (15 Agosto 1936: l'oro olimpionico). Quote: «quell'Olympiastadion di Berlino»
- Italy defeated Japan after Pozzo decided to include Biagi. Source: https://en.wikipedia.org/wiki/Football_at_the_1936_Summer_Olympics (Football at the 1936 Summer Olympics). Quote: «Italy defeated Japan after Pozzo's decision to include Biagi»

## lira_devaluation_1936

- The lira was devalued on 5 October by about 41 per cent. Source: https://www.luigieinaudi.it/?p=3607 (Articolo della Rivista: The Economist). Quote: «the devaluation of the lira on October 5th by about 41 per cent.»
- The dollar rate went from 11.22 to 19 lire. Source: https://www.luigieinaudi.it/?p=3607 (Articolo della Rivista: The Economist). Quote: «the dollar exchange fell from 11.22 to 19 lire»
- Industrialists had accumulated large stocks of raw materials. Source: https://www.luigieinaudi.it/?p=3607 (Articolo della Rivista: The Economist). Quote: «Industrialists had accumulated large stocks of raw materials.»
- The revaluation of the gold reserve gave the Bank and the Treasury a bonus. Source: https://www.luigieinaudi.it/?p=3607 (Articolo della Rivista: The Economist). Quote: «a not inconsiderable bonus to the Bank and the Treasury»
- In September 1936 the United States, Great Britain and France signed the Tripartite Agreement. Source: https://en.wikipedia.org/wiki/Gold_bloc (Gold bloc). Quote: «In September 1936, the United States, Great Britain, and France signed the Tripartite Agreement»

## axis_protocol_october

- The protocol was concluded on 23 October 1936. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «On 23 October 1936,»
- Ciano's trip was his first abroad as foreign minister. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «his first trip abroad as foreign minister»
- Ciano met von Neurath on 21 October. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «He met von Neurath on 21 October»
- The protocol named communism the greatest danger. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «Communism is the greatest danger threatening the peace and the security of Europe.»
- Italy undertook to support the restoration of Germany's colonies. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «support the restoration of Germany's colonies»
- Mussolini spoke of an axis. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «this vertical axis Berlin–Rome is not a diaphragm, but rather an axis.»
- The terms were not publicly revealed at the time. Source: https://en.wikipedia.org/wiki/Italo-German_protocol_of_23_October_1936 (Italo-German protocol of 23 October 1936). Quote: «were not publicly revealed at the time»

## guadalajara_ctv

- The Italian forces numbered 26,000 soldiers. Source: https://it.wikipedia.org/wiki/Battaglia_di_Guadalajara (Battaglia di Guadalajara). Quote: «erano composte da 26 000 soldati»
- General Roatta commanded the Italian forces. Source: https://it.wikipedia.org/wiki/Battaglia_di_Guadalajara (Battaglia di Guadalajara). Quote: «il generale Roatta, comandante delle forze italiane»
- The advance was slowed by fog and sleet. Source: https://it.wikipedia.org/wiki/Battaglia_di_Guadalajara (Battaglia di Guadalajara). Quote: «rallentato da nebbia e nevischio»
- The dirt airfields were flooded with mud. Source: https://it.wikipedia.org/wiki/Battaglia_di_Guadalajara (Battaglia di Guadalajara). Quote: «piste in terra battuta inondate dal fango»
- The Garibaldi Battalion was formed from Italian anti-fascist volunteers. Source: https://it.wikipedia.org/wiki/Battaglia_di_Guadalajara (Battaglia di Guadalajara). Quote: «Battaglione Garibaldi formato dai volontari antifascisti italiani»

## pirandello_death

- Pirandello died alone in his home at Via Bosio, Rome, on 10 December 1936. Source: https://en.wikipedia.org/wiki/Luigi_Pirandello (Luigi Pirandello). Quote: «Pirandello died alone in his home at Via Bosio, Rome, on 10 December 1936.»
- Pirandello was 69, a playwright. Source: https://time.com/archive/6756492/milestones-dec-21-1936 (Milestones, Dec. 21, 1936). Quote: «Luigi Pirandello, 69, metaphysical playwright»
- He died of pneumonia in Rome. Source: https://time.com/archive/6756492/milestones-dec-21-1936 (Milestones, Dec. 21, 1936). Quote: «of pneumonia; in Rome»
- He was a member of the Italian Academy. Source: https://time.com/archive/6756492/milestones-dec-21-1936 (Milestones, Dec. 21, 1936). Quote: «member of the Italian Academy»
- He was awarded the Nobel Prize for Literature in 1934. Source: https://en.wikipedia.org/wiki/Luigi_Pirandello (Luigi Pirandello). Quote: «in 1934 he was awarded the Nobel Prize for Literature»
- He gave his Nobel Prize medal to the Fascist government to be melted down. Source: https://en.wikipedia.org/wiki/Luigi_Pirandello (Luigi Pirandello). Quote: «He then gave his Nobel Prize medal to the Fascist government to be melted down»
- He was finishing a volume to be called Memories of My Involuntary Sojourn on Earth. Source: https://time.com/archive/6756492/milestones-dec-21-1936 (Milestones, Dec. 21, 1936). Quote: «was finishing a volume to be called Memories of My Involuntary Sojourn on Earth»

## cinecitta_opens

- Mussolini and Giacomo Paulucci di Calboli inaugurated Cinecittà on 28 April 1937. Source: https://it.wikipedia.org/wiki/Cinecittà (Cinecittà). Quote: «il 28 aprile 1937, Mussolini e Giacomo Paulucci di Calboli inaugurarono Cinecittà»
- A vast fire in 1935 destroyed the studios of the Cines company. Source: https://it.wikipedia.org/wiki/Cinecittà (Cinecittà). Quote: «Nel 1935 un vasto incendio distrusse gli studi cinematografici della società Cines»
- The complex had 73 buildings. Source: https://it.wikipedia.org/wiki/Cinecittà (Cinecittà). Quote: «un complesso composto da 73 edifici, tra cui 21 teatri di posa»
- The area was 400,000 square metres. Source: https://it.wikipedia.org/wiki/Cinecittà (Cinecittà). Quote: «Con una superficie di 400 000 metri quadrati»
- The architect was Gino Peressutti. Source: https://it.wikipedia.org/wiki/Cinecittà (Cinecittà). Quote: «su progetto dell'architetto Gino Peressutti»

## easter_accords

- The two governments undertook to observe the order in the Mediterranean. Source: https://en.wikipedia.org/wiki/Easter_Accords (Easter Accords). Quote: «undertook to observe the order in the Mediterranean.»
- The governments undertook to uphold the freedom of navigation in the Suez Canal. Source: https://en.wikipedia.org/wiki/Easter_Accords (Easter Accords). Quote: «undertook to uphold the freedom of navigation in the Suez Canal.»
- Italy undertook to withdraw its forces from Spain. Source: https://en.wikipedia.org/wiki/Easter_Accords (Easter Accords). Quote: «undertook to withdraw its forces from Spain.»
- Ethiopia was not named in the agreements. Source: https://en.wikipedia.org/wiki/Easter_Accords (Easter Accords). Quote: «Ethiopia was not named in the agreements.»

## hitler_visit_italy

- The German visitors stayed until 9 May and visited Rome, Naples and Florence. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «Gli ospiti nazisti rimarranno fino al 9 maggio visitando Roma, Napoli e Firenze.»
- Mussolini waited for Hitler at the Ostiense station. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «Mussolini attendeva l'alleato atteso alla stazione Ostiense»
- The station was built for the occasion and not yet finished. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «costruita per l'occasione e non ancora terminata»
- A display was given by 50,000 balilla and avanguardisti. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «svolta da 50.000 balilla e avanguardisti»
- The Regia Marina took part in a naval parade at Naples. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «la maestosa parata navale alla quale partecipò il meglio della Regia Marina»
- On the evening of 5 May Hitler attended Aida at the Teatro San Carlo with the King. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «La sera del 5 maggio, in compagnia del Re, Hitler assiste all'Aida al Teatro San Carlo.»
- The train left Florence after midnight and reached the Brenner on the morning of 9 May. Source: https://www.panorama.it/cultura/80-anni-fa-il-viaggio-di-hitler-italia-la-storia-e-le-foto/ (80 anni fa il viaggio di Hitler in Italia). Quote: «Lasciata Firenze dopo mezzanotte, il convoglio dei nazisti arrivò al Brennero la mattina del 9 maggio 1938»

## world_cup_1938

- The tournament was held in France from 4 to 19 June 1938. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup (1938 FIFA World Cup). Quote: «held in France from 4 to 19 June 1938»
- The final was played at the Stade Olympique de Colombes. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «Stade Olympique de Colombes»
- The attendance was 45,000. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «Attendance: 45,000»
- Colaussi opened the scoring after six minutes. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «After six minutes, Gino Colaussi opened the scoring for Italy»
- Titkos equalised for Hungary two minutes later. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «Pál Titkos equalised for Hungary two minutes later.»
- Piola scored his second goal to complete a 4-2 win. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «Piola scored his second goal to complete a 4–2 win for Italy.»
- The referee was Georges Capdeville of France. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_final (1938 FIFA World Cup final). Quote: «Referee: Georges Capdeville (France)»
- Italy defended its title in the final. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup (1938 FIFA World Cup). Quote: «Italy defended its title in the final, beating Hungary 4–2.»

## bartali_tour_1938

- The race took place from 5 to 31 July. Source: https://en.wikipedia.org/wiki/1938_Tour_de_France (1938 Tour de France). Quote: «taking place from 5 to 31 July»
- Bartali won the race and the mountains classification. Source: https://en.wikipedia.org/wiki/1938_Tour_de_France (1938 Tour de France). Quote: «The race was won by Italian cyclist Gino Bartali, who also won the mountains classification.»
- The route was 4,694 km. Source: https://en.wikipedia.org/wiki/1938_Tour_de_France (1938 Tour de France). Quote: «4,694 km»
- Bartali had been close to winning in 1937 until he crashed. Source: https://en.wikipedia.org/wiki/1938_Tour_de_France (1938 Tour de France). Quote: «had been close to winning the Tour de France in 1937 until he crashed»
- Bartali was asked to skip the 1938 Giro d'Italia. Source: https://en.wikipedia.org/wiki/1938_Tour_de_France (1938 Tour de France). Quote: «requested him to skip the 1938 Giro d'Italia»

## albania_landing

- About 22,000 soldiers, supported by 400 aircraft and 125 light tanks, landed on the Albanian coast. Source: https://it.wikipedia.org/wiki/Invasione_italiana_dell'Albania (Invasione italiana dell'Albania). Quote: «circa 22 000 soldati appoggiati da 400 aerei e 125 carri armati leggeri sbarcarono sulle coste albanesi.»
- The defenders at Durazzo had fewer than 500 men, including gendarmes and armed volunteers. Source: https://it.wikipedia.org/wiki/Invasione_italiana_dell'Albania (Invasione italiana dell'Albania). Quote: «rimase con meno di 500 effettivi inclusi gendarmi e volontari armati»
- Durazzo fell into Italian hands at about 09:00. Source: https://it.wikipedia.org/wiki/Invasione_italiana_dell'Albania (Invasione italiana dell'Albania). Quote: «Alle 09:00 circa la città cadde in mano italiana»
- Zog took refuge in exile in neighbouring Greece. Source: https://it.wikipedia.org/wiki/Invasione_italiana_dell'Albania (Invasione italiana dell'Albania). Quote: «riparò in esilio nella vicina Grecia»
- The Albanian parliament voted to depose Zog and unite the nation with Italy. Source: https://en.wikipedia.org/wiki/Italian_invasion_of_Albania (Italian invasion of Albania). Quote: «the Albanian parliament voted to depose Zog and unite the nation with Italy»
- The crown was offered to Victor Emmanuel III. Source: https://en.wikipedia.org/wiki/Italian_invasion_of_Albania (Italian invasion of Albania). Quote: «by offering the Albanian crown to Italy's King Victor Emmanuel III»

## mirafiori_opening

- The Fiat plant at Mirafiori was inaugurated on 15 May 1939 in the presence of Mussolini. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «Lo stabilimento FIAT a Mirafiori venne inaugurato il 15 maggio 1939 in presenza di Benito Mussolini in persona»
- Mussolini was flanked by Giovanni Agnelli and Achille Starace and spoke from a prepared platform. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «affiancato da Giovanni Agnelli e da Achille Starace, parlò dal palco predisposto»
- The plant was to be built on one million square metres. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «l'impianto sarebbe stato edificato su un'area di un milione di metri quadrati»
- Over 22,000 workers were to be employed according to the programme. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «sarebbero stati impiegati secondo i programmi oltre 22.000 lavoratori»
- The workers were to be distributed in two shifts. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «distribuiti in due turni»
- Mussolini was received coldly, without great enthusiasm. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «Il Duce tuttavia fu accolto con freddezza, senza manifestazioni di grande entusiasmo»
- The audience was about 50,000 Fiat workers. Source: https://it.wikipedia.org/wiki/Stabilimento_FIAT_Mirafiori (Stabilimento FIAT Mirafiori). Quote: «davanti ai circa 50.000 lavoratori delle FIAT.»

## coffee_sugar_rationing

- The article is dated 17 February 1940. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «The Economist, 17 febbraio 1940, p. 292»
- Coffee was to be on the market again from 1 February. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «coffee is to be on the market again from February 1st»
- Coffee was rationed at 0.6 kilograms a year, already prepared. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «rationed at the rate of 0.6 kilograms (about 1V3 pounds) a year, already prepared»
- Sugar was rationed at 6 kilograms a year. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «Sugar will also be rationed at the rate of 6 kilograms (about 13 V3 pounds) a year»
- The sugar ration was per head. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «The sugar ration of 6 kg. per head yearly»
- The import and sale of coffee were suspended in October. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «The import and sale of coffee were suspended in October»
- Coffee imports amounted in 1938 to 36,000 tons. Source: https://www.luigieinaudi.it/doc/rationing-in-italy/ (Rationing in Italy). Quote: «which amounted in 1938 to 36,000 tons»

## giro_1940_coppi

- The Giro ran in twenty stages from 17 May to 9 June 1940. Source: https://it.wikipedia.org/wiki/Giro_d'Italia_1940 (Giro d'Italia 1940). Quote: «si svolse in venti tappe dal 17 maggio al 9 giugno 1940»
- Stage 11, Florence to Modena, was run on 29 May. Source: https://it.wikipedia.org/wiki/Giro_d'Italia_1940 (Giro d'Italia 1940). Quote: «29 maggio: Firenze > Modena – 184 km»
- Coppi was at his first participation. Source: https://it.wikipedia.org/wiki/Giro_d'Italia_1940 (Giro d'Italia 1940). Quote: «alla sua prima partecipazione»
- Coppi won stage 11 alone, Florence to Modena, and took the pink jersey. Source: https://it.wikipedia.org/wiki/Giro_d'Italia_1940 (Giro d'Italia 1940). Quote: «trionfò in solitaria nell'11ª tappa, da Firenze a Modena, conquistando la maglia rosa.»
- Bartali fell on the descent of the Scoffera in the second stage and left the classification. Source: https://it.wikipedia.org/wiki/Giro_d'Italia_1940 (Giro d'Italia 1940). Quote: «cadde nella discesa del Passo della Scoffera, durante la seconda tappa, e uscì di classifica.»

## british_somaliland_1940

- About 24,000 Italian and colonial troops took part. Source: https://en.wikipedia.org/wiki/Italian_conquest_of_British_Somaliland (Italian conquest of British Somaliland). Quote: «24,000 Italian and colonial troops»
- The British and Commonwealth force numbered 4,507 troops. Source: https://en.wikipedia.org/wiki/Italian_conquest_of_British_Somaliland (Italian conquest of British Somaliland). Quote: «4,507 British and Commonwealth troops»
- Aosta and his deputy General Guglielmo Nasi assessed the likely opposition. Source: https://en.wikipedia.org/wiki/Italian_conquest_of_British_Somaliland (Italian conquest of British Somaliland). Quote: «Aosta and his deputy, General Guglielmo Nasi, completed an appreciation of the likely opposition»
- Aosta urged haste but Nasi refused to rush because the road was deteriorating. Source: https://en.wikipedia.org/wiki/Italian_conquest_of_British_Somaliland (Italian conquest of British Somaliland). Quote: «Aosta urged haste but Nasi refused to rush because the road was deteriorating»

## taranto_night

- The attack was launched from the aircraft carrier HMS Illustrious. Source: https://en.wikipedia.org/wiki/Battle_of_Taranto (Battle of Taranto). Quote: «from the aircraft carrier HMS Illustrious»
- Enemy aircraft attacked the naval base of Taranto in the first hours of the night. Source: https://it.wikipedia.org/wiki/Notte_di_Taranto (Notte di Taranto). Quote: «Nelle prime ore della notte sul 12, aerei nemici hanno attaccato la base navale di Taranto.»
- The planes scored three hits on Littorio, one hit on Duilio and one on Conte di Cavour. Source: https://en.wikipedia.org/wiki/Italian_battleship_Littorio (Italian battleship Littorio). Quote: «The planes scored three hits on Littorio, one hit on Duilio, and one on Conte di Cavour.»
- Of the torpedoes that struck Littorio, two hit in the bow and one struck the stern. Source: https://en.wikipedia.org/wiki/Italian_battleship_Littorio (Italian battleship Littorio). Quote: «Of the torpedoes that struck Littorio, two hit in the bow and one struck the stern.»
- A torpedo hit Duilio, blowing a large hole in her hull. Source: https://en.wikipedia.org/wiki/Battle_of_Taranto (Battle of Taranto). Quote: «hit the battleship Duilio with a torpedo, blowing a large hole in her hull»
- Vittorio Veneto escaped undamaged. Source: https://en.wikipedia.org/wiki/Italian_battleship_Vittorio_Veneto (Italian battleship Vittorio Veneto). Quote: «The ship escaped undamaged during the British raid on Taranto in November 1940.»
```

## Events source

<The whole `source/italy/events.json`. An audit plan holds only the events its fixes change, each as its whole object with its id unchanged, under `"pack"`, `"tag"` and `"mergeById": true` (and `"ideas"` with only the changed ideas, `"factQuotesFromId": null` to remove that field): see `docs/source-format.md`, "Plans".>

```json events
{
    "pack": "italy",
    "tag": "ITA",
    "namespace": "ep_ita",
    "displayName": "Italy",
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
                "trigger": "has_country_flag = ITA_victory_in_ethiopia_flag has_idea = vittorio_emanuele has_country_leader = { character = ITA_benito_mussolini }"
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
            "id": 2,
            "key": "topolino_fiat_500",
            "title": "Fiat Launches the Topolino",
            "desc": "The Fiat 500, known as the Topolino, debuted in June. It has a 569 cc engine with 13 horsepower and a top speed of 85 km/h. Fiat's brief called for a car able to carry four passengers. The target price was 5,000 lire. The simplest version costs 8,900 lire.\n\nWho can afford one?",
            "picture": "topolino_1936",
            "factSheet": "topolino_fiat_500",
            "anchors": [
                "569 cc",
                "8,900 lire",
                "Topolino"
            ],
            "fire": {
                "after": "1936.7.1",
                "before": "1936.8.15",
                "chance": 20,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
            },
            "options": [
                {
                    "name": "A car for the Italian family.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Motoring is for those who can pay.",
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
            "id": 3,
            "key": "ciano_foreign_minister",
            "title": "Ciano Takes the Foreign Ministry",
            "desc": "Galeazzo Ciano, aged 33, has been named Italy's minister of foreign affairs. Born on 18 March 1903, he was minister of press and propaganda in the government of his father-in-law.\n\nHe volunteered for action in the invasion of Ethiopia as a bomber squadron commander.",
            "picture": "ciano_1936",
            "factSheet": "ciano_foreign_minister",
            "anchors": [
                "Galeazzo Ciano",
                "bomber squadron commander",
                "1903"
            ],
            "fire": {
                "after": "1936.6.9",
                "before": "1936.9.1",
                "chance": 20,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini }"
            },
            "options": [
                {
                    "name": "Ciano will speak for the Duce.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": 20
                        }
                    ]
                },
                {
                    "name": "Leave the old ambassadors where they are.",
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
            "id": 4,
            "key": "spain_sm81_airlift",
            "title": "Rome Orders Twelve SM.81 Bombers Sent",
            "desc": "Rome ordered twelve three-engined Savoia-Marchetti SM.81 bombers sent. The first unit set out at dawn from Cagliari-Elmas on Sardinia. All Italian insignia on the planes had been blotted out. On paper the aircraft were being sold to the Spanish journalist Luis Bolín.\n\nNot all of the Italian planes sent to aid the rebel faction reached Morocco. How should we respond?",
            "picture": "sm81_spain",
            "factSheet": "spain_sm81_airlift",
            "anchors": [
                "Cagliari-Elmas",
                "Luis Bolín",
                "SM.81"
            ],
            "fire": {
                "after": "1936.1.1",
                "before": "1939.4.1",
                "chance": 12,
                "trigger": "has_global_flag = spanish_civil_war NOT = { has_global_flag = scw_over } has_government = fascism any_country = { has_idea = SPA_death_before_surrender } NOT = { any_country = { has_idea = SPR_death_before_surrender has_volunteers_amount_from = { tag = ROOT count > 0 } } }"
            },
            "options": [
                {
                    "name": "The planes were sold. We have nothing to add.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": 25
                        }
                    ]
                },
                {
                    "name": "Prepare more aircraft for the same route.",
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
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
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
            "id": 6,
            "key": "lira_devaluation_1936",
            "title": "Lira Devalued by About 41 Per Cent",
            "desc": "The government devalues the lira by about 41 per cent. The dollar rate goes from 11.22 to 19 lire. In September the United States, Great Britain and France signed the Tripartite Agreement.\n\nIndustrialists have accumulated large stocks of raw materials. The revaluation of the gold reserve brings the Bank of Italy and the Treasury a not inconsiderable bonus.",
            "picture": "vanilla:GFX_report_event_generic_stock_traders",
            "factSheet": "lira_devaluation_1936",
            "anchors": [
                "41 per cent",
                "11.22",
                "Tripartite Agreement"
            ],
            "fire": {
                "after": "1936.10.5",
                "before": "1936.12.15",
                "chance": 20,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
            },
            "options": [
                {
                    "name": "Reassure the savers.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "The gold bonus goes to the Treasury.",
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
            "id": 7,
            "key": "axis_protocol_october",
            "title": "Italy and Germany Conclude a Protocol",
            "desc": "Ciano met von Neurath on 21 October. On 23 October Italy and Germany concluded a protocol. Its terms are not made public.\n\nThe protocol states: 'Communism is the greatest danger threatening the peace and the security of Europe.' Italy undertakes to support the restoration of Germany's colonies. Mussolini said: 'this vertical axis Berlin-Rome is not a diaphragm, but rather an axis.'",
            "picture": "vanilla:GFX_report_event_german_italian_pact",
            "factSheet": "axis_protocol_october",
            "anchors": [
                "von Neurath",
                "23 October",
                "axis"
            ],
            "fire": {
                "after": "1936.11.2",
                "before": "1937.3.1",
                "chance": 20,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini } GER = { has_government = fascism }"
            },
            "options": [
                {
                    "name": "Say nothing of the terms.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Let Berlin know what Italy expects in return.",
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
                "trigger": "has_global_flag = spanish_civil_war NOT = { has_global_flag = scw_over } any_country = { has_idea = SPA_death_before_surrender has_volunteers_amount_from = { tag = ROOT count > 0 } }"
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
            "id": 9,
            "key": "pirandello_death",
            "title": "Luigi Pirandello Dies in Rome",
            "desc": "Luigi Pirandello, the playwright, has died in Rome of pneumonia at 69. A member of the Italian Academy, he died alone in his home at Via Bosio. In 1934 he was awarded the Nobel Prize for Literature, and he later gave the medal to the Fascist government to be melted down.\n\nHe was finishing a volume to be called Memories of My Involuntary Sojourn on Earth. How does the government mark the death of a Nobel laureate?",
            "picture": "pirandello_study",
            "factSheet": "pirandello_death",
            "anchors": [
                "Via Bosio",
                "Nobel Prize",
                "Italian Academy"
            ],
            "fire": {
                "after": "1936.12.10",
                "before": "1937.2.1",
                "chance": 30,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
            },
            "options": [
                {
                    "name": "Send a government wreath to Via Bosio.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Leave the arrangements to his family.",
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
            "id": 10,
            "key": "cinecitta_opens",
            "title": "Cinecittà Opens With Mussolini",
            "desc": "Mussolini and Giacomo Paulucci di Calboli inaugurate Cinecittà. In 1935 a vast fire destroyed the studios of the Cines company. The new complex, designed by the architect Gino Peressutti, has 73 buildings and covers 400,000 square metres.\n\nWho will be first on the new stages?",
            "picture": "cinecitta_1937",
            "factSheet": "cinecitta_opens",
            "anchors": [
                "Gino Peressutti",
                "73 buildings",
                "Cines"
            ],
            "fire": {
                "after": "1937.4.28",
                "before": "1937.6.30",
                "chance": 20,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini }"
            },
            "options": [
                {
                    "name": "Open the stages to every producer.",
                    "ai": 50,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Reserve the best stages for state films.",
                    "ai": 50,
                    "effects": [
                        {
                            "political_power": 25
                        }
                    ]
                }
            ]
        },
        {
            "id": 11,
            "key": "easter_accords",
            "title": "Britain and Italy Conclude the Easter Accords",
            "desc": "Britain and Italy have concluded the Easter Accords. The two governments undertake to observe the order in the Mediterranean and to uphold the freedom of navigation in the Suez Canal.\n\nEthiopia is not named in the agreements. How does Rome present them?",
            "picture": "vanilla:GFX_report_event_generic_sign_treaty2",
            "factSheet": "easter_accords",
            "anchors": [
                "Mediterranean",
                "Suez Canal",
                "Ethiopia"
            ],
            "fire": {
                "after": "1938.4.16",
                "before": "1938.11.30",
                "chance": 15,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } ENG = { exists = yes } has_country_flag = ITA_victory_in_ethiopia_flag"
            },
            "options": [
                {
                    "name": "A sound basis for the Mediterranean.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Ethiopia is not named, and that is enough for us.",
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
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini } GER = { has_government = fascism has_country_leader = { character = GER_adolf_hitler } }"
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
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
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
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
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
                "trigger": "NOT = { country_exists = ALB } 44 = { is_owned_by = ROOT } has_character = ITA_vittorio_emanuele_iii"
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
            "id": 16,
            "key": "mirafiori_opening",
            "title": "Mussolini Inaugurates Mirafiori",
            "desc": "On 15 May Mussolini inaugurated the Fiat plant at Mirafiori. Flanked by Giovanni Agnelli and Achille Starace, he spoke from a prepared platform to about 50,000 Fiat workers. The plant is to be built on an area of a million square metres and, by the programme, to employ over 22,000 workers in two shifts.\n\nThe Duce was received coldly, without great enthusiasm. How should the press report it?",
            "picture": "mirafiori_aerial",
            "factSheet": "mirafiori_opening",
            "anchors": [
                "Mirafiori",
                "Giovanni Agnelli",
                "22,000"
            ],
            "fire": {
                "after": "1939.5.15",
                "before": "1939.7.1",
                "chance": 40,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } } has_country_leader = { character = ITA_benito_mussolini }"
            },
            "options": [
                {
                    "name": "Print the speech and leave out the cold reception.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": 20
                        }
                    ]
                },
                {
                    "name": "Ask Agnelli how the workers feel.",
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
            "key": "coffee_sugar_rationing",
            "title": "Coffee and Sugar Are Rationed",
            "desc": "Coffee is on the market again from 1 February. It is rationed at 0.6 kilograms a year, already prepared. Sugar is also to be rationed, at 6 kilograms a year per head.\n\nThe import and sale of coffee were suspended in October. Coffee imports amounted in 1938 to 36,000 tons. How is the ration to be run?",
            "picture": "vanilla:GFX_report_event_generic_factory",
            "factSheet": "coffee_sugar_rationing",
            "anchors": [
                "0.6 kilograms",
                "6 kilograms",
                "36,000 tons"
            ],
            "fire": {
                "after": "1940.2.1",
                "before": "1940.5.31",
                "chance": 15,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
            },
            "options": [
                {
                    "name": "Explain the ration in the newspapers.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Let the grocers hand it out themselves.",
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
            "id": 18,
            "key": "giro_1940_coppi",
            "title": "Coppi Takes the Pink Jersey",
            "desc": "Coppi, at his first Giro d'Italia, won the eleventh stage alone on 29 May, from Florence to Modena, and took the pink jersey. The race runs in twenty stages from 17 May to 9 June.\n\nBartali fell on the descent of the Passo della Scoffera during the second stage and dropped out of the classification. Whom will the papers back now?",
            "picture": "coppi_bartali_1940",
            "factSheet": "giro_1940_coppi",
            "anchors": [
                "Coppi",
                "Scoffera",
                "Modena"
            ],
            "fire": {
                "after": "1940.5.29",
                "before": "1940.6.9",
                "chance": 60,
                "trigger": "NOT = { any_enemy_country = { NOT = { original_tag = ETH } } }"
            },
            "options": [
                {
                    "name": "Let the papers cheer the new leader.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Wait for the end of the race.",
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
            "key": "british_somaliland_1940",
            "title": "Aosta Urges Haste on British Somaliland",
            "desc": "In East Africa, about 24,000 Italian and colonial troops face 4,507 British and Commonwealth troops in British Somaliland.\n\nAosta and his deputy, General Guglielmo Nasi, have completed an appreciation of the likely opposition. Aosta urges haste, but Nasi refuses to rush because the road is deteriorating. Which of them do we back?",
            "picture": "vanilla:GFX_report_event_african_soldiers",
            "factSheet": "british_somaliland_1940",
            "anchors": [
                "Aosta",
                "Nasi",
                "24,000",
                "4,507"
            ],
            "fire": {
                "after": "1940.1.1",
                "before": "1945.1.1",
                "chance": 15,
                "trigger": "has_war_with = ENG has_country_flag = ITA_victory_in_ethiopia_flag 271 = { is_controlled_by = ROOT } 269 = { is_owned_by = ENG is_controlled_by = ENG }"
            },
            "options": [
                {
                    "name": "Order the advance without delay.",
                    "ai": 55,
                    "effects": [
                        {
                            "army_experience": 5
                        }
                    ]
                },
                {
                    "name": "Let Nasi take the time he needs.",
                    "ai": 45,
                    "effects": [
                        {
                            "political_power": 15
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
                "trigger": "has_war_with = ENG 849 = { is_controlled_by = ROOT } has_navy_size = { size > 1 unit = battleship } ENG = { has_navy_size = { size > 0 unit = carrier } }"
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
    ],
    "ideas": []
}
```
