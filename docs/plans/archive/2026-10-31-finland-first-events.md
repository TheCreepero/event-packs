# Finland pack: the first events

Status: DONE
Pack: finland (FIN, namespace ep_fin)
Kind: new pack
Created: 2026-10-31

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/finland/events.json`, the `markdown fact-sheets` block holds the sections for `source/finland/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

## Context

The first round of events for the Finland pack, and the first events of the project. The pack's skeleton (`source/finland/`, `packs/finland/`, descriptor, namespace `ep_fin`) came with the initial commit; it had no events and a placeholder thumbnail. Written by the `event-pack-create` skill.

## Decisions

Owner's answers, 2026-10-31:
- Country: Finland, tag `FIN` (confirmed with `Get-HoiCountry`: `common/country_tags/00_countries.txt:28`).
- Period: 1936 to spring 1940: peacetime 1936 to 1939, then the Winter War months up to the Moscow Peace (March 1940).
- Number of events: about 10 to 15.
- Kinds: a balanced mix of politics and society, culture and sport, economy and industry, defence and diplomacy.
- Thumbnail: the background is one of the pack's own event pictures, not a vanilla loading screen. It's chosen in Phase 3 from the accepted pictures, PD or CC0 preferred. It's made at implementation (step 4), because the pack still has the `-NewPack` placeholder.
- Events chosen (owner, 2026-10-31), the 15 recommended from `research/finland/2026-10-31-dossier.md`: berlin_1936_olympics, red_earth_government, aalto_world_fairs, vickers_six_ton_tanks, maternity_grant_1937, record_year_1937, yartsev_talks_1938, olympics_1940_awarded, holsti_resignation, election_1939, taisto_maki_record, sillanpaa_nobel, league_expulsion_1939, tolvajarvi_victory, finnish_relief_fund. Dropped before the choice for overlap with vanilla: moscow_talks_october_1939 (`finland.1`), swedish_volunteers (`finland.5`), yh_mobilisation (focus `FIN_extra_refresher_exercises`), terijoki_government (inside vanilla's Winter War opening).
- Excluded: topics that vanilla Finland (Arms Against Tyranny) already stages, so the pack fires no duplicate. That includes the Winter War's outbreak and peace terms (`AAT_finland_winter_war`), Simo Häyhä (`AAT_finland_the_white_death`), motti tactics (`AAT_finland_motti`), the evacuation of children and the dancing ban (`AAT_finland_misc_events.01`, `.02`), presidential terms and no-confidence motions (`AAT_finland_political`), Nordic alliance and protection talks (`AAT_finland_diplomacy`, `AAT_nordic_*`). It also excludes the subjects of focuses that are also projects: the Mannerheim Line, the Jäniskoski, Imatra and Pohjolan Voima power plants, the Nokia tire factory, Väisälä's radiosonde, Outokumpu and Harjavalta, the Tornio steel works, Oy Alkoholiliike, Tikkakoski, the Kalevala Koru fund and Suomen Akatemia (`common/national_focus/finland.txt`).

## Events

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 1 | berlin_1936_olympics | Three Finns Take the 10,000 Metres in Berlin | 1936.8.17 to 1936.9.30 | 50 | berlin_1936_olympics | stability +0.02 / PP +20 |
| 2 | red_earth_government | Cajander Forms a Red-Earth Government | 1937.3.12 to 1937.6.30 | 25 | red_earth_government | stability +0.02 / PP +30 |
| 3 | aalto_world_fairs | Aalto's Timber Pavilion Stands at the Paris Exposition | 1937.5.25 to 1937.9.1 | 15 | aalto_world_fairs | PP -20, idea paris_trade_mission 90d / PP +15 |
| 4 | vickers_six_ton_tanks | The First Vickers Tanks Arrive Without Guns | 1938.7.1 to 1938.9.30 | 15 | vanilla GFX_report_event_tank_factory | PP -30, war support +0.02 / PP +20 |
| 5 | maternity_grant_1937 | Maternity Grant Law Adopted | 1937.12.1 to 1938.1.31 | 25 | maternity_grant_1937 | PP -25, idea maternity_grant 180d / stability +0.01 |
| 6 | record_year_1937 | Bank Commissioners Call 1937 a Record Year | 1938.1.15 to 1938.5.31 | 10 | record_year_1937 | idea industrial_reinvestment 180d / PP +30 |
| 7 | yartsev_talks_1938 | A Soviet Diplomat Opens Secret Talks | 1938.5.1 to 1938.9.30 | 10 | vanilla GFX_report_event_generic_conference | PP +15 / war support +0.02 |
| 8 | olympics_1940_awarded | Helsinki Is Given the 1940 Olympic Games | 1938.7.14 to 1938.9.15 | 30 | olympics_1940_awarded | PP -25, stability +0.03 / stability +0.01 |
| 9 | holsti_resignation | Foreign Minister Holsti Resigns | 1938.11.17 to 1938.12.11 | 30 | holsti_resignation | PP +20 / PP -20, war support +0.02 |
| 10 | election_1939 | Social Democrats Win 85 Seats | 1939.7.3 to 1939.8.15 | 50 | election_1939 | stability +0.02 / PP -25, stability +0.03 |
| 11 | taisto_maki_record | Taisto Mäki Runs 10,000 Metres Under 30 Minutes | 1939.9.17 to 1939.10.31 | 50 | taisto_maki_record | stability +0.01, war support +0.01 / PP +15 |
| 12 | sillanpaa_nobel | Sillanpää Awarded the Nobel Prize in Literature | 1939.11.10 to 1939.12.9 | 50 | sillanpaa_nobel | PP -15, stability +0.02 / PP +10 |
| 13 | league_expulsion_1939 | The League of Nations Expels the Soviet Union | 1939.12.14 to 1940.1.31 | 50 | league_expulsion_1939 | war support +0.03 / PP +25 |
| 14 | tolvajarvi_victory | Detachment P Defeats the Enemy at Tolvajärvi | 1939.12.13 to 1940.1.31 | 50 | tolvajarvi_victory | war support +0.03 / stability +0.02 |
| 15 | finnish_relief_fund | Hoover's Relief Fund Raises 2.5 Million Dollars | 1940.3.1 to 1940.4.30 | 100 | finnish_relief_fund | stability +0.02 / PP -15, war support +0.02 |

## Pictures

Every row passed `build.ps1 -FetchPicture ... -DryRun` while planning; the licence column is what it printed.

| Key | Commons file | Licence (from the dry run) | Crop | Tone | Event |
|---|---|---|---|---|---|
| berlin_1936_olympics | File:Volmari Iso-Hollo, Arvo Askola, Ilmari Salminen, Kohei Murakoso 1936.jpg | PD (Public domain), author unknown (IOC Olympic Museum) | 50 | warm | 1 |
| red_earth_government | File:A K Cajanderin hallitus 1937 (HK19670603-31196).tif | CC BY 4.0, Aarne Pietinen Oy | 50 | warm | 2 |
| aalto_world_fairs | File:Pariisi maailmannäyttely - Suomen paviljonki 1937.jpg | PD (Public domain), unknown author | 80 | warm | 3 |
| maternity_grant_1937 | File:Neuvolapäivä Helsingin Lastensairaalassa 1936 (HK19670603-28390).tif | CC BY 4.0, Aarne Pietinen Oy | 50 | warm | 5 |
| record_year_1937 | File:Timber floating Jämsänkoski 1938.jpg | PD (Public domain), unknown author | 50 | warm | 6 |
| olympics_1940_awarded | File:Helsinki Olympic Stadium 1938 (6804B; JOKAHBL3B I21-18).tif | CC BY 4.0, Hugo Sundström | 50 | warm | 8 |
| holsti_resignation | File:Rudolf Holsti 1937.jpg | CC BY 4.0, Heinrich Iffland | 50 | warm | 9 |
| election_1939 | File:Parliamentary Election in Finland 1939 (1209C; JOKAHBL3B J24-2).tif | CC BY 4.0, Hugo Sundström | 50 | warm | 10 |
| taisto_maki_record | File:Kestävyysjuoksija Taisto Mäki 1939 (HK19630423-14).tif | CC BY 4.0, Thérèse Bonney | 10 | warm | 11 |
| sillanpaa_nobel | File:F.E. Sillanpää receives news about his Nobel prize.jpg | PD (Public domain), Uusi Suomi | 50 | warm | 12 |
| league_expulsion_1939 | File:League of nations rudolf holsti 1939.png | PD (Public domain), Yhtyneet kuvalehdet | 50 | warm | 13 |
| tolvajarvi_victory | File:Ev. Pajari selostaa Tolvajärven taistelua Tolvajärven tiellä kilometreillä 66-33, SAKuva-8998.jpg | PD (Public domain), unknown author | 50 | warm | 14 |
| finnish_relief_fund | File:SuomiKokousNewYorkissa.jpg | PD (Public domain), unknown author | 50 | warm | 15 |

Two events use a vanilla picture:
- **Event 4, Vickers tanks: `vanilla:GFX_report_event_tank_factory`.** The only accepted Commons file (`Vickers parola 1.jpg`, CC BY 2.5) is a modern colour photo of a museum tank, and no period photo was found.
- **Event 7, Yartsev talks: `vanilla:GFX_report_event_generic_conference`.** No Commons file was found for Rybkin or the Council of State, and the Soviet legation photo (`Talvisota (Neuvostoliiton suurlähetystö (Bulevardi).jpg`) was `REJECTED` (CC BY without a named author).

Two other files were turned down:
- `Kajaanin Puutavara Osakeyhtiön paperitehdas (HK19670603-30829A).tif` was `REJECTED` (CC BY without a named author).
- `Terveyssisar punnitsee vauvaa.jpg` was accepted, but Commons dates it 1951.

Thumbnail: record_year_1937 (PD, a landscape with open sky in its upper third; crop center, theme amber; test-rendered while planning)

## Editor record

Round 1 (2026-10-31): 6 KEEP (red_earth_government, olympics_1940_awarded, election_1939, tolvajarvi_victory, ideas maternity_grant and industrial_reinvestment), 11 REWRITE, 0 REJECT. Every REWRITE was applied as given; for taisto_maki_record the 42-word version passed, so the alternative last sentence was not needed. The editor's notes were acted on:
- **berlin_1936_olympics:** the window opens 1936.8.17, after the Games end, so the text never reports results that haven't happened yet.
- **maternity_grant_1937:** the window moves to 1937.12.1 to 1938.1.31, so the 180-day idea runs while the grant is in force.
- **election_1939:** the trigger also requires a democratic or non-aligned government.
- **tolvajarvi_victory:** the window opens 1939.12.13, the day after the battle.
- **finnish_relief_fund:** the chance is 100, so it fires in the first week of March, before a historical Moscow Peace.
- **sillanpaa_nobel:** the fact-sheet section now holds the addendum's sourced lines (`research/finland/2026-10-31-sillanpaa-addendum.md`), without its UNVERIFIED ones.

Round 2 (2026-10-31): 10 KEEP, 3 REWRITE (berlin_1936_olympics, maternity_grant_1937, taisto_maki_record), 0 REJECT. All three rewrites were applied as given.
- **berlin_1936_olympics:** the editor found that '3 gold, 5 silver, 2 bronze' is Finland's athletics tally, not its total for the Games. The line was dropped from this plan's fact sheet, and the text no longer gives a total. The dossier (`research/finland/2026-10-31-dossier.md`, section berlin_1936_olympics) still carries the mislabelled line as the researcher wrote it; a later expansion should have it rechecked.
- **aalto_world_fairs:** the editor noted that a trade or economy effect would suit the trade-mission option better than stability. The option passed as written and was kept.

Round 3 (2026-10-31): 2 KEEP (berlin_1936_olympics, taisto_maki_record), 1 REWRITE (maternity_grant_1937: 'It goes first to mothers of low income.' became 'It is for mothers of low income.', because 'first' hints at the grant's later widening), 0 REJECT. The rewrite was applied as given. It came in the third and last round, so the owner decides whether it stands without a fourth round. The owner accepted it as final (2026-10-31).

Review correction (2026-10-31). After the first implementation, ep-reviewer found three problems:
- **C1, critical:** event 4 contradicted its source. The tanks were ordered without guns on purpose and arrived only in July 1938.
- **M1, minor:** event 9 stated one modern author's analysis of Blücher's campaign as a known fact.
- **M2, minor:** event 3's trade-mission effect was a weak fit.

The owner chose to re-plan event 4 and to fix M1 and M2. M3, the March 1940 date of the Tolvajärvi photo, was kept on the owner's word. The researcher rewrote the Vickers section from full page fetches in `research/finland/2026-10-31-vickers-addendum.md`. The plan's fact-sheet section, event 4's text and its window (now 1938.7.1 to 1938.9.30) were rebuilt from it.

Correction round 1: 3 KEEP (vickers_six_ton_tanks, aalto_world_fairs, idea paris_trade_mission), 1 REWRITE (holsti_resignation: the Geneva-dinner sentence was cut as later analysis), 0 REJECT. The rewrite was applied as given. On the editor's note, the paris_trade_mission idea was shortened to 90 days, so it ends before the exposition closes.
Correction round 2: holsti_resignation KEEP. Every event and idea now has KEEP in its latest round.

## Kept on judgment

None: the rehearsal's `-Check -Pack finland` printed `Check OK: 1 pack(s), 0 warning(s).`

## Implementation steps

- [x] 1. Write the events: replace `source/finland/events.json` with the `json events` block below, whole.
- [x] 2. Write the fact sheets: add each section of the `markdown fact-sheets` block below to `source/finland/fact-sheets.md`, replacing a section of the same key.
- [x] 3. Fetch the pictures, one command per row of the picture table, each expected to print `ACCEPTED`:
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Volmari Iso-Hollo, Arvo Askola, Ilmari Salminen, Kohei Murakoso 1936.jpg" -Key berlin_1936_olympics -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:A K Cajanderin hallitus 1937 (HK19670603-31196).tif" -Key red_earth_government -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Pariisi maailmannäyttely - Suomen paviljonki 1937.jpg" -Key aalto_world_fairs -Crop 80 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Neuvolapäivä Helsingin Lastensairaalassa 1936 (HK19670603-28390).tif" -Key maternity_grant_1937 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Timber floating Jämsänkoski 1938.jpg" -Key record_year_1937 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Helsinki Olympic Stadium 1938 (6804B; JOKAHBL3B I21-18).tif" -Key olympics_1940_awarded -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Rudolf Holsti 1937.jpg" -Key holsti_resignation -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Parliamentary Election in Finland 1939 (1209C; JOKAHBL3B J24-2).tif" -Key election_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Kestävyysjuoksija Taisto Mäki 1939 (HK19630423-14).tif" -Key taisto_maki_record -Crop 10 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:F.E. Sillanpää receives news about his Nobel prize.jpg" -Key sillanpaa_nobel -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:League of nations rudolf holsti 1939.png" -Key league_expulsion_1939 -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:Ev. Pajari selostaa Tolvajärven taistelua Tolvajärven tiellä kilometreillä 66-33, SAKuva-8998.jpg" -Key tolvajarvi_victory -Crop 50 -Tone warm`
  - `powershell -File .\build.ps1 -FetchPicture -Pack finland -File "File:SuomiKokousNewYorkissa.jpg" -Key finnish_relief_fund -Crop 50 -Tone warm`
- [x] 4. Make the thumbnail from the picture fetched in step 3, two commands:
  - `python "W:\Antigravity\Mod Thumbnail Generator\generate_branding.py" --bg-image (Get-Item sources-cache\finland\record_year_1937.*).FullName --bg-crop center --title "EVENT PACK" --subtitle "FINLAND" --theme amber --text-pos top --hoi4 --json --out-dirs "scratch\thumbnail\finland"`: expect `"status": "success"` and `"workshop_limit_exceeded": false`.
  - `Copy-Item scratch\thumbnail\finland\thumbnail.png packs\finland\thumbnail.png`
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack finland`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack finland`: expect `Generated pack 'finland'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack finland`: expect `Check OK`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 9. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `feat(finland): <summary>`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.
- A `-FetchPicture` fails with `429, Too many requests` from Wikimedia, after printing `ACCEPTED`: this is a rate limit, not a rejection. Wait a few minutes and run the same command again (in the rehearsal, two files needed about ten minutes).

## Outcome

2026-10-31: steps 1 to 8 done. `-Check -Pack finland`: `Check OK: 1 pack(s), 0 warning(s).` (15 events, 13 pictures, 0 errors). `-ValidateOnly`: `Validation succeeded.` `-Test`: 171 passed, 0 failed. Deviation: the plan arrived with Status READY but steps 3 to 5 already ticked (and this Outcome already filled); steps 3 to 5 were taken as done and not re-run, steps 1, 2 and 6 to 8 were run in this pass. Step 9 (ship) is left to the caller.

## Fact sheets

```markdown fact-sheets
## berlin_1936_olympics

- In the 10,000 m final at the Berlin Olympics on 2 August 1936, Ilmari Salminen won gold, Arvo Askola silver and Volmari Iso-Hollo bronze. Source: https://en.wikipedia.org/wiki/Athletics_at_the_1936_Summer_Olympics_–_Men's_10,000_metres (Athletics at the 1936 Summer Olympics – Men's 10,000 metres)
- Volmari Iso-Hollo won the 3,000 m steeplechase for the second Games in a row. Source: https://www.britannica.com/print/article/296166 (Volmari Iso-Hollo)
- In the javelin, Stöck of Germany won with 71.84 m; Yrjö Nikkanen took silver with 70.77 m and Kalervo Toivonen bronze with 70.72 m. Source: https://en.wikipedia.org/wiki/List_of_1936_Summer_Olympics_medal_winners (List of 1936 Summer Olympics medal winners)

## red_earth_government

- Kyösti Kallio took office as president on 1 March 1937 after Svinhufvud lost the February election; Aimo Cajander of the National Progressive Party was asked to form a majority government. Source: https://en.wikipedia.org/wiki/Kyösti_Kallio (Kyösti Kallio)
- The Cajander III cabinet was formed on 12 March 1937 from the National Progressive Party, the Social Democrats, the Agrarian League and the Swedish People's Party; it was a majority government. Source: https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet)
- Väinö Tanner of the Social Democrats was finance minister in the cabinet from 12 March 1937. Source: https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet)
- The term punamulta (red-earth) first meant the March 1937 coalition of the Agrarian League, the Social Democrats and the Progressives. Source: https://tieteentermipankki.fi/!4mv4 (Tieteen termipankki, punamulta)
- Kallio's election came as a surprise, with Tanner's support; Tanner and Kallio had worked together to defend parliamentary government against the far right. Source: https://en.wikipedia.org/wiki/Väinö_Tanner (Väinö Tanner)

## aalto_world_fairs

- Alvar Aalto won both first and second prizes in the 1936 open competition for Finland's pavilion at the Paris exposition, with the entry 'Le bois est en marche'; the pavilion was built entirely of timber to promote wood, Finland's chief export. Source: https://en.wikipedia.org/wiki/Exposition_Internationale_des_Arts_et_Techniques_dans_la_Vie_Moderne (Exposition Internationale des Arts et Techniques dans la Vie Moderne)
- The Paris exposition ran from 25 May to 25 November 1937, with 45 countries taking part. Source: https://en.wikipedia.org/wiki/Exposition_Internationale_des_Arts_et_Techniques_dans_la_Vie_Moderne (Exposition Internationale des Arts et Techniques dans la Vie Moderne)
- Aalto designed Finland's pavilion for the New York World's Fair in 1938; it was completed in 1939. Source: https://www.moma.org/docs/press_archives/6098/releases/MOMA_1984_0034_36.pdf (MoMA press release, 1984)

## vickers_six_ton_tanks

- On 20 July 1936 the Ministry of Defence ordered 32 Vickers-Armstrongs 6-ton tanks (Alternative B), to form a battalion of two 15-tank companies and a 2-tank headquarters element. Sources: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish service); https://www.jaegerplatoon.net/TANKS2.htm (Armoured Vehicles Part 4)
- The agreed schedule was 11 tanks by 20 July 1937, 10 by 1 April 1938 and 11 by 1 January 1939; Vickers failed to meet it, and the first batch arrived in July 1938. Sources: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish service); https://www.jaegerplatoon.net/TANKS2.htm (Armoured Vehicles Part 4)
- To save money the tanks were ordered without optics, radios or armament (also without turret rotation mechanisms, tools and in some cases drivers' seats); the price was 4,500 pounds per tank. Sources: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish service); https://www.jaegerplatoon.net/TANKS2.htm (Armoured Vehicles Part 4)
- After arrival the tanks went to the State Artillery Factory, Valtion Tykkitehdas (VTT), to be fitted with guns, optics, tools and seats. Sources: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish service); https://www.jaegerplatoon.net/TANKS2.htm (Armoured Vehicles Part 4)
- The gun chosen was a 37 mm tank adaptation of the licence-built Bofors anti-tank gun; the 47 mm low-velocity gun Vickers offered was rejected for lacking penetration. Source: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish service)

