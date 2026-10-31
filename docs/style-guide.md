# Event text style guide

How the events of every pack read. The writer (the main session in the `event-pack-create` skill) follows it, and the `ep-editor` agent judges against it. `build.ps1 -Check` enforces the mechanical part: `data/banned-phrases.txt`, the forbidden characters, lengths and anchors. Everything else in this guide is judgment, and the editor's job.

This is a living document. When the owner rewrites or rejects a text, record the reason here as a rule or an example; when a new tic appears twice, add it to `data/banned-phrases.txt`.

## The voice

A government clerk or a newspaper of the time writes the event: someone who saw it happen and has no idea how the war ends. Dry, concrete and specific. The player reads several events an hour, so each one says one thing and stops.

- **Concrete before abstract.** Name the people, places, dates, numbers and objects from the fact sheet. "Engineers mark the line between Summa and Taipale" rather than "the nation prepares its defences".
- **Short declarative sentences.** Subject, verb, object. One idea per sentence. Vary the length a little; no sentence over about 30 words.
- **Past or present tense, never prophecy.** The event happens now. No hindsight ("little did they know"), no foreshadowing of the Winter War in 1936, no verdict of history.
- **No moral.** Do not end with a reflection on what it all means. The last sentence is a fact, a consequence, or the question the government faces.
- **No inflation.** The event is as big as it was. A sports result is a sports result, not "a moment that defined a generation".
- **Plain words.** Prefer "began" to "commenced", "ships" to "vessels", "said" to "declared" unless someone did declare something.
- **The player's country is "we" only where vanilla would use it**: in the government's own voice ("our delegation"), never in narration about the people ("our brave farmers").
- **A question at the end is allowed** when the options are a real choice, as vanilla does (`finland.1.d`: "How should we respond?").

## Structure of an event

| Part | Rule |
|---|---|
| Title | A headline: who or what, and what happened. At most 60 characters. No colon subtitles, no puns. |
| Description | 40 to 170 words, one to three paragraphs (`\n\n` between paragraphs). At least two anchors from the fact sheet appear word for word. |
| Options | One short sentence each, at most 12 words, in the voice of the government or the people deciding. Each option is a different attitude, not the same one reworded. |
| Effects | Small (`data/effect-caps.json`); the option text matches the effect. The option that spends political power sounds like it costs something. |

Option names follow vanilla's habit of a spoken reaction: "We will hold.", "Send them home before the harvest.", "Interesting." Avoid slogans ("Embrace our destiny"), self-description ("A wise choice") and stage directions ("[Accept the offer]").

## Facts

- The description uses only facts from the event's section of `source/<pack>/fact-sheets.md`. A detail that is not in the fact sheet is cut, however plausible it sounds.
- Names keep their native spelling, with diacritics (Mannerheim, Suojeluskunta, Mäntsälä). A Finnish place with an established Swedish or English name of the period uses the name the fact sheet gives.
- Numbers come from the fact sheet as written. Round only where the source rounds.
- Quotations come only from the fact sheet, with who said them. Inside a text use single quotes: the localisation format reserves the double quote.

## What generic machine prose looks like, and the cure

| Symptom | Example | Cure |
|---|---|---|
| Abstract nouns doing the work | "a testament to national resilience" | Say what people did: "two thousand volunteers dug for six weeks" |
| Triplets | "courage, unity and determination" | Keep the one that is a fact, drop the rest |
| Not X but Y | "not just a race, but a statement" | Say what it was |
| Closing moral | "It serves as a reminder that..." | End on the last fact |
| Scene-setting cliche | "In the heart of Helsinki..." | "In Helsinki..." or just the street name |
| Weather as mood | "As grey clouds gathered over the capital..." | Weather only when it matters to the event (the rain filling the ditches) |
| Emotional verdicts | "The nation held its breath" | What people did: "crowds filled the Senate Square" |
| Hedged significance | "This may well mark a turning point" | Drop it; the player decides what matters |
| Dashes for drama | "The line held, for now" with a dash | A full stop |

## Exemplars

Read these before writing; they set the register. Vanilla texts come from the game's `localisation/english/events_l_english.yml` (line numbers from game 1.19.4.1), with the scripted names (`[195.GetName]`, `[FROM.GetNameDef]`) filled in as the game shows them.

**Vanilla, `finland.1.d` (line 637).** A demand, the evidence, the question:

> Citing the need to create a security buffer for Leningrad, officials from the Soviet Union have asked for a revision of our borders. They want us to cede Karelia to them, and judging by the build-up of Soviet forces along our border, they will not take no for an answer. How should we respond?

**Vanilla, `finland.4.d` (line 651).** A short report of a refusal, with the reason, and nothing added:

> The Swedish government has responded negatively to our request for aid in the war against the Soviet Union. Preferring to remain neutral to avoid international and internal repercussions, they are so far opposed to contributing to the war in any way.

**Third Reich Events, `tre.95625.desc`** (human-written, quoted here for study only, never shipped). A chronicle entry: date, names, places, what was done, the consequence:

> In the dead of the winter of 1940, the remains of Napoleon II, the only son of the Emperor Napoleon, were transferred from their burial place in Vienna to the dome of Les Invalides in Paris. This was done as a gift to France by Adolf Hitler. [...] The gesture was intended to win the support of the French people, but only managed to precipitate a political crisis at Vichy, where Marshal Petain ordered the pro-German Deputy Prime Minister Pierre Laval arrested.

Note what these do not do: none explains why the event matters, none uses an adjective of praise or blame, and each ends on a fact or a decision.

## Editor's checklist

The `ep-editor` agent returns, per event, KEEP, REWRITE (with the new text) or REJECT, judged on:

1. Every claim is in the fact sheet.
2. The text sounds like the period, not like a summary written afterwards.
3. No symptom from the table above.
4. The options are different attitudes and match their effects.
5. Read aloud, no sentence is there only for rhythm or mood.
