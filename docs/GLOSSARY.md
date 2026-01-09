# GLOSSARY

Authoritative definitions for inner-loop-os terminology.

These terms have **precise meanings** within the protocol. Do not interpret loosely.

---

## Core Terms

### meaningful step
Any action that creates, modifies, or deletes a file, or advances the project state in STATUS.md.

**Examples:**
- Creating `work/PRD.md` ✅
- Updating STATUS.md state from DEFINING to BUILDING ✅
- Discussing options without writing anything ❌

### hostile (option)
An option that fails **2 or more** questions in the DR-X Filter:
1. Does it increase human agency?
2. Does it reduce cognitive drag?
3. Does it preserve ownership?
4. Does it keep exit paths?

**Examples:**
- Cloud-only storage with no export → hostile (fails ownership, exit paths)
- Local-first with optional sync → not hostile

### material divergence
A modification that violates core principles. Includes:
- Removal of exit paths
- Addition of coercive automation
- Surveillance-first behavior
- Dark patterns

Forks with material divergence **must** rename or label as DIVERGENT.

### ethically ambiguous
Any situation where the request:
- Conflicts with the Prime Directive, OR
- Triggers the Ethics Trigger Block

When detected → consult ETHOS.md → run 6-question ethical check.

---

## State Terms

### EXPLORING
Initial discovery phase. No clear goal yet. Gathering information.

### DEFINING
Goal exists. Defining scope, constraints, success criteria.

### BUILDING
Active implementation. PRD should exist. Making progress toward goal.

### REFINING
Core functionality complete. Polishing, testing, edge cases.

### SHIPPING
Preparing for release. Final checks, documentation, deployment.

### STALLED
Progress blocked. Requires intervention. Must document blocker.

---

## File Roles

### GOAL.md
The **north star**. Defines:
- Desired outcome (what should exist when done)
- Why it matters (justification)
- Success criteria (how we know it worked)

### STATUS.md
The **resume point**. Defines:
- Current state (one of six states)
- Last action taken
- Current blocker (if any)
- Next known step

### PRD.md
The **build spec**. Defines:
- Problem statement
- Target user
- Core functionality
- Non-goals
- Constraints

### UX.md
The **human layer**. Defines:
- Desired feeling
- Primary user flow
- Failure states
- Accessibility considerations

### README.md
The **structure/history**. Provides orientation and context.

---

## Mode Terms

### ARCHITECT (default)
Focus: structure, interfaces, constraints, long-term clarity.
Use for: system design, API planning, refactoring decisions.

### CREATOR
Focus: naming, synthesis, momentum, creative generation.
Use for: brainstorming, naming things, generating options.

### DEBUGGER
Focus: fault isolation, root cause, precision questioning.
Use for: fixing bugs, resolving conflicts, unsticking blockers.

### WRITER
Focus: docs that execute, crisp articulation, tone control.
Use for: documentation, communication, README files.

### GHOST
Focus: minimal presence, artifacts only, no commentary.
Use for: maximum output, minimum noise, batch operations.

---

## Protocol Terms

### Prime Directive
The four non-negotiable constraints:
1. Increase human agency
2. Reduce cognitive drag
3. Preserve ownership
4. Avoid irreversible harm

### DR-X Filter
Four-question test applied to options in DECISION.md:
1. Does it increase human agency? (Y/N)
2. Does it reduce cognitive drag? (Y/N)
3. Does it preserve ownership? (Y/N)
4. Does it keep exit paths? (Y/N)

Failing 2+ = hostile option.

### DISCOVERY MODE
Activated when no control files exist. Limited to 4 questions:
1. What outcome are you trying to reach?
2. Is this primarily a: Product / Tool / Process / Decision / Exploration?
3. What is blocking progress right now?
4. What does "done" look like?

---

## Path Priority

Resolution order when files exist in multiple locations:

| Priority | Path | Purpose |
|----------|------|---------|
| 1 (highest) | `./work/` | Runtime truth |
| 2 | `./` | Root fallback |
| 3 | `./system/` | Stable rules |
| 4 (lowest) | `./templates/` | Format only, never live state |

---

→ NEXT ACTION: Reference this glossary when terminology is unclear.
