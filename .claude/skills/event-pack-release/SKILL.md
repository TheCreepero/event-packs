---
name: event-pack-release
description: >-
  Use when publishing one Event Packs country pack to the Steam Workshop as "Event Pack: <Country>": a first
  upload, an update or a Workshop description change. Extends the shared hoi4-mod-release skill with the
  per-pack preflight, the in-game check of the pack's events and the picture credit check.
disable-model-invocation: true
---

# Event Pack: release a pack

Each pack is its own Workshop item. Follow the shared `hoi4-mod-release` skill, section "Repos with packages", with these additions. Every command names the pack: `-Pack <key>`.

## 1. Preflight
1. `powershell -NoProfile -File "<Manager root>\Scripts\Publish-Mod.ps1" "Event Packs" -Pack <key> -PreflightOnly`. Done when no row is FAIL.
2. `powershell -File .\build.ps1 -Audit -Pack <key>`: no `[ERROR]`. A `[WARN]` that a picture's licence was last read over 180 days ago: fetch it again for real, `powershell -File .\build.ps1 -FetchPicture -Pack <key> -File "<its commonsTitle>" -Key <its key>` (it keeps the recorded crop and tone), then `-ConvertPictures` and `-Generate`, and commit before the release; a `REJECTED` stops the release.
3. `Test-HoiKnowledge.ps1 -Repo event-packs -Detailed` (the `hoi4-modding-knowledge` skill): the sweep queue is empty.
4. Any picture whose Commons page lists restrictions (the audit prints them as `[WARN]`): the owner has looked at it and agreed.

## 2. In-game check
1. `powershell -File .\build.ps1 -DevLink -Pack <key>`.
2. Ask the owner to start a game as the pack's country with only this pack enabled (plus their usual playset if they want), and to run `event ep_<tag>.<id>` in the console for each new or changed event: picture, title, text and options as planned, effects as the tooltip shows them.
3. Read `Documents\Paradox Interactive\Hearts of Iron IV\logs\error.log` for lines naming `ep_<tag>` or the pack's files. Done when the owner reports what they saw and the log has no such line.

## 3. Change note and credits
1. The change note names the events added or changed, by title.
2. The pack's `WORKSHOP_DESCRIPTION_GUIDELINES.md` lists a credit for every picture used (generated); for a CC BY picture the credit names the author and links the licence. When the file changed since the pack's last tag (`git diff workshop-<key>-<date>..HEAD --stat -- packs/<key>/WORKSHOP_DESCRIPTION_GUIDELINES.md`), the upload takes `-UpdateDescription`, so the credits on Steam stay complete.

## 4. Upload and tag
1. `Publish-Mod.ps1 "Event Packs" -Pack <key> -DryRun -ChangeNote "<note>"`: show the owner the VDF (title `Event Pack: <Country>`) and the file list (only that pack's content, descriptor and thumbnail).
2. Give the owner the upload command for their own terminal: `powershell -NoProfile -File "<Manager root>\Scripts\Publish-Mod.ps1" "Event Packs" -Pack <key> -ChangeNote "<note>"`, with `-UpdateDescription` per step 3.2.
3. A first upload writes the new id into `packs/<key>/descriptor.mod`: ask the owner to commit it. The command tags `workshop-<key>-<date>`; pushing the tag is the owner's call.
