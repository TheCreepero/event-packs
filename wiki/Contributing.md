# Contributing to Event Packs

## Development Workflow
1. Clone the repository.
2. Run `build.ps1 -DevLink -Pack <pack>` to link one pack directly to your Hearts of Iron IV launcher, for example `-Pack finland`.
3. To load the bundle Immersive Events Expanded from the repository, run `build.ps1 -DevLink -Pack all`: it builds a git-ignored `.devlink/` folder of hard links to every pack's files and points the launcher at it. After a `git checkout` or `pull`, `build.ps1 -DevLink -CheckLinks -Pack all` reports links that broke; run `-DevLink -Pack all` again to rebuild them. The bundle and a single pack of the same release can be enabled together (the shared files load once, [LOAD-022]); the Workshop page still asks players to pick one, and a pack of another release beside the bundle has not been checked.
4. Make your modifications in `source/<pack>/` (the bundle's one hand-written file is `source/all/workshop-intro.bbcode`) and run `build.ps1 -Generate`.
5. Execute validation with `build.ps1 -ValidateOnly` and tests with `build.ps1 -Test`.
