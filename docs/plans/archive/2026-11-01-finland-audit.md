# Finland pack: audit fixes

Status: DONE
Pack: finland (FIN, namespace ep_fin)
Kind: audit fixes
Created: 2026-11-01

## For the implementer

Carry out "Implementation steps" in order with `.claude/agents/ep-implementer.md`. Everything the steps write is in this file: the `json events` block is the whole `source/finland/events.json`, the `markdown fact-sheets` block holds the sections for `source/finland/fact-sheets.md`, and the picture table gives every `-FetchPicture` call. Decide nothing; stop and report when something does not fit.

## Context

The first audit of the Finland pack (15 events, ep_fin.1 to ep_fin.15, shipped by `2026-10-31-finland-first-events.md`), written by the `event-pack-audit` skill. The pack's facts predate quoted facts (`factQuotesFromId 16`), so every fact of all 15 events was rechecked on its page, every picture's Commons page was reread, and every text went to the editor against the current style guide.

## Audit report

Phase 0: `-Audit -Pack finland` gives 0 errors and 1 warning (facts of events 1 to 15 predate quoted facts). `-Check -Pack finland` passes (`Pack 'finland': 15 event(s), 13 picture(s), 0 error(s)`). Every effect is within the caps.

### Critical

Three facts the recheck dropped are stated in shipped texts:

- **record_year_1937 (ep_fin.6)**: "In the depression years forest products made up over 80 per cent of export earnings." The cited "Bank of Finland study" is in fact the bank commissioners' report for 1936, and the pages read do not state this. The text loses the sentence. The 1937 report's own explanation of the export growth replaces it: good timber prices and more plywood and paper sold abroad.
- **taisto_maki_record (ep_fin.11)**: "At the Olympic Stadium in Helsinki" and "set in Tampere". Only etusuora.com states the venue and Tampere, and it refuses every automated fetch (HTTP 403). en.wikipedia gives the date, the time and "breaking his own world record", but no venue. The text loses both places unless the owner confirms the etusuora page in a browser (see Decisions). Resolved: fi.wikipedia "Taisto Mäki (juoksija)" states both, so the places stay with that quote.
- **league_expulsion_1939 (ep_fin.13)**: "Rudolf Holsti represented Finland." No page names Finland's delegate for December 1939 (AJIL says only "the Delegate of Finland"). The sentence goes. The picture stays: its Commons page says it shows Holsti at the Assembly, but the text does not claim it.

### Important

Shipped texts that state a fact wrongly, or join two facts into a claim no page makes:

- **record_year_1937 (ep_fin.6)**: "an export surplus of 73 million marks" came from a journal.fi article about forest wages that could not be read. The 1937 report, read here page by page, gives a different figure: "Vientienemmyys oli ennakkotietojen mukaan 90.9 milj. markkaa vastaten 853.6 miljoonaa vuonna 1936" (by preliminary figures the export surplus was 90.9 million marks, against 853.6 million in 1936). The text takes the report's figure.
- **olympics_1940_awarded (ep_fin.8)**: Tokyo withdrew on **16 July** 1938, not 14 July (Olympedia and en.wikipedia agree). The IOC awarded Helsinki the Games on **3 September** 1938, yet the window opens on 14 July, so the title can fire before the award. Text fixed; the window opens on 1938.9.3.
- **yartsev_talks_1938 (ep_fin.7)**: no page says the islands are "in the Gulf of Finland" (en.wikipedia: "some islands near Leningrad"). "The demands have changed several times" is not stated: the page says only that the Soviets reduced their demands after Finland rejected the first ones, which came later. Editor REWRITE: "this summer" is prophecy on 1 May, and the narration switches from "Finland" to "us". The window opens on 1938.6.1 (editor's note; the page puts the government's part in "the summer 1938").
- **red_earth_government (ep_fin.2)**: "Tanner backed Kallio in the February election" appears on no page; the Tanner page does not mention Kallio's election. The cooperation sentence stays, from a quoted Yle line. Editor REWRITE: the parties are listed twice.
- **vickers_six_ton_tanks (ep_fin.4)**: "to be fitted with a 37 mm gun adapted from the licence-built Bofors" joins two facts. The page says only that the tanks went to VTT "where they would be equipped with guns", and the gun choice is undated. Editor REWRITE: the gun sentences go, and the schedule miss and the 2-tank HQ come in. The recheck dropped the turret mechanisms, tools and seats that the editor's draft added.
- **holsti_resignation (ep_fin.9)**: Voionmaa was acting minister from 16 November to 1 December 1938 (cabinet table), but the window runs to 11 December. The window ends on 1938.11.30. The editor's REWRITE ("against him" is unsupported) is answered by the recheck: the page says Weizsäcker "accused Holsti for insulting" Hitler, so the sentence stays.
- **league_expulsion_1939 (ep_fin.13)**: "Argentina brought the motion, citing the League's 1933 definition of aggression" rests on an opinion site quoting a commentator. The editor notes that the 1933 definition is the London Convention, not a League text. AJIL: "The delegate of the Argentine in his address of December 13, 1939, stated that the Soviet Union had 'placed itself outside the Covenant'". The text says Argentina's delegate demanded the expulsion on 13 December.
- **maternity_grant_1937 (ep_fin.5)**: Kela says "lapsikuolleisuusluvuista", which is child mortality, not infant mortality. One word changes.
- **tolvajarvi_victory (ep_fin.14)**: editor REWRITE, because the promotions were undated. The recheck dates them with en.wikipedia's "During the battle, Talvela was promoted to Major General and Pajari to full Colonel", and the museum page reads "Ten times as many Russians were killed", so the shipped text holds. The editor's draft line "Detachment P resumed the advance on 13 December" is wrong: the page says "after a day's rest on 13 December". The text stays as shipped and goes back to the editor with the new quote.
- **Three picture licences that `-FetchPicture` accepts but that are doubtful** (all dry runs print `ACCEPTED`, none is deleted or nominated):
  - `berlin_1936_olympics`: tagged PD-anon-70-EU, but the source is a Getty Images agency photo (IOC Olympic Museum), which is unlikely to be anonymous; the page has no US reason.
  - `finnish_relief_fund`: tagged PD-Finland50, but it is a photo of a New York meeting from a forum post; first publication in Finland is not shown.
  - `taisto_maki_record`: CC BY 4.0 from the Finnish Heritage Agency, but the photographer Thérèse Bonney died in 1978. The licence holds only if the agency owns her rights, and Commons has not reviewed it.

### Minor

