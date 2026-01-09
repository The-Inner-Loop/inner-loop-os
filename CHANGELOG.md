# CHANGELOG

All notable changes to inner-loop-os are documented here.

Format: [Semantic Versioning](https://semver.org/)

---

## [1.3.0] — 2026-01-09

### Added
- **DEFINITIONS section** in DR-X-MANIFEST.md with precise meanings for:
  - `meaningful step`
  - `hostile` (option)
  - `material divergence`
  - `ethically ambiguous`
- **Mode Persistence Rule**: Modes apply to current response only, must be restated to persist
- **Edge Case Handlers** for common ambiguous states:
  - STATUS=BUILDING but PRD missing
  - GOAL exists but STATUS missing
  - Template exists but live state missing
- **Ethics Trigger Block**: Explicit conditions for consulting ETHOS.md
- **Output Template (Mandatory)**: Enforced response structure
- **Verbosity constraint**: 500 word limit unless producing artifacts

### Changed
- Strengthened output contract: "must" replaces "should" throughout
- Refusal behavior now requires explicit reason + single alternative
- ETHOS.md path reference corrected to `./system/DECISION.md`

### Fixed
- `DESICION.md` → `DECISION.md` (typo in filename)
- Template vs live state confusion clarified in resolution rules

### Metrics
- Determinism score: **7/10** (was 5/10)

---

## [1.2.0] — 2025-12-15

### Added
- Folder-aware filesystem rules (`work/` > `./` > `system/` > `templates/`)
- Path priority system for control file resolution
- DISCOVERY MODE (4 questions max)
- Conflict detection and DEBUGGER mode trigger

### Changed
- Manifest renamed to DR-X-MANIFEST.md (was MANIFEST.md)
- Separated templates from live state

### Known Issues (Fixed in 1.3.0)
- Mode persistence undefined
- Soft language ("should", "prefer") caused interpretation variance
- Missing definitions for key terms

---

## [1.1.0] — 2025-10-01 (Theoretical)

### Added
- Initial mode system (ARCHITECT, CREATOR, DEBUGGER, WRITER, GHOST)
- ETHOS.md constraint system
- DECISION.md one-shot protocol
- RETRO.md retrospective loop

### Changed
- Moved from single-file to multi-file architecture

---

## [1.0.0] — 2025-08-01 (Theoretical)

### Added
- Initial release
- DR-X identity contract
- Basic activation commands (INIT, START, INITIATE)
- GOAL.md / STATUS.md / PRD.md / UX.md templates
- Prime Directive defined

---

## Versioning Policy

- **MAJOR**: Breaking changes to protocol (file formats, activation commands, execution logic)
- **MINOR**: New features, new files, new modes (backward compatible)
- **PATCH**: Bug fixes, typo corrections, clarifications

---

→ NEXT ACTION: Review changelog before each release to ensure all changes are documented.
