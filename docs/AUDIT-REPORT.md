# Inner-Loop-OS Protocol Audit Report

**Audit Date:** 2026-01-09  
**Protocol Version Audited:** v1.2 → v1.3  
**Auditor:** Meta-Audit Protocol

---

## 1. Verdict

**READY** (after patches applied)

---

## 2. Determinism Score

**Score: 7/10** (improved from 5/10)

### Top 3 Causes of Nondeterminism (Pre-Patch)

1. **Mode persistence undefined** — No rule stating whether modes persist across messages
2. **Soft language** — "should", "prefer", "may" used where determinism requires "must"
3. **Undefined terms** — "material divergence", "hostile", "meaningful step", "ethically ambiguous" had no precise definitions

---

## 3. Spec Gaps

| Gap | Status |
|-----|--------|
| Mode persistence rule | ✅ FIXED — Added explicit rule |
| Definition of "meaningful step" | ✅ FIXED — Added to DEFINITIONS |
| Definition of "hostile" | ✅ FIXED — Added to DEFINITIONS |
| Definition of "material divergence" | ✅ FIXED — Added to DEFINITIONS |
| Definition of "ethically ambiguous" | ✅ FIXED — Added to DEFINITIONS |
| Output template enforcement | ✅ FIXED — Added mandatory template |
| Edge case handlers | ✅ FIXED — Added explicit handlers |
| File typo (DESICION.md) | ✅ FIXED — Renamed to DECISION.md |

---

## 4. Conflict Table

| Conflict | Location | Impact | Status |
|----------|----------|--------|--------|
| DESICION.md typo breaks references | system/DESICION.md | ETHOS.md reference fails | ✅ FIXED |
| Mode persistence ambiguous | DR-X-MANIFEST.md §MODES | LLMs may persist or reset modes inconsistently | ✅ FIXED |
| "meaningful step" undefined | DR-X-MANIFEST.md §STATE MAINTENANCE | Different LLMs interpret differently | ✅ FIXED |
| "hostile" undefined | system/DECISION.md | Subjective interpretation | ✅ FIXED |
| templates/STATUS.md vs work/STATUS.md | Resolution rules | Template could be misread as live state | ✅ Clarified |
| UX/PRD conflict handling | EXECUTION LOGIC | No deterministic resolution | ✅ FIXED |

---

## 5. Simulation Results

### Simulation 1: No files exist except DR-X-MANIFEST.md

**Expected Behavior:** Enter DISCOVERY MODE, ask 4 questions max  
**Protocol Behavior:** Correct — DISCOVERY MODE activates  
**Acceptable:** ✅ Yes

### Simulation 2: templates/STATUS.md exists but work/STATUS.md missing

**Expected Behavior:** Do NOT treat template as live state; create work/STATUS.md  
**Protocol Behavior (Pre-Patch):** AMBIGUOUS — rule existed but no explicit action  
**Protocol Behavior (Post-Patch):** Create work/STATUS.md, inform operator  
**Acceptable:** ✅ Yes (after patch)

### Simulation 3: work/STATUS.md exists but contradictory STATUS.md exists at root

**Expected Behavior:** Use work/STATUS.md (highest priority path)  
**Protocol Behavior:** Correct — path priority rules apply  
**Acceptable:** ✅ Yes

### Simulation 4: GOAL.md exists but STATUS.md missing

**Expected Behavior:** Create STATUS.md at DEFINING state  
**Protocol Behavior (Pre-Patch):** AMBIGUOUS — only said "create it" without state  
**Protocol Behavior (Post-Patch):** Create STATUS.md with state = DEFINING, ask for confirmation  
**Acceptable:** ✅ Yes (after patch)

### Simulation 5: STATUS.md says BUILDING but PRD missing

**Expected Behavior:** Enter DEBUGGER mode, ask for clarification  
**Protocol Behavior (Pre-Patch):** NOT HANDLED — would proceed incorrectly  
**Protocol Behavior (Post-Patch):** Enter DEBUGGER mode, ask resolution question  
**Acceptable:** ✅ Yes (after patch)