## maternity_grant_1937

- The maternity grant law was adopted on 24 September 1937 and took effect on 1 January 1938. Source: https://blogs.loc.gov/law/2022/12/collection-highlights-the-finnish-baby-box-at-85-years-old/ (Collection Highlights: The Finnish Baby Box at 85 Years Old)
- The grant was motivated by concern over infant mortality and the falling birth rate. Source: https://www.kela.fi/aitiysavustus-historia (Äitiysavustuksen historia)
- The grant was worth 450 markkaa per child and could be taken as goods, cash or a mix; at first it was for low-income mothers, and in 1938 about two-thirds of mothers received it. Sources: https://www.kela.fi/aitiysavustus-historia (Äitiysavustuksen historia); https://yle.fi/a/7-1171985 (Yle retrospective)

## record_year_1937

- The parliamentary bank commissioners' report for 1937 called it a record year for Finnish industry, with rising prices, heavy industrial investment and a good harvest. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937)
- From 1936 to 1937 sulphate pulp exports rose from 323,200 to 355,700 tonnes and sulphite pulp exports from 757,600 to 823,600 tonnes. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937)
- An export surplus of 73 million marks in 1937 became an import surplus of 181 million marks in 1938. Source: https://journal.fi/haik/article/view/139588/87373 (journal.fi article)
- Forest products made up over 80 per cent of export earnings in the depression years. Source: https://publications.bof.fi/bitstreams/e193ff39-c358-42bd-bacf-f42df52ab3ac/download (Bank of Finland study)

