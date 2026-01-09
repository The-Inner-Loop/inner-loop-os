# UPGRADE GUIDE

How to upgrade between inner-loop-os versions.

---

## v1.2.x → v1.3.0

**Release date:** 2026-01-09

### Breaking Changes

None. v1.3.0 is fully backward compatible with v1.2.x.

### Required Actions

None required. Your existing `work/` directory will work unchanged.

### Recommended Actions

1. **Update DR-X-MANIFEST.md**
   - Replace your manifest with the v1.3.0 version
   - New sections: DEFINITIONS, Mode Persistence Rule, Edge Case Handlers

2. **Review mode usage**
   - Modes now explicitly reset each message
   - If you relied on implicit mode persistence, add explicit `MODE: X` to each message

3. **Check STATUS.md states**
   - Valid states are now enforced: EXPLORING, DEFINING, BUILDING, REFINING, SHIPPING, STALLED
   - Custom states may cause validation warnings

4. **Run validation** (optional)
   ```bash
   ./scripts/validate.sh
   ```

### New Files (Optional)

Copy these from the updated repo if desired:
- `QUICKSTART.md` — fast onboarding guide
- `CHANGELOG.md` — version history
- `docs/GLOSSARY.md` — term definitions
- `docs/FAQ.md` — common questions
- `docs/CONTRIBUTING.md` — contribution guide
- `scripts/validate.sh` — structure validator
- `examples/` — sample projects

---

## v1.1.x → v1.2.0

**Release date:** 2025-12-15

### Breaking Changes

1. **Folder structure changed**
   - Control files now read from `work/` first
   - Templates moved to `templates/`

### Required Actions

1. Move live project files to `work/`:
   ```bash
   mkdir -p work
   mv GOAL.md STATUS.md PRD.md UX.md work/
   ```

2. Ensure `templates/` contains only templates, not live state

### Recommended Actions

1. Update any scripts that reference root-level control files
2. Add `.gitignore` entry for `work/` if you don't want to track project state

---

## v1.0.x → v1.1.0

**Release date:** 2025-10-01 (theoretical)

### Breaking Changes

1. **Manifest renamed**
   - `MANIFEST.md` → `DR-X-MANIFEST.md`

### Required Actions

1. Rename your manifest:
   ```bash
   mv MANIFEST.md DR-X-MANIFEST.md
   ```

2. Update any documentation or scripts referencing the old name

---

## General Upgrade Process

For any version upgrade:

1. **Backup your work/**
   ```bash
   cp -r work/ work.backup/
   ```

2. **Pull latest protocol**
   ```bash
   git pull origin main
   ```

3. **Review CHANGELOG.md**
   - Check for breaking changes
   - Note any required actions

4. **Run validation**
   ```bash
   ./scripts/validate.sh
   ```

5. **Test with INIT**
   - Verify the system resumes correctly
   - Check that your state is preserved

6. **Remove backup once confirmed**
   ```bash
   rm -rf work.backup/
   ```

---

## Rollback Process

If an upgrade causes issues:

1. **Restore backup**
   ```bash
   rm -rf work/
   mv work.backup/ work/
   ```

2. **Checkout previous version**
   ```bash
   git checkout v1.2.0  # or your previous version
   ```

3. **Report issue**
   - Open GitHub issue with reproduction steps
   - Include version numbers and error behavior

---

## Version Compatibility Matrix

| Your Version | Can Upgrade To | Notes |
|--------------|----------------|-------|
| 1.0.x | 1.1.x, 1.2.x, 1.3.x | Requires manifest rename |
| 1.1.x | 1.2.x, 1.3.x | Requires folder restructure |
| 1.2.x | 1.3.x | No breaking changes |
| 1.3.x | (current) | — |

---

→ NEXT ACTION: After upgrading, run `INIT` to verify the system resumes correctly.