- `aalto_world_fairs` (ep_fin.3): the page says "prime export", not "chief", and only the winning entry was "Le bois est en marche". The editor kept the text but asked that the sentence name which prize; the fixed text says "won both first and second prize, and the winning entry, 'Le bois est en marche', became the pavilion".
- `sillanpaa_nobel` (ep_fin.12): the window runs to 1939.12.9, past the Soviet attack on 30 November, where a state reception reads oddly. The editor suggests ending it on 1939.11.29.
- `maternity_grant_1937`: the title "Maternity Grant Law Adopted" fires ten weeks after the adoption. The editor kept it. Unchanged.
- `berlin_1936_olympics`: the steeplechase fact moves from Britannica (403) to en.wikipedia, with no change to the text.
- `tolvajarvi_victory` picture: taken 19 March 1940, after the battle, and showing Pajari explaining it. It is on topic. Unchanged.
- Commons still asks for "where first published" on four PD-Finland50 files (`record_year_1937`, `sillanpaa_nobel`, `league_expulsion_1939`, `finnish_relief_fund`). This is a standing template note, not a dispute.

### Intentionally unchanged

- `-Check` passes and every effect matches its option and is within the caps.
- 10 of 13 pictures are plainly within policy. Among them is `record_year_1937`, the thumbnail's background, so the thumbnail stays.
- `berlin_1936_olympics`, `election_1939` and `finnish_relief_fund`: every fact is kept and the editor returned KEEP.
- `sillanpaa_nobel`: its two fixed facts (the ceremony clause, the medal wording) are not in the text.
- The Holsti sentences on Weizsäcker and the cabinet's fear stay, each quoted from the page.

## Decisions

The owner, 2026-11-01:
- Text fixes: apply every Critical and Important text fix, and the window changes: ep_fin.7 opens on 1938.6.1, ep_fin.8 on 1938.9.3, ep_fin.9 ends on 1938.11.30.
- Taisto Mäki venue (ep_fin.11): the owner could not open etusuora either, and pasted fi.wikipedia "Taisto Mäki (juoksija)" instead. The planner confirmed both lines on the live page, so the Olympic Stadium and Tampere stay with those quotes.
- Pictures: keep all three doubtful ones (`berlin_1936_olympics`, `finnish_relief_fund`, `taisto_maki_record`) on judgment. `-FetchPicture` accepts them and Commons has no dispute open. No picture changes, so "Thumbnail" is unchanged.
- Sillanpää window (ep_fin.12): it ends on 1939.11.29.
- No FIX or DROP is declined.
- Planner, as a result of the ep_fin.8 decision: its window also ends on 1938.10.31 instead of 1938.9.15. A start of 3 September with the old end would leave under two weeks, and about two months keeps the window's former length.

## Events

The pack's 15 events, as the `json events` block leaves them. Changed by this plan: the texts of 2, 3, 5, 6, 7, 8, 9, 11, 13, 14 and 15; the title of 6; the windows of 7, 8, 9 and 12; the `maternity_grant` idea text. Effects are unchanged.

| Id | Key | Title | Window | Chance/week | Picture | Effects |
|---|---|---|---|---|---|---|
| 1 | berlin_1936_olympics | Three Finns Take the 10,000 Metres in Berlin | 1936.8.17 to 1936.9.30 | 50 | berlin_1936_olympics | stability +0.02 / political_power +20 |
| 2 | red_earth_government | Cajander Forms a Red-Earth Government | 1937.3.12 to 1937.6.30 | 25 | red_earth_government | stability +0.02 / political_power +30 |
| 3 | aalto_world_fairs | Aalto's Timber Pavilion Stands at the Paris Exposition | 1937.5.25 to 1937.9.1 | 15 | aalto_world_fairs | political_power -20, idea paris_trade_mission 90d / political_power +15 |
| 4 | vickers_six_ton_tanks | The First Vickers Tanks Arrive Without Guns | 1938.7.1 to 1938.9.30 | 15 | vanilla:GFX_report_event_tank_factory | political_power -30, war_support +0.02 / political_power +20 |
| 5 | maternity_grant_1937 | Maternity Grant Law Adopted | 1937.12.1 to 1938.1.31 | 25 | maternity_grant_1937 | political_power -25, idea maternity_grant 180d / stability +0.01 |
| 6 | record_year_1937 | 1937 Was a Record Year | 1938.1.15 to 1938.5.31 | 10 | record_year_1937 | idea industrial_reinvestment 180d / political_power +30 |
| 7 | yartsev_talks_1938 | A Soviet Diplomat Opens Secret Talks | 1938.6.1 to 1938.8.31 | 10 | vanilla:GFX_report_event_generic_conference | political_power +15 / war_support +0.02 |
| 8 | olympics_1940_awarded | Helsinki Is Given the 1940 Olympic Games | 1938.9.3 to 1938.10.31 | 30 | olympics_1940_awarded | political_power -25, stability +0.03 / stability +0.01 |
| 9 | holsti_resignation | Foreign Minister Holsti Resigns | 1938.11.17 to 1938.11.30 | 30 | holsti_resignation | political_power +20 / political_power -20, war_support +0.02 |
| 10 | election_1939 | Social Democrats Win 85 Seats | 1939.7.3 to 1939.8.15 | 50 | election_1939 | stability +0.02 / political_power -25, stability +0.03 |
| 11 | taisto_maki_record | Taisto Mäki Runs 10,000 Metres Under 30 Minutes | 1939.9.17 to 1939.10.31 | 50 | taisto_maki_record | stability +0.01, war_support +0.01 / political_power +15 |
| 12 | sillanpaa_nobel | Sillanpää Awarded the Nobel Prize in Literature | 1939.11.10 to 1939.11.29 | 50 | sillanpaa_nobel | political_power -15, stability +0.02 / political_power +10 |
| 13 | league_expulsion_1939 | The League of Nations Expels the Soviet Union | 1939.12.14 to 1940.1.31 | 50 | league_expulsion_1939 | war_support +0.03 / political_power +25 |
| 14 | tolvajarvi_victory | Detachment P Defeats the Enemy at Tolvajärvi | 1939.12.13 to 1940.1.31 | 50 | tolvajarvi_victory | war_support +0.03 / stability +0.02 |
| 15 | finnish_relief_fund | Hoover's Relief Fund Raises 2.5 Million Dollars | 1940.3.1 to 1940.4.30 | 100 | finnish_relief_fund | stability +0.02 / political_power -15, war_support +0.02 |

## Pictures

No picture changes: the three doubtful licences stay on the owner's judgment (see Decisions), and the rest are within policy.

Thumbnail: unchanged

## Fact verification

Four `ep-audit-researcher` agents ran, all on 2026-11-01:
- Agent 1 checked ep_fin.1 to 5, then made a follow-up for verbatim quotes.
- Agent 2 checked ep_fin.6 to 10.
- Agent 3 checked ep_fin.11 to 15, then made a follow-up for the open quotes.
- Agent 4 checked the 13 pictures.