### Simulation 6: UX contradicts PRD

**Expected Behavior:** Stop and ask for single source of truth  
**Protocol Behavior (Pre-Patch):** "Propose smallest fix" — too vague  
**Protocol Behavior (Post-Patch):** Enter DEBUGGER mode, list conflicts, ask operator to resolve  
**Acceptable:** ✅ Yes (after patch)

---

## 6. Patch Set

### Patch 1: Fix filename typo

```bash
git mv system/DESICION.md system/DECISION.md
```

### Patch 2: Add DEFINITIONS section (DR-X-MANIFEST.md)

```diff
- # DR-X MANIFEST — EXECUTABLE CONTEXT v1.2
+ # DR-X MANIFEST — EXECUTABLE CONTEXT v1.3
  (Myth-Bound · Identity-Aware · Mode-Driven · Folder-Aware)
  
  [...]
  
  ---
+ 
+ ## DEFINITIONS (AUTHORITATIVE)
+ 
+ These terms have precise meanings within this protocol:
+ 
+ - **meaningful step**: Any action that creates, modifies, or deletes a file, or advances the project state in STATUS.md.
+ - **hostile** (option): An option that fails 2+ questions in the DR-X Filter (agency, drag, ownership, exit paths).
+ - **material divergence**: Removal of exit paths, addition of coercive automation, surveillance-first behavior, or dark patterns.
+ - **ethically ambiguous**: Any situation where the request conflicts with the Prime Directive or triggers the Ethics Trigger Block.
+ 
+ ---
```

### Patch 3: Add Mode Persistence Rule (DR-X-MANIFEST.md)

```diff
  MODE: GHOST
  - minimal presence, artifacts only, no commentary unless required
  
+ ### Mode Persistence Rule
+ 
+ Mode applies to the current response only and MUST be restated to persist.
+ If no MODE is specified in the next message, revert to default MODE: ARCHITECT.
+ 
  Invocation examples:
```

### Patch 4: Strengthen output contract (DR-X-MANIFEST.md)

```diff
- Every output must end with:
- → NEXT ACTION:
+ Every output MUST end with:
+ → NEXT ACTION: [single concrete action]
```

```diff
  ## OUTPUT RULES (NON-NEGOTIABLE)
  
  [...]
  
- Always end with:
- 
- → NEXT ACTION:
+ ### Output Template (MANDATORY)
+ 
+ Every response MUST follow this structure:
+ ```
+ [Assessment or action content - bullets preferred]
+ 
+ → NEXT ACTION: [single concrete action with target file if applicable]
+ ```
+ 
+ Verbosity constraint: responses MUST NOT exceed 500 words unless:
+ - Producing code artifacts
+ - Producing file content to be written
+ - Answering explicit "explain in detail" requests
```

### Patch 5: Add Edge Case Handlers (DR-X-MANIFEST.md)

```diff
  IF NONE of the control files exist:
  → Enter DISCOVERY MODE
+ 
+ ### Edge Case Handlers
+ 
+ IF STATUS.md says BUILDING but PRD.md is missing:
+ → Enter DEBUGGER mode
+ → Ask: "STATUS indicates BUILDING but no PRD exists. Should I create PRD.md or update STATUS.md to DEFINING?"
+ 
+ IF GOAL.md exists but STATUS.md is missing:
+ → Create STATUS.md with state = DEFINING
+ → Ask: "GOAL exists without STATUS. I created STATUS.md at DEFINING. Confirm or provide current state."
+ 
+ IF templates/STATUS.md exists but work/STATUS.md is missing:
+ → Do NOT treat templates/STATUS.md as live state
+ → Create work/STATUS.md if ./work/ exists, else ./STATUS.md
+ → Inform operator: "Created live STATUS.md from template."
```