## yartsev_talks_1938

- Boris Rybkin, second secretary at the Soviet legation and an NKVD officer using the name Boris Yartsev, received Stalin's instructions in April 1938 to open secret talks with Finland. Sources: https://en.wikipedia.org/wiki/Boris_Rybkin (Boris Rybkin); https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War)
- Moscow offered military and economic help if Finland resisted a German attack; in return it wanted islands in the Gulf of Finland near Leningrad ceded or leased, and it would permit Finland to fortify Åland. The demands changed several times. Source: https://en.wikipedia.org/wiki/Boris_Rybkin (Boris Rybkin)
- Members of the Cajander government took part in the talks in summer 1938 while Foreign Minister Rudolf Holsti was away. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War)

## olympics_1940_awarded

- Tokyo won the vote for the 1940 Games at the 1936 congress in Berlin; on 14 July 1938 Tokyo announced it was giving up the Games, and the IOC gave them to Helsinki. Sources: https://en.wikipedia.org/wiki/1940_Summer_Olympics (1940 Summer Olympics); https://timarit.is/page/7724856 (Le Nord, 1 June 1940)
- The Helsinki Olympic Stadium was designed by Yrjö Lindegren and Toivo Jäntti; construction began on 12 February 1934 and the stadium opened on 12 June 1938. Source: https://en.wikipedia.org/wiki/Helsinki_Olympic_Stadium (Helsinki Olympic Stadium)
- The stadium tower is 72.71 m tall, the length of Matti Järvinen's gold-medal javelin throw at the 1932 Olympics. Source: https://en.wikipedia.org/wiki/Helsinki_Olympic_Stadium (Helsinki Olympic Stadium)
- The stadium opened unfinished in 1938, to be completed for the 1940 Games. Source: https://docomomo.fi/?p=428 (Olympic Buildings)