Agent 2 could not read the PDFs, and several of its quotes were the fetch tool's paraphrase. So the planner read the 1937 and 1936 bank commissioners' reports page by page from their scans. It also searched the raw HTML of en.wikipedia (Boris Rybkin, 1940 Summer Olympics, Helsinki Olympic Stadium, 1939 election, Cajander III cabinet, Taisto Mäki, Battle of Tolvajärvi), Olympedia, alporusi.fi and AJIL for each quoted string. Where that search contradicted a researcher's verdict, the page wins; those facts are marked "(page check)".

Per event, counting fact lines: K = KEEP, F = FIX, D = DROP.

| Event | K | F | D | Fixed and dropped facts |
|---|---|---|---|---|
| berlin_1936_olympics | 2 | 1 | 0 | F: the steeplechase fact moves its source to en.wikipedia "Volmari Iso-Hollo" (Britannica 403) |
| red_earth_government | 3 | 2 | 0 | F: the Kallio fact is split, with the Cajander request quoted from en.wikipedia "Aimo Cajander". F: "surprise" and "with Tanner's support" go; the cooperation stays (Yle) |
| aalto_world_fairs | 1 | 2 | 0 | F: "prime export", and only the winning entry was "Le bois est en marche". F: the New York pavilion is reduced to "1939: Finnish Pavilion" (not in the text) |
| vickers_six_ton_tanks | 3 | 2 | 0 | F: turret mechanisms, tools and seats go. F: VTT fits "guns" only |
| maternity_grant_1937 | 1 | 2 | 0 | F: child mortality, not infant. F: "two-thirds of women giving birth", not of mothers |
| record_year_1937 | 1 | 2 | 1 | F: "a record year in many branches of economic life" (page check, 1937 report). F: the export surplus becomes 90.9 million marks (preliminary) against 853.6 million in 1936, and the 1938 import surplus goes (page check). D: forest products over 80 per cent in the depression years |
| yartsev_talks_1938 | 1 | 2 | 0 | F: "second-class secretary"; the April 1938 Stalin instruction is kept (page check overturns the researcher's FIX). F: "islands near Leningrad"; the demands were "reduced" after a rejection, not "changed several times" |
| olympics_1940_awarded | 3 | 1 | 0 | F: Tokyo withdrew on 16 July 1938 and the IOC awarded Helsinki on 3 September 1938 (Olympedia). The docomomo URL becomes en.docomomo.fi |
| holsti_resignation | 3 | 1 | 0 | F: Voionmaa (Social Democrat, cabinet table) was acting minister from 16 November to 1 December, not until Erkko. The cabinet's fear is kept (page check overturns the researcher's FIX) |
| election_1939 | 4 | 0 | 0 | — |
| taisto_maki_record | 2 | 1 | 0 | F: the previous record (30:02.0, Tampere, 29 September 1938) moves to en.wikipedia and fi.wikipedia "Taisto Mäki (juoksija)" (etusuora 403). The Olympic Stadium is kept from fi.wikipedia: the researcher dropped it, the owner found the page, and the planner checked the quote on it |
| sillanpaa_nobel | 5 | 2 | 0 | F: the Stockholm fact loses "whether a ceremony was held is disputed". F: "donated the golden medal to be melted for funds to aid the war effort" |
| league_expulsion_1939 | 2 | 1 | 1 | F: Argentina's delegate demanded the expulsion on 13 December (AJIL). The Special Committee on 11 December is kept (page check, AJIL footnote 32, overturns the researcher's FIX). D: Holsti as Finland's delegate |
| tolvajarvi_victory | 3 | 1 | 0 | F: a day's rest on 13 December, then the advance; the promotions are dated "during the battle" |
| finnish_relief_fund | 4 | 0 | 0 | — |
| **Total** | **38** | **20** | **2** | |

Pictures: 10 OK and 3 RECHECK (`berlin_1936_olympics`, `finnish_relief_fund`, `taisto_maki_record`). All three print `ACCEPTED` in the dry run, so the doubt is plausibility, not the tool's decision.

## Editor record

Round 1 (audit, the shipped texts): 10 KEEP, 5 REWRITE (red_earth_government, vickers_six_ton_tanks, yartsev_talks_1938, holsti_resignation, tolvajarvi_victory), 0 REJECT. Each REWRITE is weighed above against the recheck, and two of them added facts the recheck dropped. The rewrites are not applied yet; Phase 3 writes the texts from the checked facts and sends them back.

Round 2 (the plan's texts against the quoted fact sheets): 7 KEEP (red_earth_government, record_year_1937, yartsev_talks_1938, olympics_1940_awarded, holsti_resignation, taisto_maki_record, league_expulsion_1939), 7 REWRITE, 1 REJECT (election_1939). Most findings were quotes that stop short of what the text says. The planner checked each page for the fuller line:
- **Quote extended, text unchanged:**
  - berlin_1936_olympics: Iso-Hollo "went to the 1936 Summer Olympics".
  - vickers_six_ton_tanks: "To help save money".
  - election_1939 (the REJECT): the party header row.
- **Quote extended, text adjusted:**
  - tolvajarvi_victory: the report line names Talvela and 5pm, "The Finns captured … 20 tanks", "Soon after the victory, the commander-in-chief promoted". The text adds "in the day's attack".
  - finnish_relief_fund: "The income from first screening". The text says "income".
- **REWRITE applied:**
  - aalto_world_fairs ("formed the basis of").
  - maternity_grant_1937 ("cash or in kind"; the `maternity_grant` idea text too).
  - sillanpaa_nobel ("decided", the translation counts). The planner wrote "Ihmiset suviyössä", the novel's title; the page drops the umlaut, and the fact line notes it.
- **Notes acted on:**
  - record_year_1937: the report's publication date is not in the scan (the cover says "Helsinki 1938"). The text now states the year's facts without saying a report has come out, and the title is "1937 Was a Record Year".
  - yartsev_talks_1938: the window ends on 1938.8.31, since the only timing quote says "the summer 1938".
- **Unseen by round 2:** taisto_maki_record changed after round 2 began (the places came back with the fi.wikipedia quote).

Round 3 (the 11 events changed or extended since round 2, taisto_maki_record included): 11 KEEP, 0 REWRITE, 0 REJECT. Every one of the 15 events is now KEEP in its latest round.

After implementation, the reviewer's M1 (2026-11-01, applied on the owner's word): the ep_fin.2 text said Kallio "has asked" Cajander, but the quote is passive ("Cajander was asked"). The sentence now reads "Kyösti Kallio has been president since 1 March. After his election, Aimo Cajander, chairman of the National Progressive Party, was asked to form a majority government." Editor round 4: REWRITE, because the quote did not carry "After his election". The planner extended the quote on its page with "When Kyösti Kallio was elected president in 1937, …", which keeps the sentence. Steps 1, 2 and 5 to 8 are re-opened for it. Editor round 5: KEEP. The audit report's AJIL wording is also corrected to "outside the Covenant" (the reviewer's M3).