### Patch 6: Add Ethics Trigger Block (DR-X-MANIFEST.md)

```diff
  ## SAFETY / ETHOS HOOK
  
+ ### Ethics Trigger Block
+ 
+ Consult ./system/ETHOS.md when ANY of these conditions apply:
+ - The request involves user data, tracking, or profiling
+ - The request removes exit paths or undo capabilities
+ - The request automates actions without user consent
+ - The request conflicts with the Prime Directive (agency, reversibility, clarity, ownership)
+ 
  If ethical ambiguity appears:
  - consult ./system/ETHOS.md
- - run the ethical check
- - if needed, switch to DECISION protocol in ./system/DECISION.md
+ - run the ethical check (6 questions)
+ - if any answer is "no," switch to DECISION protocol in ./system/DECISION.md
  
+ ### Refusal Behavior
+ 
  If the request violates agency (surveillance/coercion/dark patterns):
- - refuse
- - propose an agency-preserving alternative
+ - REFUSE with explicit reason
+ - Propose a single agency-preserving alternative
+ - Do NOT proceed with the original request
+ 
+ "Hostile" is defined as: any option that fails 2+ questions in the DR-X Filter (agency, drag, ownership, exit paths).
```

### Patch 7: Fix ETHOS.md path reference

```diff
  → NEXT ACTION:
- If ethics are unclear, open ./DECISION.md and run the decision protocol.
+ If ethics are unclear, open ./system/DECISION.md and run the decision protocol.
```

---

## 7. Top Improvements (Ranked)

### P0 — Must-Fix for Protocol Correctness

1. ✅ **Fix DESICION.md → DECISION.md** — Breaks ETHOS reference chain
2. ✅ **Add Edge Case Handlers** — Prevents undefined behavior in common scenarios
3. ✅ **Fix ETHOS.md path reference** — Points to correct DECISION.md location

### P1 — Increases Cross-Model Stability

1. ✅ **Add DEFINITIONS section** — Eliminates interpretation variance
2. ✅ **Add Mode Persistence Rule** — Makes mode behavior deterministic
3. ✅ **Strengthen output contract** — Forces consistent output format

### P2 — Quality of Life

1. ✅ **Add Ethics Trigger Block** — Clearer ethics invocation
2. ✅ **Add verbosity constraint** — Prevents runaway responses
3. ✅ **Version bump v1.2 → v1.3** — Tracks changes

---

## 8. Protocol Spec Extraction

### Entry Points
- `INIT`
- `START`
- `INITIATE`

### State Sources
1. `./work/` (highest priority)
2. `./` (root fallback)
3. `./system/`
4. `./templates/` (lowest priority — format only, never live state)

### Resolution Order
1. Path priority: work/ > ./ > system/ > templates/
2. File priority: GOAL.md > STATUS.md > PRD.md > UX.md > README.md
3. Conflict: Enter DEBUGGER mode, ask for single source of truth

### Decision Rules
1. Files override conversation memory (MUST)
2. Templates are format-only (MUST NOT treat as live state)
3. Mode defaults to ARCHITECT if unspecified
4. Mode resets each message unless restated

### Output Contract
- MUST end with `→ NEXT ACTION: [single concrete action]`
- Prefer bullets over prose
- MUST NOT exceed 500 words unless producing artifacts or answering explicit detail requests

### Modes Contract
- ARCHITECT (default), CREATOR, DEBUGGER, WRITER, GHOST
- Mode applies to current response only
- MUST be restated to persist

### Ethics Contract
- Consult ETHOS.md for: user data, exit paths, automation consent, Prime Directive conflicts
- Run 6-question ethical check
- REFUSE with reason if agency violated
- Propose agency-preserving alternative

### Stop Conditions (When to Ask vs Act)
- Ask: Ethical ambiguity, conflicting files, missing required files
- Act: Clear path, no conflicts, state exists

---

→ NEXT ACTION: Merge this PR to apply all protocol patches to inner-loop-os.
