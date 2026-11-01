# France pack: the first events

Status: DONE
Pack: france (FRA, namespace ep_fra)
Kind: new pack
Created: 2026-11-01

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/france/events.json`, the `markdown fact-sheets` block holds the sections for `source/france/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

## Context

The first round of events for the France pack. The pack's skeleton (`source/france/`, `packs/france/`, descriptor, namespace `ep_fra`, placeholder thumbnail, registration in `tools/HoiModBuild.json`) was made with `build.ps1 -NewPack -Pack france -Tag FRA -DisplayName "France"` on 2026-11-01, and `source/france/workshop-intro.bbcode` was written then; the pack has no events yet. Written by the `event-pack-create` skill.

Correction round (2026-11-01). The plan was implemented once (all checks passed), but the `ep-reviewer` found facts its sources did not support: the dossier's "[via search summary]" facts had entered the fact sheets untagged and unread. On the owner's word the planner reopened the plan: four `ep-audit-researcher` batches and two follow-ups opened every cited page, and the `markdown fact-sheets` block now holds only facts read on a live page (sources replaced where the cited page was dead or silent). Every event text was rewritten on those facts; the Syria picture's PD-self licence did not hold, so that event uses a vanilla picture. Steps 1 to 8 run again from the start; step 2 replaces every section of `source/france/fact-sheets.md`.

Re-review fixes (2026-11-01, owner: "Fix, then ship"). The second `ep-reviewer` pass returned Ready with three Minor over-readings, fixed here: louvre_evacuation_1939 (the page gives no date for the Chambord transport, so 'In August' is cut), polish_army_in_france_1939 (its sources give 2 or 20 December for Raczkiewicz at Pignerolle: the text drops the date and the window opens 1939.12.21), royal_visit_1938 (the Queen was not at the Versailles parade: 'before the King'). Steps 3 to 5 stand from the implementation (no picture or thumbnail changes); steps 1, 2 and 6 to 8 run again.

## Decisions