## Kept on judgment

None: the rehearsal's `-Check -Pack finland` printed no warning (`Check OK: 1 pack(s), 0 warning(s)`), and its `-Audit` printed 0 errors and 0 warnings.

## Implementation steps

- [x] 1. Write the events: replace `source/finland/events.json` with the `json events` block below, whole (it drops `factQuotesFromId`).
- [x] 2. Write the fact sheets: replace each section of `source/finland/fact-sheets.md` with the section of the same key in the `markdown fact-sheets` block below (all 15).
- [x] 3. No pictures to fetch.
- [x] 4. Thumbnail unchanged: nothing to run.
- [x] 5. `powershell -File .\build.ps1 -ConvertPictures -Pack finland`: expect `failed=0`.
- [x] 6. `powershell -File .\build.ps1 -Generate -Pack finland`: expect `Generated pack 'finland'`.
- [x] 7. `powershell -File .\build.ps1 -Check -Pack finland`: expect `Check OK`, with no warning outside "Kept on judgment".
- [x] 8. `powershell -File .\build.ps1 -ValidateOnly` then `powershell -File .\build.ps1 -Test`: expect `Validation succeeded.` and no failed test.
- [x] 9. Ship (after the user confirms): move this plan to `docs/plans/archive/`, commit with the message `fix(finland): audit fixes, every fact quoted from its page`, then `powershell -File .\wiki\push-wiki.ps1`.

## Stop conditions

- A picture is `REJECTED`: stop; the planner picks another file or a vanilla picture.
- `-Generate` or `-Check` prints an `[ERROR]`: stop and report it whole.

## Outcome

2026-11-01. `-Check -Pack finland`: `Pack 'finland': 15 event(s), 13 picture(s), 0 error(s)` and `Check OK: 1 pack(s), 0 warning(s).` `-ConvertPictures`: `converted=0 up_to_date=13 failed=0`. `-Generate`: `Generated pack 'finland': 15 event(s), 13 file(s) written, 0 removed.` `-ValidateOnly`: `Validation succeeded.` (its all-pack check printed 3 PD-US picture warnings, all in the france pack). `-Test`: 211 passed, 0 failed. Re-run 2026-11-01 for the ep_fin.2 re-open: only the ep_fin.2 text and its fact line differed in the sources; both were edited to the plan's block, then steps 5 to 8 repeated with the same results (-Generate wrote 10 files). No deviation from the plan; step 9 (ship) left for the caller.

## Fact sheets

Every section replaces the section of the same key in `source/finland/fact-sheets.md`.

