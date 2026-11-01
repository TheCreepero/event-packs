# Event Packs: keep the build settings' layout, and mark checked facts in dossiers

Status: DONE (shipped 2026-11-01; approved 2026-11-01, decision 2: yes, as recommended)
Created: 2026-11-01
Brief: the handover pasted into this session ("keep the build settings' layout, and mark checked facts in dossiers"), the optional change 8 of the fact-verification work (`e190889`).

**Out of scope:** `research/france/` (the France session's), the Finland audit itself, the layout of `pictures.json` and `events.json`.

## What the survey found

- France has shipped (`613ca26`), and that commit carries the `ConvertTo-Json` layout of `tools/HoiModBuild.json` (two spaces after colons, deep indents, one array item per line). No session holds it uncommitted, so no message to the France session is needed. The hand-written layout is in `a3100a4`: 4-space indent, `"key": value`, every `testSuites` array on one line. The working copy has CRLF line endings and no BOM.
- The tests write `tools/HoiModBuild.json` only with `ConvertTo-Json` (`tests/EventPacks.Tests.ps1` line 76) or as one-line JSON (`tests/BuildEngine.Tests.ps1`). No test checks the file's layout.
- Finland's dossiers: `2026-10-31-dossier.md` has 15 candidates marked `Used:`, and each addendum has one (`sillanpaa_nobel`, `vickers_six_ton_tanks`). The Finland plan came before Phase 3a, so none of its facts has been checked against its page yet. A `Checked:` line can therefore only come from the audit; there is nothing honest to backfill now.
- Phase 3a records only the counts and the dropped facts in the plan's "Fact verification". A candidate replaced after Phase 3a leaves its fixes nowhere, so a `Checked:` line on it would point at nothing.
- `tests/Documentation.Tests.ps1` checks no wording about `Used:` or dossiers.

## Decisions

1. **The `-NewPack` write: a text insert** (the handover's recommendation). Parse the file once. If the pack is already there, stop with the existing message. Otherwise insert the new entry as text after the last entry of `packages`, in the file's own indent and newline. If `packages` is missing, add it as the last key: one insert routine serves both cases. If the file is missing, write it whole in the hand-written style. No general JSON formatter. (The plan first said "first key"; changed during implementation.)
2. **For the owner: should `event-pack-audit` write `Checked:` lines?** Recommendation: **yes**. The audit's Phase 1 rechecks the facts of shipped events, and those are the dossier candidates marked `Used:`. If the audit leaves no mark, Finland's dossier keeps reading as unchecked even after its facts were checked and corrected. The audit writes the lines when its plan goes READY, the same point at which `event-pack-create` writes `Used:`. Finland's three dossier files then get their lines from the coming audit, not now (see the survey).
   - **No:** dossiers then record only checks made while planning, and the Finland audit leaves `research/finland/` unchanged.
3. **The line's wording, and one line per check.** Each check adds a new line under the `Used:` line, and no earlier line is ever edited. The newest line is the one that counts. The form is:
   ```
   Checked: <plan file name>, <K> kept, <F> fixed, <D> dropped. The facts below are the researcher's notes, not the checked ones: see <where>.
   ```
   `<where>` is `source/<pack>/fact-sheets.md` for a candidate that became an event. For a candidate replaced after Phase 3a, it is `"Fact verification" in that plan`.
4. **"Fact verification" keeps each fix.** Phase 3a step 3 lists each `FIX` fact with its correction as well as each `DROP`, so a replaced candidate's `Checked:` line points to something.

## Changes

### 1. `-NewPack` keeps the layout of `tools/HoiModBuild.json`
1. Read `Invoke-EpNewPack` only (about 45 lines, in `tools/EventPacks.ps1`). Replace its `ConvertTo-Json` write with the insert of decision 1, in a helper of its own.
2. Test in `tests/EventPacks.Tests.ps1`. Start from a hand-written settings text whose `testSuites` arrays sit on one line each. After `Invoke-EpNewPack`, the original lines are unchanged and in order, and only the new entry's lines are added. The result parses to the original settings plus the new package. Add one more case for a file without `packages`.
3. Restore `tools/HoiModBuild.json` to the layout of `a3100a4`, with France's entry added in that style. It must parse to the same settings before and after (compare `ConvertTo-Json -Compress` of both). This goes in its own commit, `chore(build): restore the hand-written layout of the build settings`.

### 2. A `Checked:` line in dossiers
1. `.claude/skills/event-pack-create/SKILL.md`:
   - the "Dossiers are kept" rule allows `Used:` and `Checked:` as the only additions;
   - Phase 1.1 treats a candidate's facts as superseded by the place its latest `Checked:` line names, and a candidate without `Used:` stays usable;
   - Phase 3a step 3 records fixes too (decision 4);
   - Phase 5.4 writes `Checked:` for every candidate Phase 3a checked, replaced ones included.
2. `.claude/skills/event-pack-audit/SKILL.md` (if decision 2 is yes): Phase 3 step 4 writes `Checked:` on the `Used:` candidates whose events Phase 1 rechecked.
3. `AGENTS.md` line 9, the dossier section of `docs/source-format.md`, and step 3 of `.claude/skills/event-pack-implement/SKILL.md` (`research/<key>/` may show `Used:` and `Checked:` marks).
4. `tests/Documentation.Tests.ps1`: a test that the skills and the three docs all name the `Checked:` line, so the docs and skills cannot drift apart.
5. `powershell -File .\build.ps1 -SyncMirrors`.

## Verification
- `.\tests\Run-Tests.ps1 -Changed` while working.
- At the end, `.\build.ps1 -ValidateOnly` and `.\build.ps1 -Test`, with their summary lines reported here.
- `ep-reviewer` reviews the change before it is reported done.
- Commits wait for the owner, and files are staged by path only.

## Outcome

- `Add-EpPackageSettingText` inserts the entry as text, in the file's own indent unit and newline. Appending after the last package adds a comma to that entry's closing `}`, which is the one changed line. The helper parses its result and throws if the pack did not land in the top-level `packages` object (for example, a nested `"packages"` key).
- `tools/HoiModBuild.json` is back to the layout of `a3100a4`, with France's entry. It parses to the same settings as `613ca26`.
- `Checked:` lines are described in `AGENTS.md`, `docs/source-format.md`, the plan template, and the create, audit and implement skills. The mirrors are synced, and a Documentation test pins the wording. The audit fills "Fact verification" per event and marks the fixes the owner declined.
- `ep-reviewer`: ready, with no Critical or Important findings. All six Minor findings and the nit were fixed: the plan text, the top-level guard, ordinal character searches, the file's indent unit, the audit's "Fact verification" step, the Phase 1.1 wording and distinct test names.
- `build.ps1 -ValidateOnly`: `Check OK: 2 pack(s), 3 warning(s).` and `Validation succeeded.` The warnings are France's PD-US pictures, which were already there.
- `build.ps1 -Test`: `Summary: 211 Passed, 0 Failed, 0 Skipped (all suites)`
