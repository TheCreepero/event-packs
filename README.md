# Event Packs

Small packs of historical flavor events for Hearts of Iron IV, one pack per country, each published on the Steam Workshop as its own item: **Event Pack: <Country>**. Every pack works alone and beside any other pack. The events use real period photographs under free licences, and their texts are built from sourced fact sheets.

## Packs

| Pack | Tag | Events | Workshop |
|---|---|---|---|
| [Finland](wiki/Event-Pack-Finland.md) | FIN | in planning | not yet published |

## How the repository works

```
event-packs/
|-- build.ps1                 # lifecycle and pack commands (Get-Help .\build.ps1)
|-- source/<pack>/            # hand-written: events.json, fact-sheets.md, workshop-intro.bbcode; pictures.json from -FetchPicture
|-- packs/<pack>/             # one Workshop item: descriptor.mod, thumbnail.png and everything -Generate writes
|-- research/<pack>/          # the researcher's dossiers, kept: every candidate event with its sourced facts, used or not
|-- data/                     # effect caps and banned phrases the checks use
|-- docs/                     # style guide, source format, plans
|-- tools/                    # EventPacks.ps1 (pack tools), convert_event_pictures.py, the shared build engine
|-- tests/                    # Pester suites
\-- wiki/                     # one generated page per pack
```

Work goes through the agent skills in `.claude/skills` (mirrored in `.agents/skills`): `event-pack-create`, `event-pack-audit`, `event-pack-implement`, `event-pack-release`. `AGENTS.md` has the rules.

## Commands

```powershell
.\build.ps1 -NewPack -Pack finland -Tag FIN -DisplayName Finland   # a new pack
.\build.ps1 -FetchPicture -Pack finland -File "File:Abatis at Taipale.jpg" -Key abatis -Tone warm
.\build.ps1 -ConvertPictures -Pack finland                         # 210x176 DDS (Python 3 with Pillow)
.\build.ps1 -Generate -Pack finland                                # source -> pack files
.\build.ps1 -Check                                                 # every pack's source and generated files
.\build.ps1 -Audit -Pack finland                                   # scorecard of one pack
.\build.ps1 -ValidateOnly
.\build.ps1 -Test
.\build.ps1 -DevLink -Pack finland                                 # the launcher loads packs/finland
.\build.ps1 -Package                                               # one zip per pack in artifacts/
```

Publishing goes through the Modding Manager: `Scripts\Publish-Mod.ps1 "Event Packs" -Pack <pack>`.

## Picture credits

Each pack's Workshop description and wiki page list the source, author and licence of every picture it uses.

## Author

Eetu Palo