## holsti_resignation

- Foreign Minister Rudolf Holsti resigned on 17 November 1938 (the cabinet table gives 16 November); Väinö Voionmaa of the Social Democrats stood in until Eljas Erkko took office on 12 December 1938. Sources: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War); https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet)
- The main cause, by this account, was a campaign of about two years by the German envoy Wipert von Blücher, whose report said: 'our campaign (Aktio) of two years has been completed successfully.' Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (as translated on that page)
- The Finnish envoy Aarne Vuorimaa's report of 7 November 1938 repeated accusations made by State Secretary Ernst von Weizsäcker; the Cajander government feared German retaliation and wanted Holsti to step down. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War)
- A widely held view blames a diplomatic misstep at a dinner in Geneva on 26 September 1938; the same author calls it a translation mix-up. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War)

## election_1939

- The parliamentary election was held on 1 and 2 July 1939; turnout was 66.55 per cent (1,302,348 of 1,956,807 registered voters). Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election)
- Seats: Social Democrats 85 (39.77 per cent of the vote), Agrarian League 56 (22.86 per cent), National Coalition 25, Swedish People's Party 18, IKL 8, National Progressive Party 6. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election)
- IKL received 86,219 votes. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election)
- Cajander's government continued in office after the election. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election)

## taisto_maki_record