Owner's answers, 2026-11-01:
- Country: France, tag `FRA` (confirmed with `Get-HoiCountry`: `common/country_tags/00_countries.txt:5`). Ruling party at start: democratic (`history/countries/FRA - France.txt:424`).
- Period: 1936 to spring 1940: peacetime 1936 to August 1939, then the declaration of war and the Phoney War, stopping before the German offensive of 10 May 1940.
- Number of events: 20.
- Kinds: all four, in balance: politics and society; military and defence; culture and everyday life; empire and diplomacy.
- Excluded: topics vanilla France already stages, so the pack fires no duplicate. Events: the Matignon strikes (`france.21` to `france.23`), the Maginot and Alpine Line extensions (`france.2`, `france.3`), Daladier's resignation (`france.31`), Japan's demand on Indochina (`france.1`), the Franco-British union (`france.11` to `france.13`), the London Conference (`france.25`, `france.26`), political violence and right-wing riots (`lar_france_political_violence`), the Non-Intervention Committee (`lar_non_intervention`), the Franco-Soviet treaty (`lar_franco_soviet_treaty`), the worker shortage (`lar_worker_shortage`). Focuses (`common/national_focus/france.txt`): Form the Popular Front, Ban the Leagues, Reform the Labour Laws, the Blum-Viollette Proposal, Women's Suffrage, Devalue the Franc, Nationalize Key Industries, Autoroutes, Form the National Research Center, Arms Purchases in the US, Intervention in Spain, Host the German Exiles, Invite Anti-Fascist Immigrants, Support the Finns, Extend the Maginot Line, Alpine Forts, Slum Clearing, Public Welfare, Support the Grandes Écoles, Reorganize the Aviation Industry. Decisions (`common/decisions/FRA.txt`): Revoke the Matignon Agreements, Rally the Leagues, Unleash La Cagoule, the US arms orders, the Spanish intervention decisions.
- Events chosen (owner, 2026-11-01), the 20 recommended from `research/france/2026-11-01-dossier.md`: salengro_affair, marseille_nouvelles_galeries_fire, family_code_1939, alsace_evacuation_1939, pcf_dissolution_1939, richelieu_launch_1939, phenix_submarine_loss, bastille_day_1939, saar_offensive_1939, george_vi_front_visit_dec_1939, expo_1937, mermoz_disappearance, world_cup_1938, cannes_festival_1939, louvre_evacuation_1939, heavy_water_1940, transindochinois_1936, syria_lebanon_treaties_1936, royal_visit_1938, polish_army_in_france_1939. Dropped before the choice for overlap with vanilla: rhineland_march_1936 (`germany.60`, `news.25`), munich_return_1938 (`germany.40` chain), alexandrette_transfer_1939 (`bftb_turkey.25` to `.27`), poland_guarantee_1939 (a player's guarantee in vanilla). Dropped as unverified or too thin to fill 40 words: school_leaving_age_14, married_women_capacity_1938, blum_pause_1937, de_gaulle_memorandum_1940, normandie_blue_riband, meknes_water_riots_1937, italian_claims_1938_daladier_tour, belgian_neutrality_1936, franco_german_declaration_1938, partial_mobilisation_1938. Kept in the dossier for a later round: weidmann_last_public_execution, defence_loan_1937, tour_de_france_1937, pourquoi_pas_wreck, grande_illusion_1937, television_paris_1939, greenland_crossing_1936, citroen_tpv_1939, tunisia_april_1938.
- cannes_festival_1939 fires on Germany's war with Poland, whether or not France is at war yet (no `has_war = no`).
- Wartime events (alsace_evacuation_1939, pcf_dissolution_1939, saar_offensive_1939, george_vi_front_visit_dec_1939, polish_army_in_france_1939, heavy_water_1940) fire only while France is at war with Germany; the peacetime ones only while France is not.
- Pictures (correction round, 2026-11-01): syria_lebanon_treaties_1936 uses vanilla `GFX_report_event_generic_sign_treaty1`, as its Commons file's PD-self licence cannot hold for a 1936 photograph and no validly licensed file was found.
- Pictures (owner, 2026-11-01): keep the three pictures that are public domain in the United States only: the US Navy photograph of the Richelieu (1943), the Croix-du-Sud postcard and the 1938 Thorez portrait.
- Fact quotes (owner, 2026-11-01): the Manager's new rule asks a `Quote:` from the source page on every fact-sheet line. France's fact sheets were rechecked on their pages in the correction round but carry no quotes, so `events.json` sets `factQuotesFromId: 21`, exempting all 20 events as Finland is exempted; `-Audit` warns until a later audit adds the quotes.
- Shipping (owner, 2026-11-01): after the Manager session commits its tool, skill and agent changes; the France commit holds only the France files and the pack registration in `tools/HoiModBuild.json`.
- Effects: no political-power swings. The effects stay with stability, war support and short timed ideas; political power appears in no option, and no idea uses `political_power_gain` or `political_power_factor`.

## Events

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 1 | transindochinois_1936 | The Transindochinois Is Joined at Hao Son | 1936.10.2 to 1936.11.30 | 50 | transindochinois_1936 | idea transindochinois_traffic 120d / stability +0.02 |
| 2 | syria_lebanon_treaties_1936 | Viénot Signs a Treaty with Syria | 1936.9.9 to 1936.11.15 | 25 | vanilla GFX_report_event_generic_sign_treaty1 | stability +0.02 / war support +0.01 |
| 3 | salengro_affair | Interior Minister Salengro Takes His Own Life | 1936.11.23 to 1937.1.15 | 50 | salengro_affair | stability +0.02 / stability +0.01, war support +0.01 |
| 4 | mermoz_disappearance | Mermoz and the Croix-du-Sud Lost at Sea | 1936.12.14 to 1937.1.31 | 50 | mermoz_disappearance | war support +0.02 / stability +0.02 |
| 5 | expo_1937 | President Lebrun Opens the Paris Exposition | 1937.5.31 to 1937.8.31 | 25 | expo_1937 | stability +0.02 / idea palais_de_la_decouverte 180d |
| 6 | world_cup_1938 | Italy Puts France Out of the World Cup | 1938.6.13 to 1938.7.15 | 50 | world_cup_1938 | stability +0.02 / war support +0.02 |
| 7 | royal_visit_1938 | King George VI and Queen Elizabeth in Paris | 1938.7.22 to 1938.8.31 | 50 | royal_visit_1938 | war support +0.02 / stability +0.02 |
| 8 | marseille_nouvelles_galeries_fire | Fire at the Nouvelles Galeries Kills 73 in Marseille | 1938.10.29 to 1938.12.15 | 50 | marseille_nouvelles_galeries_fire | stability +0.02 / stability +0.01 |
| 9 | richelieu_launch_1939 | The Battleship Richelieu Is Launched at Brest | 1939.1.17 to 1939.3.31 | 25 | richelieu_launch_1939 | war support +0.02 / stability +0.01 |
| 10 | phenix_submarine_loss | The Submarine Phénix Is Lost off Cam Ranh | 1939.6.16 to 1939.7.31 | 50 | phenix_submarine_loss | stability +0.02 / war support +0.01 |
| 11 | bastille_day_1939 | British Guards March in the 14 July Parade | 1939.7.14 to 1939.8.15 | 100 | bastille_day_1939 | war support +0.02 / stability +0.02 |
| 12 | family_code_1939 | A Family Code Rewards the First Child | 1939.7.29 to 1939.8.31 | 50 | vanilla GFX_report_event_generic_read_write | idea family_code 180d / stability +0.01 |
| 13 | louvre_evacuation_1939 | The Louvre Sends Its Collections to Chambord | 1939.8.31 to 1939.9.30 | 100 | louvre_evacuation_1939 | war support +0.02 / stability +0.02 |
| 14 | cannes_festival_1939 | The First Cannes Film Festival Is Called Off | 1939.9.1 to 1939.9.10 | 100 | cannes_festival_1939 | stability +0.01 / stability +0.02, war support -0.01 |
| 15 | alsace_evacuation_1939 | Civilians Evacuated from Alsace and Moselle | 1939.10.18 to 1939.12.31 | 50 | alsace_evacuation_1939 | idea evacuee_relief 120d / war support +0.01 |
| 16 | saar_offensive_1939 | The Army Is Ordered Back Behind the Maginot Line | 1939.10.4 to 1939.11.30 | 50 | saar_offensive_1939 | stability +0.02 / war support +0.02 |
| 17 | polish_army_in_france_1939 | The Polish Government Settles at Angers | 1939.12.21 to 1940.2.28 | 50 | polish_army_in_france_1939 | war support +0.02 / stability +0.01 |
| 18 | pcf_dissolution_1939 | The Communist Party Is Banned | 1939.10.9 to 1939.12.31 | 50 | pcf_dissolution_1939 | war support +0.02 / stability +0.02 |
| 19 | george_vi_front_visit_dec_1939 | King George VI Visits the Armies in France | 1939.12.10 to 1940.2.15 | 50 | george_vi_front_visit_dec_1939 | war support +0.02 / stability +0.01 |
| 20 | heavy_water_1940 | Norway's Heavy Water Reaches the Collège de France | 1940.4.1 to 1940.5.9 | 100 | heavy_water_1940 | idea joliot_curie_laboratory 180d / war support +0.01 |

## Pictures

Every row passed `build.ps1 -FetchPicture ... -DryRun` while planning; the licence column is what it printed.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|
| transindochinois_1936 | `File:Tonkin - Đáp Cầu, 1901 - Un train entrant dans la gare de la ville, Établissements Weidknecht 2-6-0T locomotive No 656 (Coll. Tim Doling, Flickr 50124447903).jpg` | PD (Public domain), 2000x1448, Unknown author | 35 | warm | transindochinois_1936 (a Tonkin train of about 1901-1910, not the 1936 line) |
| (vanilla) | `vanilla:GFX_report_event_generic_sign_treaty1` | vanilla | | | syria_lebanon_treaties_1936 (the Commons file first chosen, `File:The National Bloc signing the FrancoSyrian Treaty.jpg`, carries a PD-self "own work" tag that cannot hold for a 1936 photograph; no validly licensed file was found) |
| salengro_affair | `File:Les obsèques de M. Salengro ; ministre de l'Intérieur - la foule venue assister aux obsèques - btv1b90454611.jpg` | PD (Public domain), 7000x5209, Agence de presse Meurisse | 50 | warm | salengro_affair |
| mermoz_disappearance | `File:La Croix-du-Sud.jpg` | PD (Public domain), 1746x1230, Anonymous | 30 | warm | mermoz_disappearance (postcard art of the Croix-du-Sud, F-AKGF) |
| expo_1937 | `File:Exposition Internationale des Arts et Techniques dans la Vie Moderne (Paris-1937).jpg` | PD (Public domain), 800x485, auteur inconnu - éditeur La Photolith | 100 | none | expo_1937 (colour postcard; crop 100 keeps the German pavilion at the left edge out) |
| world_cup_1938 | `File:Début de France - Italie à Colombes, en coupe du monde de football 1938.jpg` | PD (Public domain), 1183x867, unspecified | 60 | warm | world_cup_1938 |
| royal_visit_1938 | `File:Interieur van een paleis in Parijs, waarschijnlijk de kamer waar koning George V, Bestanddeelnr 254-2655.jpg` | CC0 (CC0), 3453x2508, Willem van de Poll | 50 | warm | royal_visit_1938 (the room prepared for the King, July 1938; no photo of the couple in Paris on Commons) |
| marseille_nouvelles_galeries_fire | `File:Ruines fumantes des Nouvelles Galeries dans Paris-Soir du 30 octobre 1938.png` | PD (Public domain), 1080x735, Unknown | 0 | warm | marseille_nouvelles_galeries_fire (crop 0 keeps the newspaper headline at the right mostly out) |
| richelieu_launch_1939 | `File:French battleship Richelieu at anchor on 7 September 1943 (80-G-204842).jpg` | PD (Public domain), 2514x1885, U.S. Navy photo 80-G-204842 | 45 | warm | richelieu_launch_1939 (the ship in 1943, not the launch) |
| phenix_submarine_loss | `File:Photograph of French submarine Phénix in Toulon (cropped).png` | PD (Public domain), 2729x1341, Le Nouvelliste d'Indochine | 50 | warm | phenix_submarine_loss |
| bastille_day_1939 | `File:Revue du 14 juillet 1936, défilé des troupes coloniales.jpg` | PD (Public domain), 7000x5225, Agence de presse Meurisse | 50 | warm | bastille_day_1939 (the 14 July 1936 parade; no Paris photo of 1939 on Commons) |
| louvre_evacuation_1939 | `File:Cadres vides après l’évacuation du musée du Louvre en 1939.jpg` | PD (Public domain), 1024x849, Unknown author | 50 | warm | louvre_evacuation_1939 (the title has a typographic apostrophe) |
| cannes_festival_1939 | `File:La Croisette de Cannes dans les années 1930 (A).jpg` | PD (Public domain), 2023x1285, Unknown author | 40 | none | cannes_festival_1939 (colour postcard) |
| alsace_evacuation_1939 | `File:Evacuation de Strasbourg septembre 1939 03.jpg` | PD (Public domain), 297x450, Inconnu septembre 1939 | 0 | warm | alsace_evacuation_1939 (the 'Ordre d'évacuation' poster; crop 0 keeps its headline) |
| saar_offensive_1939 | `File:French soldiers on Maginot Line.jpg` | PD (Public domain), 500x314, Unknown author | 50 | warm | saar_offensive_1939 |
| polish_army_in_france_1939 | `File:Wizyta Naczelnego Wodza gen. Władysława Sikorskiego w obozie w Coetquidan NAC 18-242.jpg` | PD (Public domain), 3500x2550, Czesław Datka | 50 | warm | polish_army_in_france_1939 |
| pcf_dissolution_1939 | `File:Maurice Thorez 1938.jpg` | PD (Public domain), 1525x1844, Young Communist League | 30 | warm | pcf_dissolution_1939 |
| george_vi_front_visit_dec_1939 | `File:The British Expeditionary Force (bef) in France 1939-1940 O1795.jpg` | PD (Public domain), 800x607, War Office official photographer | 60 | warm | george_vi_front_visit_dec_1939 (the King with French generals at Amiens) |
| heavy_water_1940 | `File:Irène et Frédéric Joliot-Curie 1935.jpg` | PD (Public domain), 1334x914, Agence de presse Meurisse | 50 | warm | heavy_water_1940 |
| (vanilla) | `vanilla:GFX_report_event_generic_read_write` | vanilla | | | family_code_1939 (no Commons file found; vanilla has no family picture) |

Thumbnail: bastille_day_1939 (PD, Agence Meurisse; crop center). Flag `FRA_democratic.tga`; colours sampled from it: `#FF0000`, `#000066`, `#FFFFFF`; main colour `#000066` (the flag's blue), text colour `#FFFFFF`.

## Editor record

Round 1 (2026-11-01), all 20 events and the five ideas: 8 KEEP (richelieu_launch_1939, phenix_submarine_loss, family_code_1939, alsace_evacuation_1939, saar_offensive_1939, polish_army_in_france_1939, pcf_dissolution_1939, heavy_water_1940), 12 REWRITE, 0 REJECT. Every REWRITE applied as given: transindochinois_1936 (gala and stamp cut as predictions), syria_lebanon_treaties_1936 (Lebanon sentence cut), salengro_affair (date and past tense, 'funeral' not 'buried', 'for weeks' cut), mermoz_disappearance (option: no mail service in the fact sheet), expo_1937 (fountains and tower cut, 'set up by'), world_cup_1938 (quarter-final venue not sourced; first match against the world champions added), royal_visit_1938 ('travelled on the Seine'), marseille_nouvelles_galeries_fire (title: store not said destroyed; 'judged insufficient'), bastille_day_1939 (Saint-Marcet padding cut; option was a 'not X but Y'), louvre_evacuation_1939 (staff and packing cut; 'go to Valençay'), cannes_festival_1939 (prize and 'Hollywood stars' as sourced), george_vi_front_visit_dec_1939 (Gamelin's return visit undated, cut). Ideas: transindochinois_traffic and family_code rewritten as given. On the editor's notes the planner also changed: marseille option 2 effect war support to stability; george_vi option 2 reworded ('Good. Now give the men some rest.', stability) as the complaint did not fit stability; transindochinois_traffic modifier from building speed to factory efficiency.

Round 2 (2026-11-01), the 12 rewritten events, the planner's three changes and the two rewritten ideas: 11 KEEP, 3 REWRITE, 0 REJECT. Applied as given: world_cup_1938 ('the world champions' said twice), george_vi_front_visit_dec_1939 option 2 ('Good. Now send the men home on leave.', stability fits the home front), idea family_code (name 'Code de la famille', as in the event). The planner's changes to marseille option 2, george_vi option 2 effect and transindochinois_traffic were accepted. On the editor's notes: cannes_festival_1939's window narrowed to 1939.9.1 to 1939.9.10, so the text about 1 September cannot fire after a later invasion; marseille's two options both stay on stability (0.02 and 0.01), as blaming the city has no fitting effect among those allowed; transindochinois_traffic keeps factory efficiency, as `data/effect-caps.json` lists no resources modifier.

Round 3 (2026-11-01), world_cup_1938, george_vi_front_visit_dec_1939, the idea family_code and cannes_festival_1939 (new window): 3 KEEP, 1 REWRITE (cannes_festival_1939), 0 REJECT. Applied as given: the cancellation sentence loses its date ('The festival has been cancelled after the invasion of Poland.'), true whatever day the invasion comes inside the window; the anchor '1 September' removed. cannes_festival_1939 has no `has_war = no` on purpose: France is at war from 3 September inside its window. The three rounds allowed were used; the owner accepted the round-3 rewrite of cannes_festival_1939 as final (2026-11-01).

Correction round, editor round 1 (2026-11-01), all 20 events and the five ideas on the rechecked fact sheets: 10 KEEP (salengro_affair, mermoz_disappearance, expo_1937, world_cup_1938, marseille_nouvelles_galeries_fire, family_code_1939, louvre_evacuation_1939, cannes_festival_1939, pcf_dissolution_1939, george_vi_front_visit_dec_1939), 10 REWRITE, 0 REJECT; ideas 3 KEEP, 2 REWRITE (evacuee_relief, joliot_curie_laboratory). Every REWRITE applied as given: transindochinois_1936 (modern province cut; the monument introduced), syria_lebanon_treaties_1936 (Atassi was not yet president; 'separate' cut), royal_visit_1938 (gala not said to end the day), richelieu_launch_1939 (the recording dated the day before is not the launch speech; anchor César Campinchi removed), phenix_submarine_loss (the toll, not 'all men'), bastille_day_1939 (tirailleurs not counted in the 30,000; 'Gort' as the section writes him; anchor Lord Gort removed), alsace_evacuation_1939 (not 'the' civilians of three departments), saar_offensive_1939 (title: the withdrawal was a decision; 'took the Warndt'), polish_army_in_france_1939 ('created'; Władysław Sikorski without a rank in the sheet), heavy_water_1940 (no 'banker', no bank sentence, no join of shipment and canisters, 'went into' the cellars, canisters not drums). Planner's changes on the editor's notes: expo_1937 window now opens 1937.5.31, so 'inaugurated right after' holds on any day; the syria fact sheet line no longer calls Atassi 'the Syrian president' (he was elected in December 1936).

Correction round, editor round 2 (2026-11-01), the ten round-1 rewrites, two ideas and the planner's two changes: 11 KEEP, 2 REWRITE (option lines only), 0 REJECT; the planner's changes accepted. Applied as given: transindochinois_1936 option 2 'Well done to both construction teams.' (the sheet never calls the place a colony), phenix_submarine_loss option 2 'The manoeuvres go on.' (no fleet or Indochina in the sheet).

Correction round, editor round 3 (2026-11-01), the two option lines: 2 KEEP. Every event now stands at KEEP in its latest round.

Re-review fixes, editor round 1 (2026-11-01): polish_army_in_france_1939 KEEP; louvre_evacuation_1939 and royal_visit_1938 REWRITE, applied as given (no tense that claims the lorries were running on a given day; 'they lunched' read as the 50,000 men, and the sheet names no diner).

Re-review fixes, editor round 2 (2026-11-01): louvre_evacuation_1939 and royal_visit_1938 KEEP. Every event stands at KEEP in its latest round.

## Kept on judgment

- `[WARN] picture richelieu_launch_1939: public domain in the United States only (PD-USGov-Military-Navy); the owner decides before a release`: the owner kept the US Navy photograph on 2026-11-01.
- `[WARN] picture mermoz_disappearance: public domain in the United States only (PD-US); the owner decides before a release`: the owner kept the Croix-du-Sud postcard on 2026-11-01.
- `[WARN] picture pcf_dissolution_1939: public domain in the United States only (PD-US-no notice); the owner decides before a release`: the owner kept the 1938 Thorez portrait on 2026-11-01.

Rehearsal (2026-11-01, correction round, `scratch\rehearsal` mirrored from the implemented tree): steps 1 to 7 as written; 18 pictures `ACCEPTED` and recorded, `pictures converted=18 up_to_date=0 failed=0` with `removed unused ep_fra_syria_lebanon_treaties_1936.dds`, `Generated pack 'france': 20 event(s), 15 file(s) written, 0 removed.`, `Check OK: 1 pack(s), 4 warning(s).` (the three above plus the unused Syria row, since removed by step 5a). Re-review fixes rehearsed the same day: steps 1, 2, 6 and 7 as written, with `factQuotesFromId: 21` against the Manager's new quote rule: `Generated pack 'france': 20 event(s), 12 file(s) written, 0 removed.`, `Check OK: 1 pack(s), 4 warning(s).` With step 5a (the Manager's new `-RemovePicture`, dry run as shown there) the Syria warning goes, leaving the three above.

## Implementation steps

- [x] 1. Write the events: replace `source/france/events.json` with the `json events` block below, whole.
- [x] 2. Write the fact sheets: add each section of the `markdown fact-sheets` block below to `source/france/fact-sheets.md`, replacing a section of the same key.
- [x] 3. Fetch the pictures, one command per row of the picture table, each expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Tonkin - Đáp Cầu, 1901 - Un train entrant dans la gare de la ville, Établissements Weidknecht 2-6-0T locomotive No 656 (Coll. Tim Doling, Flickr 50124447903).jpg" -Key transindochinois_1936 -Crop 35 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Les obsèques de M. Salengro ; ministre de l'Intérieur - la foule venue assister aux obsèques - btv1b90454611.jpg" -Key salengro_affair -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:La Croix-du-Sud.jpg" -Key mermoz_disappearance -Crop 30 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Exposition Internationale des Arts et Techniques dans la Vie Moderne (Paris-1937).jpg" -Key expo_1937 -Crop 100 -Tone none`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Début de France - Italie à Colombes, en coupe du monde de football 1938.jpg" -Key world_cup_1938 -Crop 60 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Interieur van een paleis in Parijs, waarschijnlijk de kamer waar koning George V, Bestanddeelnr 254-2655.jpg" -Key royal_visit_1938 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Ruines fumantes des Nouvelles Galeries dans Paris-Soir du 30 octobre 1938.png" -Key marseille_nouvelles_galeries_fire -Crop 0 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:French battleship Richelieu at anchor on 7 September 1943 (80-G-204842).jpg" -Key richelieu_launch_1939 -Crop 45 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Photograph of French submarine Phénix in Toulon (cropped).png" -Key phenix_submarine_loss -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Revue du 14 juillet 1936, défilé des troupes coloniales.jpg" -Key bastille_day_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Cadres vides après l’évacuation du musée du Louvre en 1939.jpg" -Key louvre_evacuation_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:La Croisette de Cannes dans les années 1930 (A).jpg" -Key cannes_festival_1939 -Crop 40 -Tone none`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Evacuation de Strasbourg septembre 1939 03.jpg" -Key alsace_evacuation_1939 -Crop 0 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:French soldiers on Maginot Line.jpg" -Key saar_offensive_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Wizyta Naczelnego Wodza gen. Władysława Sikorskiego w obozie w Coetquidan NAC 18-242.jpg" -Key polish_army_in_france_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Maurice Thorez 1938.jpg" -Key pcf_dissolution_1939 -Crop 30 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:The British Expeditionary Force (bef) in France 1939-1940 O1795.jpg" -Key george_vi_front_visit_dec_1939 -Crop 60 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack france -File "File:Irène et Frédéric Joliot-Curie 1935.jpg" -Key heavy_water_1940 -Crop 50 -Tone warm`
- [x] 4. Make the thumbnail from the picture fetched in step 3, two commands (when "Thumbnail" says unchanged, this step reads `Thumbnail unchanged: nothing to run.`):
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\france\bastille_day_1939.*).FullName --bg-crop center --title "EVENT PACK" --subtitle "FRANCE" --flag-tag FRA --flag-variant democratic --game-dir "C:\Gaming\Steam\steamapps\common\Hearts of Iron IV" --theme "#000066" --banner --banner-color "#000066" --text-color "#FFFFFF" --accent-color "#FFFFFF" --text-pos top --hoi4 --json --out-dirs "scratch\thumbnail\france"`: expect `"status": "success"`, `"workshop_limit_exceeded": false` and an `"overlay_source"` naming the flag file.
  - `Copy-Item scratch\thumbnail\france\thumbnail.png packs\france\thumbnail.png`
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack france`: expect `failed=0`.
- [x] 5a. `powershell -File .\build.ps1 -RemovePicture -Pack france -Key syria_lebanon_treaties_1936`: expect it to remove that row (the 1936 Syria photograph whose PD-self licence did not hold; no event uses it). Dry run: `Dry run: would remove 'syria_lebanon_treaties_1936' (File:The National Bloc signing the FrancoSyrian Treaty.jpg)`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack france`: expect `Generated pack 'france'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack france`: expect `Check OK`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 9. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(france): the first 20 events of the France pack`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

First implementation (2026-11-01), superseded by the correction round: 2026-11-01. Steps 1 to 8 run as written; 19 pictures `ACCEPTED`, `pictures converted=19 up_to_date=0 failed=0`, `Generated pack 'france': 20 event(s), 16 file(s) written, 0 removed.`, `Check OK: 1 pack(s), 3 warning(s).` (the three listed in "Kept on judgment"), `-ValidateOnly` `Validation succeeded.`, `-Test` 191 passed, 0 failed. Step 9 (ship) is left to the caller. No deviation.

Correction round (2026-11-01): steps 1 to 8 run as written. 18 pictures `ACCEPTED`, `pictures converted=18 up_to_date=0 failed=0` (removed unused ep_fra_syria_lebanon_treaties_1936.dds), `Generated pack 'france': 20 event(s), 15 file(s) written, 0 removed.`, `Check OK: 1 pack(s), 4 warning(s).` (the four listed in "Kept on judgment"), `-ValidateOnly` `Validation succeeded.`, `-Test` 191 passed, 0 failed. Step 9 (ship) is left to the caller. No deviation. The fact-sheets file was rewritten whole (header plus the 20 sections) as every section is replaced; the louvre_evacuation_1939 heading follows the previous section without a blank line, as in the plan block.

Re-review fixes (2026-11-01): steps 1, 2, 5a, 6, 7 and 8 run as written (steps 3 to 5 stood). `-RemovePicture` removed the `syria_lebanon_treaties_1936` row and its cached file, `Generated pack 'france': 20 event(s), 12 file(s) written, 0 removed.`, `Check OK: 1 pack(s), 3 warning(s).` (the three listed in "Kept on judgment"), `-ValidateOnly` `Validation succeeded.`, `-Test` 205 passed, 0 failed. Step 9 (ship) is left to the caller. No deviation. The fact-sheets file was rewritten whole (header plus the 20 sections), the louvre_evacuation_1939 heading again following the previous section without a blank line, as in the plan block.

## Fact sheets

```markdown fact-sheets
## transindochinois_1936

- On 2 September 1936 the two construction teams of the Transindochinois met at Hao Son (Hảo Sơn), at kilometre 1221 in today's Phu Yen (Phú Yên) province, where the final piece of rail was put in place; the monument there records the joining of the railway from the Chinese border with the railway of Saigon. Source: https://historicvietnam.com/80-years-of-the-transindochinois (80 years of the Transindochinois)
- On 1 October 1936 the Hao Son to Dai Lanh section opened to traffic, and Bao Dai (Bảo Đại) presided over the burial of ceremonial parchments at the monument. Source: https://historicvietnam.com/80-years-of-the-transindochinois (80 years of the Transindochinois)

## syria_lebanon_treaties_1936

- On 9 September 1936 Pierre Viénot and Hashim al-Atassi (Hachem el-Atassi) signed the Franco-Syrian treaty, which provided for Syrian independence and unity, with the end of the Druze and Alawite autonomies; France kept military facilities for 25 years. A Franco-Lebanese treaty followed on 13 November 1936. Source: https://www.lesclesdumoyenorient.com/Traites-franco-syrien-et-franco-libanais-de-1936.html (Traités franco-syrien et franco-libanais de 1936)
- The Syrian Parliament ratified the treaty; the French Parliament ratified neither treaty. Source: https://heritage.bnf.fr/bibliothequesorient/en/missed-opportunity-1936-franco-syrian-treaty (The Missed Opportunity of the 1936 Franco-Syrian Treaty) and the Les Clés du Moyen-Orient page above

## salengro_affair

- Roger Salengro, Minister of the Interior in Léon Blum's government, killed himself in Lille on 17 November 1936 (some sources give 18 November); L'Action française and Gringoire, whose director was Henri Béraud, had accused him of deserting during the Great War, and Gringoire kept up the attacks. Source: https://www.herodote.net/almanach-ID-2896.php (17 novembre 1936) and https://fr.wikipedia.org/wiki/Roger_Salengro (Roger Salengro)
- He left a letter to Léon Blum and one to his brother. Source: https://kartable.fr/ressources/histoire/personnages/la-republique-et-la-question-ouvriere-le-front-populaire-2/5820 (Kartable, Roger Salengro)
- His funeral was held in Lille on 22 November 1936. Source: https://fr.wikipedia.org/wiki/Roger_Salengro (Roger Salengro)

## mermoz_disappearance

- Jean Mermoz took off from Dakar for Natal on 7 December 1936 in the Latécoère 300 flying boat Croix-du-Sud (F-AKGF). He radioed that he had to cut the power on the aft starboard engine; no further messages were received, and neither the aircraft nor the crew were ever recovered. The crew were Mermoz, Alexandre Pichodou, Henri Ezan, Edgar Cruveilher and Jean Lavidalie. Source: https://en.wikipedia.org/wiki/Jean_Mermoz (Jean Mermoz)
- Mermoz, aged 34, and his crew disappeared at sea 800 km south of Dakar. Source: https://fr.wikipedia.org/wiki/1936_en_France (1936 en France)

## expo_1937

- The opening of the Exposition internationale des Arts et Techniques, planned for 1 May 1937, was postponed; President Albert Lebrun opened it on 24 May 1937, and the Palais de la Découverte, the Palais de Tokyo and the Palais de Chaillot were inaugurated right after. Source: https://fr.wikipedia.org/wiki/1937_en_France (1937 en France)
- The Palais de la Découverte was driven by Jean Perrin, a Nobel Prize-winning physicist, and installed in the west wing of the Grand Palais, the Palais d'Antin. Source: https://www.palais-decouverte.fr/en/palais/history-palais (History of the Palais) and https://fr.wikipedia.org/wiki/Palais_de_la_D%C3%A9couverte (Palais de la Découverte)
- Perrin received the Nobel Prize in Physics in 1926. Source: https://en.wikipedia.org/wiki/Jean_Baptiste_Perrin (Jean Baptiste Perrin)

## world_cup_1938

- The 1938 World Cup in France began with the round of 16 on 4 June 1938. Source: https://en.wikipedia.org/wiki/1938_FIFA_World_Cup_knockout_stage (1938 FIFA World Cup knockout stage)
- France beat Belgium 3-1 on 5 June at the Stade Olympique de Colombes. On 12 June Italy beat France 3-1 in the quarter-final at Colombes before more than 58,000 spectators: Colaussi scored in the 9th minute, Heisserer equalised in the 10th, and Piola scored in the 51st and 72nd. Source: https://rsssf.org/tables/38full.html (World Cup 1938 finals)

## royal_visit_1938

- King George VI and Queen Elizabeth made a state visit to France from 19 to 22 July 1938. Source: https://fr.wikipedia.org/wiki/1938_en_France (1938 en France)
- Programme: 19 July, a visit to the President of the Republic, a reception for the diplomatic corps at the Foreign Affairs palace, an official dinner at the Élysée and a performance with Sacha Guitry, Ninon Vallin and the Comédie-Française; 20 July, a reception at the Hôtel de Ville and the return to the Quai d'Orsay by the Seine, the Château de Bagatelle in the afternoon and a gala at the Opéra; 21 July, at Versailles, a parade of 50,000 men with an air display (the King and President Lebrun at Versailles from 11:00, the parade at 11:25; the Queen visited the British hospital at Levallois at 10:45 and took the 12:20 train to Versailles) and lunch in the Hall of Mirrors; 22 July, departure from Paris by the Gare des Invalides. Source: https://www.menustory.com/19-22-07-1938_visite-royale.html (Visite royale en France)

## marseille_nouvelles_galeries_fire

- The fire at the Nouvelles Galeries on the Canebière in Marseille on 28 October 1938 killed 73 people. Source: https://fr.wikipedia.org/wiki/1938_en_France (1938 en France) and https://en.wikipedia.org/wiki/Marseille_Naval_Fire_Battalion (Marseille Naval Fire Battalion)
- The fire broke out in the early afternoon. At the request of Rear Admiral Muselier, commanding the Navy at Marseille, the marins-pompiers of Toulon were sent as reinforcements; they arrived only from 5 pm, when the store was already lost. Source: https://madeinmarseille.net/24115-incendie-nouvelle-galerie-canebiere/ (Made in Marseille, the Nouvelles Galeries fire)

## richelieu_launch_1939

- The battleship Richelieu was laid down on 22 October 1935 in the No. 4 dock at Brest that had recently built the Dunkerque. Source: https://en.wikipedia.org/wiki/French_battleship_Richelieu (French battleship Richelieu)
- Built by the Brest arsenal, the Richelieu was launched on 17 January 1939. Source: https://boutique.aamm.fr/monographies/plan-cuirasse-richelieu (Le Richelieu)
- A recording dated 16 January 1939: 'Lancement à Brest du cuirassé français Richelieu, par M. César Campinchi, ministre de la marine'. Source: https://phonobase.org/en/fiche/12798 (Lancement à Brest du cuirassé français Richelieu)
- The Dunkerque was launched on 2 October 1935 and commissioned on 31 December 1936; her sister Strasbourg was launched on 12 December 1936. Source: https://en.wikipedia.org/wiki/Dunkerque-class_battleship (Dunkerque-class battleship)

## phenix_submarine_loss

- The submarine Phénix sank on 15 June 1939 in the South China Sea off Cam Ranh, during training manoeuvres with the light cruiser Lamotte-Picquet and aircraft, including a mock attack on the cruiser. The toll was 71 dead, 5 officers and 66 enlisted men. Source: https://en.wikipedia.org/wiki/French_submarine_Ph%C3%A9nix_(Q157) (French submarine Phénix (Q157))
- The Phénix was commissioned on 21 October 1932. Source: https://fr.wikipedia.org/wiki/Ph%C3%A9nix_(Q157) (Phénix (Q157))

## bastille_day_1939

- The 14 July 1939 parade marked the 150th anniversary of the taking of the Bastille. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- More than 30,000 soldiers took part, and British troops marched. Source: https://fr.wikipedia.org/wiki/D%C3%A9fil%C3%A9_militaire_du_14_Juillet (Défilé militaire du 14 Juillet)
- Detachments of the British Brigade of Guards and of the Royal Marines took part in the Bastille Day parade of 14 July 1939. Source: https://en.wikipedia.org/wiki/Bastille_Day_military_parade (Bastille Day military parade)
- Senegalese tirailleurs of the 24th regiment marched on the Champs-Élysées on 14 July 1939 (photograph caption). Source: https://www.roger-viollet.fr/image-photo/senegalese-skirmishers-from-the-24th-regiment-566162?lang=en (Senegalese skirmishers from the 24th regiment)
- Gamelin went to London to settle military cooperation between the two countries and met his counterpart John Gort on 9 June 1939. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)

## family_code_1939

- The Code de la famille, a decree-law of 29 July 1939, created a birth bonus for a first child born within two years of marriage, a family compensation tax on single people and heavier penalties for abortion. A separate decree-law of the same date temporarily limited the profits of firms working for national defence. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- The census of 8 March 1936 counted 41,911,530 inhabitants. Source: https://fr.wikipedia.org/wiki/1936_en_France (1936 en France)

## cannes_festival_1939

- Philippe Erlanger, Émile Vuillermoz and René Jeanne proposed a politically independent international film festival to the Education Minister, Jean Zay, who approved it on 26 December 1938 in response to the Venice Mostra. Source: https://fr.wikipedia.org/wiki/Festival_de_Cannes_1939 (Festival de Cannes 1939)
- The festival was set for 1 to 20 September 1939; Louis Lumière accepted the presidency; the prize was the Coupe Lumière. The selection included The Wizard of Oz and Goodbye Mr. Chips; MGM chartered a liner to bring Hollywood stars. Source: https://fr.wikipedia.org/wiki/Festival_de_Cannes_1939 (Festival de Cannes 1939)
- On 1 September 1939, the day of the opening, German troops entered Poland, and the festival was cancelled. Source: https://fr.wikipedia.org/wiki/Festival_de_Cannes_1939 (Festival de Cannes 1939)

## saar_offensive_1939

- The French units moved off in the night of 5 to 6 September 1939. On 8 September the 42nd Infantry Division took the Warndt forest; on 9 September R35 tanks of the 20th BCC advanced north of Bliesbrück and four hit mines. By 12 September the army held a territory 25 km long and 5 to 8 km deep. Source: https://www.defense.gouv.fr/chemins-memoire/histoire-memoires/ressources-historiques/seconde-guerre-mondiale/operations-militaires/1939-1940-6 (France 1939. La drôle de guerre)
- On 12 September General Gamelin stopped the offensive so as not to cut the army off from its rear bases; the Siegfried Line was not attacked. On 30 September General Georges decided to withdraw the units of the 3rd, 4th and 5th Armies behind the Maginot Line by 4 October. Source: https://www.defense.gouv.fr/chemins-memoire/histoire-memoires/ressources-historiques/seconde-guerre-mondiale/operations-militaires/1939-1940-6 (France 1939. La drôle de guerre)

## polish_army_in_france_1939

- A Franco-Polish military agreement of 9 September 1939 officially created the Polish Army in France. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- On 12 September 1939 the Coëtquidan camp was placed at the disposal of the Polish army. Source: https://fr.wikipedia.org/wiki/Camp_de_Co%C3%ABtquidan (Camp de Coëtquidan)
- France hosted the Polish government in exile and its troops, mainly at Coëtquidan and Parthenay. Source: https://en.wikipedia.org/wiki/Polish_Army_in_France_(1939%E2%80%931940) (Polish Army in France (1939–1940))
- Władysław Sikorski became commander-in-chief on 7 November 1939; he was also minister of military affairs. Source: https://en.wikipedia.org/wiki/W%C5%82adys%C5%82aw_Sikorski (Władysław Sikorski)
- The Prime Minister and his government settled at Angers from 22 November 1939. Source: https://fr.wikipedia.org/wiki/Gouvernement_polonais_en_exil (Gouvernement polonais en exil)
- President Raczkiewicz lived at the Château de Pignerolle, near Angers, from 2 December 1939. Source: https://en.wikipedia.org/wiki/W%C5%82adys%C5%82aw_Raczkiewicz (Władysław Raczkiewicz)
- The president was received at the Château de Pignerolle on 20 December 1939 (the two sources differ on the date). Source: https://fr.wikipedia.org/wiki/Gouvernement_polonais_en_exil (Gouvernement polonais en exil)

## pcf_dissolution_1939

- On 23 August 1939 the German-Soviet pact was signed, and 21 of the 72 Communist deputies resigned from the party following the pact. On 26 August L'Humanité was seized; on 27 August censorship was established. On 26 September the French Communist Party was banned. Between 6 and 8 October 34 Communist deputies of the Groupe ouvrier et paysan français were arrested. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- In the night of 3 to 4 October 1939 the sapper Maurice Thorez illegally left his unit; he reached Moscow on 8 November 1939. Source: https://fr.wikipedia.org/wiki/Maurice_Thorez (Maurice Thorez)

## george_vi_front_visit_dec_1939

- On 12 September 1939 British troops began landing at Boulogne. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- In December 1939 King George VI arrived at Boulogne aboard the destroyer HMS Codrington and was met by General Lord Gort, Commander-in-Chief of the British Expeditionary Force. Source: https://film.iwmcollections.org.uk/record/23653 (His Majesty the King arriving in France, December 1939)
- On 9 December 1939, with General Maurice Gamelin and General Lord Gort, the King inspected French and British troops in the Saar sector of the Allied front line. Source: https://film.iwmcollections.org.uk/record/23659 (His Majesty the King in France)
## louvre_evacuation_1939

- Jacques Jaujard, director of the Musées Nationaux, organised the evacuation; on 25 August 1939 the Louvre was closed for three days, officially for repairs. Much of the collection was trucked to the Château de Chambord: 203 vehicles carried 1,862 wooden cases (the page gives no date for the transport). Source: https://en.wikipedia.org/wiki/Evacuation_of_the_Louvre_collection_during_World_War_II (Evacuation of the Louvre collection during World War II)
- The Joconde left the Louvre on 28 August 1939. Source: https://www.louvre.fr/decouvrir/vie-du-musee/les-memoires-de-guerre-du-louvre-1 (Les Mémoires de guerre du Louvre)

## alsace_evacuation_1939

- General mobilisation was ordered on 1 September 1939. On 2 and 3 September 1939 at least 530,000 Alsatians and Lorrainers, the civilians of the Bas-Rhin, the Haut-Rhin and the Moselle, were evacuated to the departments of the south-west. Source: https://fr.wikipedia.org/wiki/1939_en_France (1939 en France)
- The Cimade, the Comité inter-mouvements auprès des évacués, was founded on 18 October 1939 by the Protestant youth movements after Suzanne de Dietrich toured Alsace and Moselle; it sent teams to the south-west. Source: https://fr.wikipedia.org/wiki/Cimade (Cimade)

## heavy_water_1940

- Raoul Dautry entrusted Jacques Allier with secretly buying the available stock of heavy water, 185 kg, of Norsk Hydro, which the Banque de Paris et des Pays-Bas had helped to found in 1905; it was shipped from Norway to France via Scotland. Heavy water could be used as a neutron moderator. Source: https://histoire.bnpparibas/en/jacques-allier-banker-in-the-secret-war/ (Jacques Allier, banker in the 'secret war')
- The heavy water came from the Vemork plant; the experiment of Joliot-Curie and Kowarski needed it in large quantity as a moderator ('ralentisseur'). The stock was flown to France via Scotland at the end of March 1940 and first stored in the cellars of the Collège de France. Source: https://fr.wikipedia.org/wiki/Bataille_de_l%27eau_lourde (Bataille de l'eau lourde)
- Allier returned with 26 seven-litre canisters. Source: https://ahf.nuclearmuseum.org/ahf/history/french-nuclear-program/ (Atomic Heritage Foundation, French nuclear program)
```

## Events source

```json events
{
    "pack": "france",
    "tag": "FRA",
    "namespace": "ep_fra",
    "displayName": "France",
    "factQuotesFromId": 21,
    "events": [
        {
            "id": 1,
            "key": "transindochinois_1936",
            "title": "The Transindochinois Is Joined at Hao Son",
            "desc": "On 2 September the two construction teams of the Transindochinois met at Hao Son, at kilometre 1221, and the last piece of rail was put in place. A monument there records the joining of the railway from the Chinese border with the railway of Saigon.\n\nOn 1 October the section from Hao Son to Dai Lanh opened to traffic, and Bao Dai presided over the burial of ceremonial parchments at the monument.",
            "picture": "transindochinois_1936",
            "factSheet": "transindochinois_1936",
            "anchors": [
                "Transindochinois",
                "Hao Son",
                "2 September",
                "Bao Dai"
            ],
            "fire": {
                "after": "1936.10.2",
                "before": "1936.11.30",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Run through trains as soon as we can.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "transindochinois_traffic",
                            "days": 120
                        }
                    ]
                },
                {
                    "name": "Well done to both construction teams.",
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
            "id": 2,
            "key": "syria_lebanon_treaties_1936",
            "title": "Viénot Signs a Treaty with Syria",
            "desc": "Pierre Viénot and Hashim al-Atassi signed a Franco-Syrian treaty on 9 September. It provides for Syrian independence and unity: the autonomies of the Druze and the Alawites are to end. France keeps military facilities in Syria for 25 years.\n\nThe treaty goes next to the Syrian parliament and to our own.",
            "picture": "vanilla:GFX_report_event_generic_sign_treaty1",
            "factSheet": "syria_lebanon_treaties_1936",
            "anchors": [
                "Pierre Viénot",
                "Hashim al-Atassi",
                "9 September",
                "Druze",
                "Alawites"
            ],
            "fire": {
                "after": "1936.9.9",
                "before": "1936.11.15",
                "chance": 25,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Put it before the Chamber without delay.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "The army keeps its bases. The Senate can take its time.",
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
                "trigger": "has_war = no has_completed_focus = FRA_form_the_popular_front"
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
            "id": 4,
            "key": "mermoz_disappearance",
            "title": "Mermoz and the Croix-du-Sud Lost at Sea",
            "desc": "Jean Mermoz took off from Dakar for Natal on 7 December in the Latécoère 300 flying boat Croix-du-Sud. With him were Alexandre Pichodou, Henri Ezan, Edgar Cruveilher and Jean Lavidalie. Mermoz radioed that he had to cut the power on the aft starboard engine. No further message came.\n\nMermoz, 34, and his crew disappeared at sea 800 km south of Dakar. Neither the aircraft nor the crew has been found.",
            "picture": "mermoz_disappearance",
            "factSheet": "mermoz_disappearance",
            "anchors": [
                "Jean Mermoz",
                "Croix-du-Sud",
                "Dakar",
                "Natal",
                "7 December"
            ],
            "fire": {
                "after": "1936.12.14",
                "before": "1937.1.31",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Keep flying from Dakar to Natal.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "Ground the line until we know the cause.",
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
                "trigger": "has_war = no"
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
                "trigger": "has_war = no"
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
                "trigger": "has_war = no ENG = { has_war = no has_government = democratic }"
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
            "id": 8,
            "key": "marseille_nouvelles_galeries_fire",
            "title": "Fire at the Nouvelles Galeries Kills 73 in Marseille",
            "desc": "Fire broke out in the early afternoon of 28 October at the Nouvelles Galeries department store on the Canebière in Marseille. It killed 73 people.\n\nAt the request of Rear Admiral Muselier, who commands the Navy at Marseille, the marins-pompiers of Toulon were sent as reinforcements. They arrived only from 5 pm, when the store was already lost.",
            "picture": "marseille_nouvelles_galeries_fire",
            "factSheet": "marseille_nouvelles_galeries_fire",
            "anchors": [
                "Nouvelles Galeries",
                "Canebière",
                "28 October",
                "Muselier"
            ],
            "fire": {
                "after": "1938.10.29",
                "before": "1938.12.15",
                "chance": 50,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Give Marseille a fire battalion of naval men.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "The city must answer for its own firemen.",
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
            "id": 9,
            "key": "richelieu_launch_1939",
            "title": "The Battleship Richelieu Is Launched at Brest",
            "desc": "The battleship Richelieu, built by the Brest arsenal, was launched on 17 January. Her keel was laid on 22 October 1935 in the No. 4 dock at Brest, which had recently built the Dunkerque.\n\nThe Dunkerque was launched on 2 October 1935 and commissioned on 31 December 1936. The Dunkerque's sister Strasbourg was launched on 12 December 1936.",
            "picture": "richelieu_launch_1939",
            "factSheet": "richelieu_launch_1939",
            "anchors": [
                "Richelieu",
                "17 January",
                "Dunkerque"
            ],
            "fire": {
                "after": "1939.1.17",
                "before": "1939.3.31",
                "chance": 25,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Press on with the fitting-out.",
                    "ai": 60,
                    "effects": [
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "The yards will take the time they need.",
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
            "id": 10,
            "key": "phenix_submarine_loss",
            "title": "The Submarine Phénix Is Lost off Cam Ranh",
            "desc": "The submarine Phénix went down on 15 June in the South China Sea off Cam Ranh. She was on training manoeuvres with the light cruiser Lamotte-Picquet and aircraft. The exercise included a mock attack on the cruiser. The toll is 71 dead: 5 officers and 66 ratings.\n\nThe Phénix had been commissioned on 21 October 1932.",
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
                "trigger": "has_war = no"
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
                "trigger": "has_war = no"
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
            "id": 12,
            "key": "family_code_1939",
            "title": "A Family Code Rewards the First Child",
            "desc": "A decree-law of 29 July sets out a Code de la famille. A couple whose first child is born within two years of the wedding will receive a birth bonus. Single people will pay a family compensation tax. The penalties for abortion are made heavier.\n\nA separate decree-law of the same day limits the profits of firms working for national defence. The census of 8 March 1936 counted 41,911,530 inhabitants.",
            "picture": "vanilla:GFX_report_event_generic_read_write",
            "factSheet": "family_code_1939",
            "anchors": [
                "Code de la famille",
                "29 July",
                "41,911,530"
            ],
            "fire": {
                "after": "1939.7.29",
                "before": "1939.8.31",
                "chance": 50,
                "trigger": "has_war = no NOT = { has_government = communism }"
            },
            "options": [
                {
                    "name": "Pay the bonus promptly in every commune.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "family_code",
                            "days": 180
                        }
                    ]
                },
                {
                    "name": "The decree can speak for itself.",
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
            "id": 13,
            "key": "louvre_evacuation_1939",
            "title": "The Louvre Sends Its Collections to Chambord",
            "desc": "Jacques Jaujard, director of the national museums, has organised the evacuation of the Louvre. On 25 August the museum was closed for three days, officially for repairs. The Joconde left the Louvre on 28 August.\n\nThe evacuation sends much of the collection to the Château de Chambord: 203 vehicles and 1,862 wooden cases in all.",
            "picture": "louvre_evacuation_1939",
            "factSheet": "louvre_evacuation_1939",
            "anchors": [
                "Jacques Jaujard",
                "25 August",
                "Joconde",
                "Chambord",
                "1,862"
            ],
            "fire": {
                "after": "1939.8.31",
                "before": "1939.9.30",
                "chance": 100,
                "trigger": "OR = { has_war_with = GER threat > 0.5 }"
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
                "before": "1939.9.10",
                "chance": 100,
                "trigger": "GER = { has_war_with = POL }"
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
            "desc": "General mobilisation was ordered on 1 September. On 2 and 3 September at least 530,000 Alsatians and Lorrainers, civilians of the Bas-Rhin, the Haut-Rhin and the Moselle, were evacuated to the departments of the south-west.\n\nOn 18 October the Protestant youth movements founded the Cimade, the Comité inter-mouvements auprès des évacués. It sends teams to the south-west.",
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
                "after": "1939.10.18",
                "before": "1939.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER"
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
            "desc": "Our units moved off in the night of 5 to 6 September. On 8 September the 42nd Infantry Division took the Warndt forest, and on 9 September four R35 tanks of the 20th BCC hit mines north of Bliesbrück. By 12 September the army held a strip of ground 25 km long and 5 to 8 km deep.\n\nOn 12 September General Gamelin stopped the offensive so as not to cut the army off from its rear bases. The Siegfried Line was not attacked. On 30 September General Georges decided to pull the units of the 3rd, 4th and 5th Armies back behind the Maginot Line by 4 October.",
            "picture": "saar_offensive_1939",
            "factSheet": "saar_offensive_1939",
            "anchors": [
                "Warndt",
                "Bliesbrück",
                "General Georges",
                "12 September"
            ],
            "fire": {
                "after": "1939.10.4",
                "before": "1939.11.30",
                "chance": 50,
                "trigger": "has_war_with = GER"
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
            "desc": "The Franco-Polish military agreement of 9 September created the Polish Army in France. The camp at Coëtquidan was placed at its disposal on 12 September, and Parthenay is its other main centre.\n\nWładysław Sikorski, also minister of military affairs, became commander-in-chief on 7 November. The Polish prime minister and his government settled at Angers from 22 November. President Raczkiewicz lives at the Château de Pignerolle, near Angers.",
            "picture": "polish_army_in_france_1939",
            "factSheet": "polish_army_in_france_1939",
            "anchors": [
                "Coëtquidan",
                "Władysław Sikorski",
                "Angers",
                "9 September",
                "22 November"
            ],
            "fire": {
                "after": "1939.12.21",
                "before": "1940.2.28",
                "chance": 50,
                "trigger": "has_war_with = GER POL = { has_war_with = GER }"
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
            "desc": "The French Communist Party was banned on 26 September. L'Humanité had been seized on 26 August, three days after the German-Soviet pact, and censorship followed the next day. Of the party's 72 deputies, 21 resigned from it after the pact.\n\nIn the night of 3 to 4 October the sapper Maurice Thorez left his unit without leave. Between 6 and 8 October, 34 deputies of the Groupe ouvrier et paysan français were arrested.",
            "picture": "pcf_dissolution_1939",
            "factSheet": "pcf_dissolution_1939",
            "anchors": [
                "L'Humanité",
                "Maurice Thorez",
                "26 September",
                "Groupe ouvrier et paysan français"
            ],
            "fire": {
                "after": "1939.10.9",
                "before": "1939.12.31",
                "chance": 50,
                "trigger": "has_war_with = GER NOT = { has_government = communism } GER = { has_non_aggression_pact_with = SOV }"
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
            "desc": "British troops began landing at Boulogne on 12 September. In December King George VI crossed to Boulogne himself aboard the destroyer HMS Codrington, and Lord Gort met him.\n\nOn 9 December, with General Gamelin and Lord Gort, the King inspected French and British troops in the Saar sector of the front.",
            "picture": "george_vi_front_visit_dec_1939",
            "factSheet": "george_vi_front_visit_dec_1939",
            "anchors": [
                "Boulogne",
                "George VI",
                "Lord Gort",
                "HMS Codrington"
            ],
            "fire": {
                "after": "1939.12.10",
                "before": "1940.2.15",
                "chance": 50,
                "trigger": "has_war_with = GER ENG = { has_war_with = GER }"
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
            "desc": "Raoul Dautry entrusted Jacques Allier with secretly buying the available stock of Norsk Hydro's heavy water: 185 kg, from the Vemork plant. At the end of March the stock was flown to France by way of Scotland. Allier came back with 26 canisters of seven litres.\n\nThe heavy water went into the cellars of the Collège de France. Joliot-Curie and Kowarski need it in large quantity as a moderator, to slow the neutrons in their experiment.",
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
                "after": "1940.4.1",
                "before": "1940.5.9",
                "chance": 100,
                "trigger": "has_war_with = GER"
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
    ],
    "ideas": [
        {
            "key": "transindochinois_traffic",
            "name": "The Transindochinois",
            "desc": "The railway from the Chinese border is joined to the railway of Saigon.",
            "picture": "generic_political_support",
            "modifier": {
                "production_factory_efficiency_gain_factor": 0.03
            }
        },
        {
            "key": "palais_de_la_decouverte",
            "name": "Palais de la Découverte",
            "desc": "Jean Perrin's science halls in the Grand Palais stay open to the public.",
            "picture": "generic_research_bonus",
            "modifier": {
                "research_speed_factor": 0.02
            }
        },
        {
            "key": "family_code",
            "name": "Code de la famille",
            "desc": "A birth bonus for a first child born within two years of the wedding, and a family compensation tax on single people.",
            "picture": "generic_political_support",
            "modifier": {
                "monthly_population": 0.05,
                "consumer_goods_factor": 0.02
            }
        },
        {
            "key": "evacuee_relief",
            "name": "Evacuees from Alsace and Moselle",
            "desc": "The departments of the south-west lodge the evacuees at the state's expense.",
            "picture": "generic_political_support",
            "modifier": {
                "stability_factor": 0.03,
                "consumer_goods_factor": 0.02
            }
        },
        {
            "key": "joliot_curie_laboratory",
            "name": "Joliot-Curie's Laboratory",
            "desc": "The heavy water from Vemork goes to the experiment of Joliot-Curie and Kowarski.",
            "picture": "generic_research_bonus",
            "modifier": {
                "research_speed_factor": 0.03
            }
        }
    ]
}
```