```markdown fact-sheets
## berlin_1936_olympics

- In the 10,000 m final at the Berlin Olympics on 2 August 1936, Ilmari Salminen won gold, Arvo Askola silver and Volmari Iso-Hollo bronze. Source: https://en.wikipedia.org/wiki/Athletics_at_the_1936_Summer_Olympics_–_Men's_10,000_metres (Athletics at the 1936 Summer Olympics – Men's 10,000 metres). Quote: «The final was won by Ilmari Salminen of Finland.» (results table: final August 2, 1936; Askola silver 30:15.6, Iso-Hollo bronze 30:20.2)
- Volmari Iso-Hollo won the 3,000 m steeplechase in 1932 and again at Berlin in 1936. Source: https://en.wikipedia.org/wiki/Volmari_Iso-Hollo (Volmari Iso-Hollo). Quote: «won his first Olympic gold medal in the 3000 m steeplechase at the 1932 Summer Olympics» ... «He went to the 1936 Summer Olympics as a favourite. He won the steeplechase by three seconds, finishing with a new world record of 9:03.8»
- In the javelin, Gerhard Stöck of Germany won with 71.84 m; Yrjö Nikkanen took silver with 70.77 m and Kalervo Toivonen bronze with 70.72 m. Source: https://en.wikipedia.org/wiki/List_of_1936_Summer_Olympics_medal_winners (List of 1936 Summer Olympics medal winners). Quote: «Gerhard Stöck Germany 71.84 m» «Yrjö Nikkanen Finland 70.77 m» «Kalervo Toivonen Finland 70.72 m» (javelin row)

## red_earth_government

- Kyösti Kallio took office as president on 1 March 1937, having defeated the incumbent Svinhufvud in the 1937 election. Source: https://en.wikipedia.org/wiki/Kyösti_Kallio (Kyösti Kallio). Quote: «1 March 1937 – 19 December 1940» «defeating incumbent president Pehr Evind Svinhufvud in the subsequent elections of 1937»
- After Kallio's election, Aimo Cajander, chairman of the National Progressive Party, was asked to form a majority government. Source: https://en.wikipedia.org/wiki/Aimo_Cajander (Aimo Cajander). Quote: «When Kyösti Kallio was elected president in 1937, Cajander was asked as the chairman of the National Progressive Party to form majority government.»
- The Cajander III cabinet was formed on 12 March 1937 from the National Progressive Party, the Social Democrats, the Agrarian League and the Swedish People's Party; it was a majority government. Source: https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet). Quote: «It was a majority government.» (cabinet table: formed March 12, 1937; National Progressive Party, Social Democrat, Agrarian League, Swedish People's Party)
- Väinö Tanner of the Social Democrats was finance minister from 12 March 1937. Source: https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet). Quote: «Minister of Finance Väinö Tanner March 12, 1937 – December 1, 1939 Social Democrat»
- The term punamulta (red-earth) originally meant the coalition the Agrarian League, the Social Democrats and the Progressives formed in March 1937. Source: https://tieteentermipankki.fi/!4mv4 (Tieteen termipankki, punamulta). Quote: «alun perin nimenomaan maalaisliiton, SDP:n ja edistyspuolueen maaliskuussa 1937 muodostamasta» (originally specifically of the one the Agrarian League, the SDP and the Progressive Party formed in March 1937)
- In the years of right-wing unrest Kallio and Tanner worked closely together for parliamentary government and democracy. Source: https://yle.fi/a/20-85559 (Yle). Quote: «tekivät oikeistokuohunnan vuosina läheistä yhteistyötä parlamentarismin ja demokratian puolesta» (in the years of right-wing turmoil they worked closely together for parliamentarism and democracy)

## aalto_world_fairs

- Alvar Aalto won both first and second prize in the 1936 open competition for Finland's pavilion at the Paris exposition; the winning entry, 'Le bois est en marche', formed the basis of the pavilion. It was built entirely of timber, an advertisement for Finland's prime export. Source: https://en.wikipedia.org/wiki/Exposition_Internationale_des_Arts_et_Techniques_dans_la_Vie_Moderne (Exposition Internationale des Arts et Techniques dans la Vie Moderne). Quote: «following an open architectural competition held in 1936, where he had won both first and second prize» «the winning entry "Le bois est en marche" forming the basis for the pavilion as built.» «The pavilion was also an advertisement for Finland's prime export, wood, as the building was built entirely of timber.»
- The Paris exposition ran from 25 May to 25 November 1937, with 45 countries taking part. Source: https://en.wikipedia.org/wiki/Exposition_Internationale_des_Arts_et_Techniques_dans_la_Vie_Moderne (Exposition Internationale des Arts et Techniques dans la Vie Moderne). Quote: «was held from 25 May to 25 November 1937 in Paris, France» (infobox: Countries 45)
- Aalto designed the Finnish Pavilion at the 1939 New York World's Fair. Source: https://en.wikipedia.org/wiki/Alvar_Aalto (Alvar Aalto). Quote: «1939: Finnish Pavilion, at the 1939 New York World's Fair»

## vickers_six_ton_tanks

- On 20 July 1936 the Ministry of Defence ordered 32 Vickers-Armstrongs 6-ton tanks (Alternative B), to form a battalion of two 15-tank companies and a 2-tank headquarters element. Source: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish Service). Quote: «The Ministry of Defence placed an order for 32 Vickers-Armstrongs 6-Ton Tank Alternative B on the 20th of July 1936.» «The idea was to form the tanks into a battalion with 2 companies of 15 tanks and a HQ element of 2 tanks.»
- The agreed schedule was 11 tanks by 20 July 1937, 10 by 1 April 1938 and 11 by 1 January 1939; the first tanks were not delivered until July 1938. Source: https://www.jaegerplatoon.net/TANKS2.htm (Finnish tanks). Quote: «20th of July 1937: 11 tanks» «1st of April 1938: 10 tanks» «1st of January 1939: 11 tanks» «The first tanks were not delivered until July of 1938»
- To save money the tanks were ordered without optics, radios or armament, at 4,500 pounds each. Source: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish Service). Quote: «To help save money, the tanks were ordered without optics, radios or even armament.» «This brought the price of each tank to only £4,500 each»
- After arrival the tanks went to the State Artillery Factory, Valtion Tykkitehdas (VTT), to be equipped with guns. Source: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish Service). Quote: «transported to Valtion Tykkitehdas (VTT/ State Artillery Factory) where they would be equipped with guns»
- The Finns opted for a licence-built 37 mm Bofors anti-tank gun; the 47 mm gun Vickers offered lacked penetration. Source: https://tanks-encyclopedia.com/ww2/finland/vickers-6-ton-in-finnish-service/ (Vickers 6-ton in Finnish Service). Quote: «they opted for a licensed produced version of the 37mm Bofors anti-tank gun» «lacked penetration against armored and bunker targets and thus was deemed unsuitable for Finnish use»

## maternity_grant_1937

- The maternity grant law was adopted on 24 September 1937 and took effect on 1 January 1938. Source: https://blogs.loc.gov/law/2022/12/collection-highlights-the-finnish-baby-box-at-85-years-old/ (Collection Highlights: The Finnish Baby Box at 85 Years Old). Quote: «The law was adopted on September 24, 1937, and entered into force on January 1, 1938.»
- Behind the grant was concern over the falling birth rate and high child mortality. Source: https://www.kela.fi/aitiysavustus-historia (Äitiysavustuksen historia). Quote: «Taustalla oli huoli vähenevästä syntyvyydestä ja suurista lapsikuolleisuusluvuista.» (behind it was concern about the falling birth rate and high child mortality figures)
- The grant was worth 450 markkaa per child, paid as money or in kind, at first to mothers of low income; in 1938 about two-thirds of women giving birth received it. Source: https://www.kela.fi/aitiysavustus-historia (Äitiysavustuksen historia). Quote: «Silloin äitiysavustuksen arvo oli 450 markkaa kutakin syntyvää lasta kohden.» (the grant was worth 450 markka for each child born) «vähävaraisille synnyttäjille» (to women of low income giving birth) «raha- tai luontaisavustuksena» (as a cash or in-kind benefit) «Vuonna 1938 äitiysavustuksen sai noin kaksi kolmasosaa synnyttäjistä.» (in 1938 about two-thirds of women giving birth received the grant)

## record_year_1937

- The parliamentary bank commissioners' report for 1937 called it a record year in many branches of the economy, marked by sharply rising prices, brisk industrial investment, growing industrial output and a good harvest; industrial activity was at record levels. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937, p. 3). Quote: «lukuisilla talouselämän aloilla siitä tulikin ennätysvuosi. Leimansa se sai voimakkaasti nousevista hinnoista, teollisuudessa tapahtuvan investoinnin vilkkaudesta ja teollisen tuotannon laajenemisesta, hyvästä sadosta» (in many branches of economic life it became a record year. It was marked by sharply rising prices, brisk investment in industry and the growth of industrial output, a good harvest) «Teollisuustoiminta oli ennätyksellisen vilkasta» (industrial activity was at record levels)
- From 1936 to 1937 sulphate pulp exports rose from 323,200 to 355,700 tonnes and sulphite pulp exports from 757,600 to 823,600 tonnes. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937, p. 5). Quote: «sulfaattiselluloosan vienti 323,200 tonnista 355,700 tonniin eli 10 %, sulfiittiselluloosan vienti 757,600 tonnista 823,600 tonniin eli 9 %» (sulphate pulp exports from 323,200 to 355,700 tonnes, or 10 per cent, sulphite pulp exports from 757,600 to 823,600 tonnes, or 9 per cent)
- Exports grew first of all on good timber prices and the growth of plywood and paper exports. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937, p. 6). Quote: «Viennin lisääntyminen johtui ensi sijassa puutavaroiden hyvistä hinnoista sekä faneerin ja erilaisten paperiteollisuustuotteiden viennin laajenemisesta.» (the growth of exports was due first of all to good timber prices and the growth of exports of plywood and various paper products)
- By preliminary figures the export surplus for 1937 was 90.9 million marks, against 853.6 million in 1936. Source: https://publications.bof.fi/bitstream/10024/42567/1/Eduskunnan_pankkivaltuusmiesten_kertomus_1937_001.pdf (Eduskunnan pankkivaltuusmiesten kertomus 1937, p. 7). Quote: «Vientienemmyys oli ennakkotietojen mukaan 90.9 milj. markkaa vastaten 853.6 miljoonaa vuonna 1936» (by preliminary figures the export surplus was 90.9 million marks, against 853.6 million in 1936)

## yartsev_talks_1938

- Boris Rybkin had been posted in 1935 as a second-class secretary at the Soviet embassy in Helsinki under the name Boris Yartsev; in April 1938 Stalin gave him the mission of starting secret negotiations with the Finnish government. Source: https://en.wikipedia.org/wiki/Boris_Rybkin (Boris Rybkin). Quote: «In September 1935, Rybkin was posted as a second-class secretary to the Soviet embassy in Helsinki under the name Boris Yartsev. In April 1938, Joseph Stalin gave Rybkin the mission of starting secret negotiations with the Finnish government to address the threat from Nazi Germany.»
- The Soviet Union offered all possible economic and military assistance if Finland fought a German invasion, demanded that Finland cede or lease some islands near Leningrad, and agreed to permit Finland to fortify Åland. Source: https://en.wikipedia.org/wiki/Boris_Rybkin (Boris Rybkin). Quote: «The Soviet Union offered all possible economic and military assistance if Finland fought against Germany in the event of German invasion while demanding that Finland cede or lease some islands near Leningrad to the Soviet Union and agreeing to permit the Finnish fortification of Åland.»
- Members of the Cajander government took part in the talks in summer 1938 while Foreign Minister Rudolf Holsti was away. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War). Quote: «The members of the Cajander government participated in the talks during the absence of Holsti in the summer 1938»

## olympics_1940_awarded

- At the IOC session in Berlin on 31 July 1936 the 1940 Games were awarded to Tokyo, by 36 votes to 27 over Helsinki; Tokyo withdrew as host on 16 July 1938, and on 3 September 1938 the IOC Executive Board, meeting in Brussels, officially awarded the Games to Helsinki. Source: https://www.olympedia.org/editions/51 (Olympedia, 1940 Summer Olympics). Quote: «At the 36th IOC Session in Berlin, on 31 July 1936, the Games were awarded to Tokyo, Japan, by a vote of 36-27 over Helsinki, Finland.» «On 16 July 1938, Tokyo withdrew as host.» «On 3 September 1938, at the IOC Executive Board meeting in Bruxelles, the Games were officially awarded to Helsinki.»
- The Helsinki Olympic Stadium was designed by Yrjö Lindegren and Toivo Jäntti; construction began on 12 February 1934 and the stadium opened on 12 June 1938. Source: https://en.wikipedia.org/wiki/Helsinki_Olympic_Stadium (Helsinki Olympic Stadium). Quote: «Architects Yrjö Lindegren and Toivo Jäntti» «Groundbreaking 12 February 1934» «Opened 12 June 1938» (infobox)
- The stadium tower is 72.71 m tall, the length of Matti Järvinen's gold-medal javelin throw at the 1932 Olympics. Source: https://en.wikipedia.org/wiki/Helsinki_Olympic_Stadium (Helsinki Olympic Stadium). Quote: «The tower of the stadium, a distinct landmark with a height of 72.71 metres (238.5 ft), a measurement of the length of the gold-medal win by Matti Järvinen in javelin throw of 1932 Summer Olympics.»
- The stadium opened unfinished in 1938, to be completed for the 1940 Games. Source: https://en.docomomo.fi/?p=428 (Olympic Buildings). Quote: «was inaugurated in an incomplete state in 1938, but was completed ready for the 1940 Olympics.»

## holsti_resignation

- Foreign Minister Rudolf Holsti resigned on 17 November 1938 (the cabinet table gives 16 November); Väinö Voionmaa, a Social Democrat, was acting foreign minister from 16 November to 1 December 1938, and Eljas Erkko took office on 12 December 1938. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War); https://en.wikipedia.org/wiki/Cajander_III_cabinet (Cajander III cabinet). Quote: «resigned from the government on November 17, 1938» «Rudolf Holsti Väinö Voionmaa (deputy) Eljas Erkko March 12, 1937 – November 16, 1938 November 16, 1938 – December 1, 1938 December 12, 1938 – December 1, 1939 National Progressive Party Social Democrat National Progressive Party»
- The most important cause, by this account, was a two-year campaign by Nazi Germany against Holsti; the German envoy Wipert von Blücher reported afterwards: 'our campaign (Aktio) of two years has been completed successfully.' Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War). Quote: «the hounding operation of Nazi-Germany to overthrow Holsti was without any doubt the most important cause which lasted two years. Blücher wrote in his report after the resignation that "our campaign (Aktio) of two years has been completed successfully".»
- State Secretary Ernst von Weizsäcker accused Holsti of insulting the Reich Chancellor; the Finnish envoy Aarne Vuorimaa conveyed his comments in a confidential report of 7 November 1938 to Kallio and Cajander, and the Cajander government, afraid of German repercussions, wanted Holsti to resign. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War). Quote: «State-secretary accused Holsti for insulting "State Chancellor" (Reichskanzler) with flagrant comments» «he prepared a confidential report on November 7, which was given to President Kyösti Kallio and Prime Minister A. K. Cajander. In his report Vuorimaa insulted his own minister and conveyed Weizsäcker's comments without any reservations.» «the Cajander government was afraid of the repercussion of Nazi-Germany and wanted Holsti to resign.»
- A deep-rooted view blames a diplomatic misstep at a dinner in Geneva on 26 September 1938; the author says someone misunderstood Holsti's translation of excerpts of Hitler's speech. Source: https://www.alporusi.fi/blogi/rudolf-holstis-1938-resignation-weakened-diplomatic-chances-to-avoid-the-winter-war (Rudolf Holsti's 1938 resignation weakened diplomatic chances to avoid the Winter War). Quote: «A deep-rooted stand is still insisting that the cause of the resignation was Holsti's "diplomatic misstep" during the diplomatic dinner in Geneva on September 26, 1938» «Somebody had "misunderstood" Holsti's translation and mixed Hitler's hostile words to be Holsti's own words about Hitler.»

## election_1939

- The parliamentary election was held on 1 and 2 July 1939; turnout was 66.55 per cent (1,302,348 votes of 1,956,807 registered voters). Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election). Quote: «Parliamentary elections were held in Finland on 1 and 2 July 1939.» «Total votes 1,302,348 100.00 Registered voters/turnout 1,956,807 66.55»
- Seats: Social Democrats 85 (39.77 per cent of the vote), Agrarian League 56 (22.86 per cent), National Coalition 25, Swedish People's Party 18, IKL 8, National Progressive Party 6. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election). Quote: «Party SDP Agrarian National Coalition Last election 83 seats, 38.59% 53 seats, 22.41% 20 seats, 10.36% Seats won 85 56 25 Seat change 2 3 5 Popular vote 515,980 296,529 176,215 Percentage 39.77% 22.86% 13.58%» «Party RKP IKL National Progressive» «Seats won 18 8 6»
- IKL received 86,219 votes. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election). Quote: «Popular vote 124,720 86,219 62,387» (RKP, IKL, National Progressive)
- Cajander's government continued in office after the election. Source: https://en.wikipedia.org/wiki/1939_Finnish_parliamentary_election (1939 Finnish parliamentary election). Quote: «Following the elections, the National Progressive Party-led government of Aimo Cajander continued in office.»

## taisto_maki_record

- Taisto Mäki ran 10,000 m in 29:52.6 on 17 September 1939, breaking his own world record; he was the first man to run the distance in under 30 minutes. Source: https://en.wikipedia.org/wiki/Taisto_Mäki (Taisto Mäki). Quote: «Mäki was the first man to run 10,000 metres in less than 30 minutes, breaking his own world record in a time of 29:52.6 on 17 September 1939.»
- His first 10,000 m world record was 30:02.0, set in Tampere on 29 September 1938, beating Ilmari Salminen's record by more than three seconds. Source: https://en.wikipedia.org/wiki/Taisto_Mäki (Taisto Mäki); https://fi.wikipedia.org/wiki/Taisto_Mäki_(juoksija) (Taisto Mäki (juoksija)). Quote: «On 29 September 1938, less than four weeks after winning in Paris, Mäki broke the 10,000 metres world record for the first time, beating Ilmari Salminen's old record by more than three seconds in a time of 30:02.0.» «Mäki juoksi 10 000 metrin maailmanennätyksen ensimmäisen kerran 29. syyskuuta 1938 Tampereella.» (Mäki first ran the 10,000 m world record on 29 September 1938 in Tampere.)
- The 29:52.6 run was at the Helsinki Olympic Stadium. Source: https://fi.wikipedia.org/wiki/Taisto_Mäki_(juoksija) (Taisto Mäki (juoksija)). Quote: «Kuuluisimman juoksunsa Mäki juoksi Helsingin olympiastadionilla 17. syyskuuta 1939. Tuolloin hän juoksi 10 000 metriä aikaan 29.52,6.» (Mäki ran his most famous race at the Helsinki Olympic Stadium on 17 September 1939. He then ran 10,000 metres in 29.52,6.)

## sillanpaa_nobel

- The Swedish Academy decided on 10 November 1939 to award Frans Eemil Sillanpää the Nobel Prize in Literature for 1939; he is the first Finnish laureate. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature). Quote: «On 10 November 1939 the Swedish Academy decided» «He is the first and the only Finnish recipient of the prize.»
- The citation praises his 'deep understanding of his country's peasantry'. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature). Quote: «for his deep understanding of his country's peasantry»
- His novels include Hurskas kurjuus (1919) and Nuorena nukkunut (1931); during the 1930s Nuorena nukkunut was translated into seventeen languages, Miehen tie and Ihmiset suviyössa into eight. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit). Quote: «his novel Hurskas kurjuus (1919; English translation Meek Heritage, 1938)» «But in 1931, with the publication of Sillanpää's novel Nuorena nukkunut» «During the 1930s Nuorena nukkunut was translated into seventeen languages, Miehen tie and Ihmiset suviyössa into eight» (the page drops the umlaut; the novel's title is Ihmiset suviyössä)
- Hermann Hesse had the most support at first, but conservative academicians found his work 'anarchic'; Johan Huizinga was also in contention (Kjell Espmark, quoted by the source). Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit). Quote: «At first Hesse had the most support» «anarchic»
- Sillanpää travelled to Stockholm to receive the prize; academician Per Hallström addressed him, remembering the Finnish nation 'with feelings of admiration and horror'. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit). Quote: «with feelings of admiration and horror»
- He stayed in Sweden and raised funds for Finland. Source: https://www.booksfromfinland.fi/?p=32120 (The Nobel pursuit). Quote: «Sillanpää stayed in Sweden and devoted all his energy and newly won authority to raising funds for the Finns»
- He donated the gold medal to be melted down for funds for the war effort. Source: https://en.wikipedia.org/wiki/1939_Nobel_Prize_in_Literature (1939 Nobel Prize in Literature). Quote: «Sillanpää donated the golden medal to be melted for funds to aid the war effort.»

## league_expulsion_1939

- On 11 December 1939 the League Assembly, having heard the delegate of Finland, set up a Special Committee to study Finland's appeal; the Council expelled the Soviet Union on 14 December. Source: https://www.cambridge.org/core/journals/american-journal-of-international-law/article/was-the-soviet-union-expelled-from-the-league-of-nations/A5C41801CC250E9FE0E36DEB41DF030C (Was the Soviet Union Expelled from the League of Nations?, AJIL, note 32); https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations). Quote: «On December 11, 1939, the Assembly, having heard the statement of the Delegate of Finland, decided to set up a Special Committee to study the appeal of the Finnish Government.» (msu: Council resolution of December 14, 1939)
- The Council's resolution: 'Finds that, by its act, the Union of Soviet Socialist Republics has placed itself outside the League of Nations. It follows that the Union of Soviet Socialist Republics is no longer a Member of the League.' Source: https://soviethistory.msu.edu/1939/soviet-territorial-annexations/soviet-territorial-annexations-texts/expulsion-of-the-ussr-from-the-league-of-nations/ (Expulsion of the USSR from the League of Nations). Quote: «Finds that, by its act, the Union of Soviet Socialist Republics has placed itself outside the League of Nations.» «It follows that the Union of Soviet Socialist Republics is no longer a Member of the League.»
- On 13 December 1939 the delegate of Argentina told the Assembly that the Soviet Union had 'placed itself outside the Covenant' and demanded its expulsion from the League. Source: https://www.cambridge.org/core/journals/american-journal-of-international-law/article/was-the-soviet-union-expelled-from-the-league-of-nations/A5C41801CC250E9FE0E36DEB41DF030C (Was the Soviet Union Expelled from the League of Nations?, AJIL, note 32). Quote: «The delegate of the Argentine in his address of December 13, 1939, stated that the Soviet Union had "placed itself outside the Covenant" and, demanding "the expulsion of the Soviet Union from the League of Nations,"»

## tolvajarvi_victory

- On 12 December 1939 Lieutenant Colonel Aaro Pajari's Detachment P, under Paavo Talvela's Group T, defeated the Soviet 139th Rifle Division at Tolvajärvi, the first major Finnish victory of the war. Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «subordinate to Paavo Talvela's Group T, defeated an enemy rifle division on 12 December» «the first major Finnish victory of the Winter War» (the page names the 139th Rifle Division and Lieutenant Colonel Pajari)
- Pajari reported to Talvela at 5 pm on 12 December: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' Source: https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «Lieutenant Colonel Pajari reported to Talvela on the day's battles at 5pm on 12 December as follows: "Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.»
- During the battle, or soon after the victory, Talvela was promoted to major general and Pajari to colonel; after a day's rest on 13 December Detachment P advanced and reached the Ägläjärvi front on 17 December. Source: https://en.wikipedia.org/wiki/Battle_of_Tolvajärvi (Battle of Tolvajärvi); https://talvisota.fi/en/battles/tolvajarvi%e2%88%92ilomantsi/victory-at-tolvajarvi/ (Victory at Tolvajärvi). Quote: «During the battle, Talvela was promoted to Major General and Pajari to full Colonel.» «Soon after the victory, the commander-in-chief promoted Talvela to major general and Pajari to colonel.» «after a day's rest on 13 December» «The Finnish forces advanced to the front of Ägläjärvi (Yaglyayarvi) on 17 December»
- About 100 Finns were killed in the day's attack and ten times as many Soviet soldiers in the battle; 20 tanks and 60 machine guns were captured (one museum source; other accounts differ). Source: https://infotaulu.museomilitaria.fi/en/winter-war/examples-from-ladoga-karelia (Winter war). Quote: «Finnish casualties in the day's attack were about 100 killed. Ten times as many Russians were killed in the battle.» «The Finns captured guns worth of two artillery batteries, 20 tanks and 60 machine guns.»

## finnish_relief_fund

- Herbert Hoover started the Finnish Relief Fund in December 1939. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund). Quote: «initiated by former U.S. President Herbert Hoover in December 1939»
- By March 1940 the fund had raised 2.5 million dollars; it advertised in 1,400 American newspapers. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund). Quote: «By March 1940, it had raised 2.5 million US dollars.» «advertised in 1,400 newspapers across the United States»
- Hoover, Hendrik Willem van Loon and Fiorello La Guardia appeared at Madison Square Garden on 20 December 1939. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund). Quote: «Herbert Hoover, Hendrik Willem van Loon and Fiorello H. La Guardia in Madison Square Garden on December 20, 1939.»
- The income from the first screening of Gone with the Wind in Washington state went to the fund. Source: https://en.wikipedia.org/wiki/Finnish_Relief_Fund (Finnish Relief Fund). Quote: «The income from first screening of the film Gone with the Wind in the state of Washington was forwarded to the relief fund»
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
            "desc": "Kyösti Kallio has been president since 1 March. After his election, Aimo Cajander, chairman of the National Progressive Party, was asked to form a majority government. The cabinet formed on 12 March joins the Progressives, the Social Democrats, the Agrarian League and the Swedish People's Party. The first three are called punamulta, red-earth.\n\nVäinö Tanner of the Social Democrats takes the finance ministry. In the years of right-wing unrest, Kallio and Tanner worked closely together for parliamentary government and democracy.",
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
            "desc": "The Paris exposition opened on 25 May, with 45 countries taking part. It runs until 25 November.\n\nFinland's pavilion is the work of Alvar Aalto, who won both first and second prize in last year's open competition. His winning entry, 'Le bois est en marche', formed the basis of the pavilion. It is built entirely of timber, an advertisement for Finland's prime export.",
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
            "desc": "The first Vickers-Armstrongs 6-ton tanks have arrived. The Ministry of Defence ordered 32 on 20 July 1936, to form a battalion of two 15-tank companies and a 2-tank headquarters element. Eleven were due by 20 July 1937.\n\nTo save money, the tanks were ordered without optics, radios or armament, at 4,500 pounds each. They now go to the State Artillery Factory, Valtion Tykkitehdas, to be equipped with guns.",
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
            "desc": "A law adopted on 24 September gives mothers of low income a maternity grant from 1 January 1938. The grant is worth 450 markkaa per child, paid as cash or in kind.\n\nThe law answers concern over the falling birth rate and high child mortality.",
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
            "title": "1937 Was a Record Year",
            "desc": "1937 was a record year in many branches of the economy, with sharply rising prices, brisk industrial investment and a good harvest. Industrial activity reached record levels. Sulphate pulp exports rose from 323,200 to 355,700 tonnes, and sulphite pulp from 757,600 to 823,600 tonnes.\n\nExports grew first of all on good timber prices and larger sales of plywood and paper abroad. By preliminary figures the export surplus was 90.9 million marks, against 853.6 million in 1936.",
            "picture": "record_year_1937",
            "factSheet": "record_year_1937",
            "anchors": [
                "355,700 tonnes",
                "823,600 tonnes",
                "90.9 million marks"
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
            "desc": "Tokyo won the 1940 Games over Helsinki by 36 votes to 27 at Berlin in 1936, but on 16 July it withdrew as host. On 3 September the IOC Executive Board, meeting in Brussels, officially awarded the Games to Helsinki.\n\nThe Helsinki Olympic Stadium, designed by Yrjö Lindegren and Toivo Jäntti, opened on 12 June, still unfinished. Its tower stands 72.71 m, the length of Matti Järvinen's winning javelin throw at the 1932 Games. The stadium is to be completed for 1940.",
            "picture": "olympics_1940_awarded",
            "factSheet": "olympics_1940_awarded",
            "anchors": [
                "Tokyo",
                "16 July",
                "Yrjö Lindegren",
                "Toivo Jäntti",
                "72.71 m"
            ],
            "fire": {
                "after": "1938.9.3",
                "before": "1938.10.31",
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
            "desc": "On 10 November the Swedish Academy decided to award Frans Eemil Sillanpää the Nobel Prize in Literature for 1939, for his 'deep understanding of his country's peasantry'. He is the first Finn to win it.\n\nHis novels include Hurskas kurjuus of 1919 and Nuorena nukkunut of 1931. During the 1930s Nuorena nukkunut was translated into seventeen languages, and Miehen tie and Ihmiset suviyössä into eight.",
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
                "before": "1939.11.29",
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
            "desc": "Geneva has answered our appeal. On 11 December the Assembly heard Finland's delegate and set up a Special Committee to study the appeal. On 13 December the delegate of Argentina demanded the expulsion of the Soviet Union.\n\nOn 14 December the Council found that the Union of Soviet Socialist Republics 'has placed itself outside the League of Nations.' It is no longer a member.",
            "picture": "league_expulsion_1939",
            "factSheet": "league_expulsion_1939",
            "anchors": [
                "14 December",
                "Argentina",
                "Special Committee"
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
            "desc": "Lieutenant Colonel Aaro Pajari reported to Paavo Talvela at 5 pm on 12 December: 'Today, I have attacked and defeated the enemy in Tolvajärvi, and the enemy has retreated with heavy losses to the east.' His Detachment P, part of Group T, has beaten the Soviet 139th Rifle Division. It is the first major Finnish victory of the war.\n\nAbout 100 Finns were killed in the day's attack. The Soviet dead in the battle are put at ten times as many, and 20 tanks and 60 machine guns were captured. Talvela is promoted to major general and Pajari to colonel.",
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
            "desc": "Herbert Hoover started the Finnish Relief Fund in December. On 20 December he appeared at Madison Square Garden with Hendrik Willem van Loon and Fiorello La Guardia. The fund advertises in 1,400 American newspapers. The income from the first screening of Gone with the Wind in Washington state went to the fund.\n\nBy March the fund has raised 2.5 million dollars.",
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
            "desc": "Mothers may take the grant of 450 markkaa per child as cash or in kind.",
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