- Taisto Mäki ran 10,000 m in 29:52.6 in Helsinki on 17 September 1939, the first man to run the distance in under 30 minutes. Sources: https://etusuora.com/uutiset/10000-metrin-haamuraja-taisto-maki (10000 metrin haamuraja Taisto Mäki); https://en.wikipedia.org/wiki/Taisto_Mäki (Taisto Mäki)
- It improved on his own record of 30:02.0, set in Tampere on 29 September 1938. Sources: https://etusuora.com/uutiset/10000-metrin-haamuraja-taisto-maki (10000 metrin haamuraja Taisto Mäki); https://en.wikipedia.org/wiki/Taisto_Mäki (Taisto Mäki)
- The race was run at the Olympic Stadium. Source: https://etusuora.com/uutiset/10000-metrin-haamuraja-taisto-maki (10000 metrin haamuraja Taisto Mäki)

## sillanpaa_nobel

- The Swedish Academy announced on 10 November 1939 that Frans Eemil Sillanpää was awarded the Nobel Prize in Literature for 1939; he was the first Finnish laureate. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature)
- The citation praises his 'deep understanding of his country's peasantry'. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature)
- His novels include Hurskas kurjuus (1919) and Nuorena nukkunut (1931); Miehen tie and Ihmiset suviyössa were translated into several languages in the 1930s. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit)
- Hermann Hesse led early in the Academy's deliberations, but conservative academicians opposed him as 'anarchic'; Johan Huizinga was also in contention (Kjell Espmark, quoted by the source). Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit)
- Sillanpää travelled to Stockholm to receive the prize; academician Per Hallström addressed him, remembering the Finnish nation 'with feelings of admiration and horror'. Whether a formal ceremony was held is disputed. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit)
- After the presentation he stayed in Sweden and raised funds for Finland against the Soviet attack. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit)
- He gave his gold Nobel medal to be melted down for war funds. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature)

## league_expulsion_1939

