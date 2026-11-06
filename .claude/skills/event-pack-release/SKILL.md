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
1. `powershell -File .\build.ps1 -DevLink -Pack <key>`, and `powershell -File .\build.ps1 -TestMod -Pack <key>` for the console commands.
2. Ask the owner to start a game as the pack's country with only this pack and "Event Packs Test (dev only)" enabled (plus their usual playset if they want), and to run `event ep_<tag>.<id>` in the console for each new or changed event, or `ep_<tag>_all` for every event: picture, title, text and options as planned, effects as the tooltip shows them. The test mod is never part of the upload. Until [AUTO-043] is `confirmed`, report whether `ep_<tag>_all` worked as a command so the register can be updated.
3. Read `Documents\Paradox Interactive\Hearts of Iron IV\logs\error.log` for lines naming `ep_<tag>` or the pack's files. Done when the owner reports what they saw and the log has no such line.

## 3. Change note and credits
1. The change note names the events added or changed, by title.
2. The picture credits are on the pack's wiki page (`wiki/Event-Pack-<Country>.md`, generated), which the Workshop description does not link to (it carries no Wiki or GitHub links): run `powershell -File .\wiki\push-wiki.ps1` before the upload, so the page is live and complete. A first upload, or a `WORKSHOP_DESCRIPTION_GUIDELINES.md` changed since the pack's last tag (`git diff workshop-<key>-<date>..HEAD --stat -- packs/<key>/WORKSHOP_DESCRIPTION_GUIDELINES.md`), takes `-UpdateDescription`, so the description on Steam is the generated one.

3. A first upload also needs the page's images: the preflight's Workshop text row fails while the `hero` or `overview` of the pack has no address in the Manager's `Config/workshop-image-urls.json` (`event-pack-<country>/hero` and `/overview`). Render them with `powershell -NoProfile -File "<Manager root>\Scripts\Showcase\Export-HoiDescriptionImages.ps1" "Event Packs" -MissingOnly`, show them to the owner, let them upload to Imgur and give the addresses, add them to that file, then run the Manager's `Sync-WorkshopRegions.ps1` and `Sync-WorkshopCrossLinks.ps1` (the cross-link block carries the series banner) with `"Event Packs"`, and commit on the owner's word.

## 4. Upload and tag
1. `Publish-Mod.ps1 "Event Packs" -Pack <key> -DryRun -ChangeNote "<note>"`: show the owner the VDF (title `Event Pack: <Country>`) and the file list (only that pack's content, descriptor and thumbnail).
2. Give the owner the upload command for their own terminal: `powershell -NoProfile -File "<Manager root>\Scripts\Publish-Mod.ps1" "Event Packs" -Pack <key> -ChangeNote "<note>"`, with `-UpdateDescription` per step 3.2.
3. A first upload writes the new id into `packs/<key>/descriptor.mod`: ask the owner to commit it. The command tags `workshop-<key>-<date>`; pushing the tag is the owner's call.

## 5. Event images on the Workshop page
SteamCMD uploads only the thumbnail, so the event images go up by hand.
1. `powershell -File .\build.ps1 -RenderEvents -Pack <key>`, from the committed pack: one image per event in `artifacts/workshop-images/<key>/`, named `NN-<event key>` (the id in two digits), and `00-overview` with several events on a pile, which comes first. No `[ERROR]`, and no `[WARN]` outside the "Kept on judgment" of the plan that made the events.
2. Give the owner the folder's full path and these steps: on the item's Workshop page, "Add/edit images & videos"; on an update where events or their texts changed, remove the old event images first; upload the files in name order, so the gallery follows the events' order.