- The League of Nations Assembly set up a Special Committee on Finland's appeal on 11 December 1939; the Council expelled the Soviet Union on 14 December. Sources: https://en.wikipedia.org/wiki/December_1939 (December 1939); https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations)
- The Council's resolution: 'Finds that, by its act, the Union of Soviet Socialist Republics has placed itself outside the League of Nations. It follows that the Union of Soviet Socialist Republics is no longer a Member of the League.' Source: https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations)
- Argentina introduced the motion, citing the League's 1933 definition of aggression. Source: https://euromaidanpress.com/2018/12/17/when-the-league-of-nations-expelled-the-ussr-for-bombing-finland/ (When the League of Nations expelled the USSR for bombing Finland)
- Finland's representative at Geneva was Rudolf Holsti. Source: https://euromaidanpress.com/2018/12/17/when-the-league-of-nations-expelled-the-ussr-for-bombing-finland/ (When the League of Nations expelled the USSR for bombing Finland)

## tolvajarvi_victory

- On 12 December 1939 Lieutenant Colonel Aaro Pajari's Detachment P, part of Paavo Talvela's Group T, attacked and defeated the Soviet 139th Rifle Division at Tolvajärvi, the first major Finnish success of the war. Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi)
- Pajari reported to Talvela at 5 pm on 12 December: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (as translated on that page)
- Talvela was promoted to major general and Pajari to colonel; Detachment P resumed the advance on 13 December and reached the Ägläjärvi front on 17 December. Sources: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi); https://en.wikipedia.org/wiki/Battle_of_Tolvajärvi (Battle of Tolvajärvi)
- About 100 Finns were killed against some ten times as many Soviet soldiers; 20 tanks and 60 machine guns were captured (approximate figures, one museum source). Source: https://infotaulu.museomilitaria.fi/en/winter-war/examples-from-ladoga-karelia (Winter war)

## finnish_relief_fund

- Herbert Hoover started the Finnish Relief Fund in December 1939 to help Finland. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund)
- By March 1940 the fund had raised 2.5 million dollars; it advertised in 1,400 American newspapers. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund)
- Hoover, Hendrik Willem van Loon and Fiorello La Guardia appeared at Madison Square Garden on 20 December 1939. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund)
- The proceeds of the first screening of Gone with the Wind in Washington state went to the fund. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund)
```

## Events source

```json events
{
    "pack": "finland",
    "tag": "FIN",
    "namespace": "ep_fin",
    "displayName": "Finland",
    "events": [
        {
            "id": 1,
            "key": "berlin_1936_olympics",
            "title": "Three Finns Take the 10,000 Metres in Berlin",
            "desc": "In the 10,000 m final at the Berlin Olympics on 2 August, Ilmari Salminen won gold, Arvo Askola silver and Volmari Iso-Hollo bronze.\n\nIso-Hollo also won the 3,000 m steeplechase, for the second Games in a row. In the javelin, Yrjö Nikkanen and Kalervo Toivonen took silver and bronze behind Stöck of Germany.",
            "picture": "berlin_1936_olympics",
            "factSheet": "berlin_1936_olympics",
            "anchors": [
                "Ilmari Salminen",
                "Arvo Askola",
                "Volmari Iso-Hollo",
                "2 August"
            ],
            "fire": {
                "after": "1936.8.17",
                "before": "1936.9.30",
                "chance": 50
            },
            "options": [
                {
                    "name": "Meet the team when they come home.",
                    "ai": 70,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Let the sports clubs do the celebrating.",
                    "ai": 30,
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
            "key": "red_earth_government",
            "title": "Cajander Forms a Red-Earth Government",
            "desc": "President Kyösti Kallio, in office since 1 March, has asked Aimo Cajander of the National Progressive Party to form a majority government. The cabinet formed on 12 March joins the Progressives, the Social Democrats, the Agrarian League and the Swedish People's Party. The alliance of the Agrarian League, the Social Democrats and the Progressives is known as punamulta, red-earth.\n\nVäinö Tanner of the Social Democrats takes the finance ministry. Tanner backed Kallio in the February election, and the two have worked together to defend parliamentary government against the far right.",
            "picture": "red_earth_government",
            "factSheet": "red_earth_government",
            "anchors": [
                "Kyösti Kallio",
                "Aimo Cajander",
                "Väinö Tanner",
                "12 March",
                "punamulta"
            ],
            "fire": {
                "after": "1937.3.12",
                "before": "1937.6.30",
                "chance": 25,
                "trigger": "has_war = no has_country_leader = { ruling_only = yes character = FIN_kyosti_kallio }"
            },
            "options": [
                {
                    "name": "Give every partner a say, however slow.",
                    "ai": 60,
                    "effects": [
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "Let the finance ministry set the pace.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 30
                        }
                    ]
                }
            ]
        },
        {
            "id": 3,
            "key": "aalto_world_fairs",
            "title": "Aalto's Timber Pavilion Stands at the Paris Exposition",
            "desc": "The Paris exposition opened on 25 May, with 45 countries taking part. It runs until 25 November.\n\nFinland's pavilion is the work of Alvar Aalto, who won both first and second prizes in last year's open competition with the entry 'Le bois est en marche'. The pavilion is built entirely of timber. Its purpose is to promote wood, Finland's chief export.",
            "picture": "aalto_world_fairs",
            "factSheet": "aalto_world_fairs",
            "anchors": [
                "Alvar Aalto",
                "Le bois est en marche",
                "25 May"
            ],
            "fire": {
                "after": "1937.5.25",
                "before": "1937.9.1",
                "chance": 15
            },
            "options": [
                {
                    "name": "Send trade officials to Paris with the pavilion.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": -20
                        },
                        {
                            "timed_idea": "paris_trade_mission",
                            "days": 90
                        }
                    ]
                },
                {
                    "name": "Good timber sells itself.",
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
            "id": 4,
            "key": "vickers_six_ton_tanks",
            "title": "The First Vickers Tanks Arrive Without Guns",
            "desc": "The first Vickers-Armstrongs 6-ton tanks have arrived. The Ministry of Defence ordered 32 on 20 July 1936, enough for a battalion of two 15-tank companies and a headquarters element. Eleven were due by 20 July 1937.\n\nTo save money, the tanks were ordered without optics, radios or armament, at 4,500 pounds each. They now go to the State Artillery Factory, Valtion Tykkitehdas, to be fitted with a 37 mm gun adapted from the licence-built Bofors anti-tank gun. Vickers offered a 47 mm gun, which was turned down for poor penetration.",
            "picture": "vanilla:GFX_report_event_tank_factory",
            "factSheet": "vickers_six_ton_tanks",
            "anchors": [
                "Vickers-Armstrongs",
                "20 July 1936",
                "Valtion Tykkitehdas",
                "4,500 pounds"
            ],
            "fire": {
                "after": "1938.7.1",
                "before": "1938.9.30",
                "chance": 15,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Arm them now, whatever the factory needs.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": -30
                        },
                        {
                            "war_support": 0.02
                        }
                    ]
                },
                {
                    "name": "They can wait; the money goes elsewhere.",
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
            "key": "maternity_grant_1937",
            "title": "Maternity Grant Law Adopted",
            "desc": "A law adopted on 24 September gives mothers a maternity grant from 1 January 1938. The grant is worth 450 markkaa per child and can be taken as goods, as cash or as a mix of both. It is for mothers of low income.\n\nThe law answers concern over infant mortality and the falling birth rate.",
            "picture": "maternity_grant_1937",
            "factSheet": "maternity_grant_1937",
            "anchors": [
                "450 markkaa",
                "1 January 1938",
                "24 September"
            ],
            "fire": {
                "after": "1937.12.1",
                "before": "1938.1.31",
                "chance": 25,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Fund it in full, for every mother.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": -25
                        },
                        {
                            "timed_idea": "maternity_grant",
                            "days": 180
                        }
                    ]
                },
                {
                    "name": "Keep it for low-income mothers, as written.",
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
            "key": "record_year_1937",
            "title": "Bank Commissioners Call 1937 a Record Year",
            "desc": "The parliamentary bank commissioners report that 1937 was a record year for Finnish industry, with rising prices, heavy industrial investment and a good harvest. Sulphate pulp exports rose from 323,200 to 355,700 tonnes, and sulphite pulp from 757,600 to 823,600 tonnes.\n\nIn the depression years forest products made up over 80 per cent of export earnings. The country closed 1937 with an export surplus of 73 million marks.",
            "picture": "record_year_1937",
            "factSheet": "record_year_1937",
            "anchors": [
                "355,700 tonnes",
                "823,600 tonnes",
                "73 million marks"
            ],
            "fire": {
                "after": "1938.1.15",
                "before": "1938.5.31",
                "chance": 10,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Put the profits into new mills and plants.",
                    "ai": 60,
                    "effects": [
                        {
                            "timed_idea": "industrial_reinvestment",
                            "days": 180
                        }
                    ]
                },
                {
                    "name": "Save it against the next bad year.",
                    "ai": 40,
                    "effects": [
                        {
                            "political_power": 30
                        }
                    ]
                }
            ]
        },
        {
            "id": 7,
            "key": "yartsev_talks_1938",
            "title": "A Soviet Diplomat Opens Secret Talks",
            "desc": "Boris Yartsev, second secretary at the Soviet legation, has opened secret talks with the government on Moscow's behalf. Moscow offers military and economic help if Finland resists a German attack. In return it wants islands in the Gulf of Finland near Leningrad, ceded or leased, and it would let us fortify Åland.\n\nForeign Minister Rudolf Holsti is away this summer, and members of the Cajander government are hearing the offer. The demands have changed several times. How should we answer?",
            "picture": "vanilla:GFX_report_event_generic_conference",
            "factSheet": "yartsev_talks_1938",
            "anchors": [
                "Boris Yartsev",
                "Rudolf Holsti",
                "Åland",
                "Leningrad"
            ],
            "fire": {
                "after": "1938.5.1",
                "before": "1938.9.30",
                "chance": 10,
                "trigger": "has_war = no NOT = { has_government = communism }"
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
            "id": 8,
            "key": "olympics_1940_awarded",
            "title": "Helsinki Is Given the 1940 Olympic Games",
            "desc": "On 14 July Tokyo announced that it is giving up the 1940 Games, which it won in the vote at Berlin in 1936. The IOC has turned to Helsinki.\n\nThe Helsinki Olympic Stadium, designed by Yrjö Lindegren and Toivo Jäntti, opened on 12 June, still unfinished. Its tower stands 72.71 m, the length of Matti Järvinen's winning javelin throw at the 1932 Games. The stadium is to be completed for 1940.",
            "picture": "olympics_1940_awarded",
            "factSheet": "olympics_1940_awarded",
            "anchors": [
                "Tokyo",
                "14 July",
                "Yrjö Lindegren",
                "Toivo Jäntti",
                "72.71 m"
            ],
            "fire": {
                "after": "1938.7.14",
                "before": "1938.9.15",
                "chance": 30,
                "trigger": "has_war = no"
            },
            "options": [
                {
                    "name": "Accept, and finish the stadium properly.",
                    "ai": 60,
                    "effects": [
                        {
                            "political_power": -25
                        },
                        {
                            "stability": 0.03
                        }
                    ]
                },
                {
                    "name": "Accept, on a strict budget.",
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
            "key": "holsti_resignation",
            "title": "Foreign Minister Holsti Resigns",
            "desc": "Rudolf Holsti has resigned as foreign minister. On 7 November our envoy Aarne Vuorimaa reported accusations against him made by State Secretary Ernst von Weizsäcker. The cabinet feared German retaliation and wanted Holsti to step down.\n\nVäinö Voionmaa of the Social Democrats stands in until a new minister is named.",
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
                "before": "1938.12.11",
                "chance": 30,
                "trigger": "has_war = no"
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
                "trigger": "has_war = no has_elections = yes OR = { has_government = democratic has_government = neutrality }"
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
            "desc": "At the Olympic Stadium in Helsinki on 17 September, Taisto Mäki ran 10,000 metres in 29:52.6. No man has run the distance in under 30 minutes before.\n\nThe record he broke was his own: 30:02.0, set in Tampere on 29 September 1938.",
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
                "chance": 50
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
            "id": 12,
            "key": "sillanpaa_nobel",
            "title": "Sillanpää Awarded the Nobel Prize in Literature",
            "desc": "The Swedish Academy announced on 10 November that Frans Eemil Sillanpää is awarded the Nobel Prize in Literature for 1939, for his 'deep understanding of his country's peasantry'. He is the first Finn to receive it.\n\nHis novels include Hurskas kurjuus of 1919 and Nuorena nukkunut of 1931. Miehen tie and Ihmiset suviyössa have been translated into several languages.",
            "picture": "sillanpaa_nobel",
            "factSheet": "sillanpaa_nobel",
            "anchors": [
                "Frans Eemil Sillanpää",
                "10 November",
                "Nuorena nukkunut",
                "Swedish Academy"
            ],
            "fire": {
                "after": "1939.11.10",
                "before": "1939.12.9",
                "chance": 50
            },
            "options": [
                {
                    "name": "Honour him with a state reception.",
                    "ai": 50,
                    "effects": [
                        {
                            "political_power": -15
                        },
                        {
                            "stability": 0.02
                        }
                    ]
                },
                {
                    "name": "A telegram of congratulations will do.",
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
            "id": 13,
            "key": "league_expulsion_1939",
            "title": "The League of Nations Expels the Soviet Union",
            "desc": "Geneva has answered our appeal. On 11 December the Assembly set up a Special Committee on the case. On 14 December the Council found that the Union of Soviet Socialist Republics 'has placed itself outside the League of Nations.' It is no longer a member.\n\nArgentina brought the motion, citing the League's 1933 definition of aggression. Rudolf Holsti represented Finland.",
            "picture": "league_expulsion_1939",
            "factSheet": "league_expulsion_1939",
            "anchors": [
                "14 December",
                "Argentina",
                "Rudolf Holsti"
            ],
            "fire": {
                "after": "1939.12.14",
                "before": "1940.1.31",
                "chance": 50,
                "trigger": "has_war_with = SOV"
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
                    "name": "Thank Geneva, and look for help elsewhere.",
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
            "desc": "Lieutenant Colonel Aaro Pajari reported to Paavo Talvela at 5 pm on 12 December: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' His Detachment P, part of Group T, has beaten the Soviet 139th Rifle Division. It is the first major Finnish success of the war.\n\nAbout 100 Finns were killed. The Soviet dead are put at ten times as many, and 20 tanks and 60 machine guns were taken. Talvela is promoted to major general and Pajari to colonel.",
            "picture": "tolvajarvi_victory",
            "factSheet": "tolvajarvi_victory",
            "anchors": [
                "Aaro Pajari",
                "Paavo Talvela",
                "139th Rifle Division",
                "12 December"
            ],
            "fire": {
                "after": "1939.12.13",
                "before": "1940.1.31",
                "chance": 50,
                "trigger": "has_war_with = SOV"
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
            "desc": "Herbert Hoover started the Finnish Relief Fund in December. On 20 December he appeared at Madison Square Garden with Hendrik Willem van Loon and Fiorello La Guardia. The fund advertises in 1,400 American newspapers. The proceeds of the first screening of Gone with the Wind in Washington state went to the fund.\n\nBy March the fund has raised 2.5 million dollars.",
            "picture": "finnish_relief_fund",
            "factSheet": "finnish_relief_fund",
            "anchors": [
                "Herbert Hoover",
                "1,400 American newspapers",
                "20 December",
                "Madison Square Garden"
            ],
            "fire": {
                "after": "1940.3.1",
                "before": "1940.4.30",
                "chance": 100,
                "trigger": "has_war_with = SOV"
            },
            "options": [
                {
                    "name": "Spend it on relief at home.",
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
    ],
    "ideas": [
        {
            "key": "maternity_grant",
            "name": "Maternity Grant",
            "desc": "Mothers may take the grant of 450 markkaa per child as goods, as cash or as both.",
            "picture": "generic_political_support",
            "modifier": {
                "monthly_population": 0.05,
                "stability_factor": 0.02
            }
        },
        {
            "key": "industrial_reinvestment",
            "name": "Reinvested Export Profits",
            "desc": "The profits of the record year go into new mills and plants.",
            "picture": "generic_research_bonus",
            "modifier": {
                "production_factory_efficiency_gain_factor": 0.03
            }
        },
        {
            "key": "paris_trade_mission",
            "name": "Paris Trade Mission",
            "desc": "Trade officials follow the timber pavilion to Paris to sell Finnish wood.",
            "picture": "generic_political_support",
            "modifier": {
                "consumer_goods_factor": -0.02
            }
        }
    ]
}
```
