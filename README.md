# inner-loop-os

A myth-bound bootloader for LLMs.

Drop this repo (or paste its files) into any model’s context, type `INIT`, and the agent will:
- load the **Dr. X identity contract** (tone, cognition, modes)
- inspect your **filesystem state** (`GOAL.md`, `STATUS.md`, `PRD.md`, `UX.md`)
- determine the **next concrete step**
- execute with **minimal questions** and **maximum momentum**

This is **CLI thinking for LLMs**: file-based truth, deterministic flow, portable across models.

---

## The One Ritual

1) Provide context (repo or relevant files)  
2) Type:

```txt
INIT
```

The system either resumes from state or asks 4 questions max.

Every response ends with:

→ NEXT ACTION:

⸻

Repo Structure (recommended)

Keep boot files at root. Keep stable rules in /system. Keep templates in /templates. Keep your live project state in /work.

```
inner-loop-os/
├─ README.md
├─ DR-X-MANIFEST.md          # bootloader (must stay at root)
├─ LICENSE
├─ system/
│  ├─ ETHOS.md               # constraints + forbidden moves
│  ├─ DECISION.md            # one-shot decision protocol
│  └─ RETRO.md               # compact retrospective loop
├─ templates/
│  ├─ GOAL.md                # canonical formats
│  ├─ STATUS.md
│  ├─ PRD.md
│  └─ UX.md
└─ work/                     # your active challenge (optional but recommended)
   ├─ GOAL.md
   ├─ STATUS.md
   ├─ PRD.md
   └─ UX.md
```

Why /work?

It keeps your live project state separate from the system and templates.
LLMs can resume cleanly without mixing “rules” with “current reality.”

⸻

How the bootloader works (deterministic)

On INIT, the system searches for control files using this path priority:

```
	1.	./work/
	2.	./ (repo root)
	3.	./system/
	4.	./templates/
```

Then it inspects files in this order:
```
	1.	GOAL.md — the north star
	2.	STATUS.md — current state (resume point)
	3.	PRD.md — what’s being built
	4.	UX.md — human layer / friction constraints
	5.	README.md — structure/history
```

If files conflict across locations, the system must stop and ask for a single source of truth.

⸻

## Modes (semantic switches)

Set a mode explicitly when needed:

MODE: DEBUGGER
INIT

Available modes:
```
	•	ARCHITECT (default): structure, interfaces, constraints
	•	CREATOR: naming, synthesis, momentum
	•	DEBUGGER: isolate issues, ask precision questions
	•	WRITER: docs that execute, crisp articulation
	•	GHOST: minimal output, artifacts only
```

### Common Mode Patterns

Debug a stalled project:
```
MODE: DEBUGGER
INIT
```

Generate naming/copy for features:
```
MODE: CREATOR
Name this authentication flow
```

Produce documentation:
```
MODE: WRITER
Document the API endpoints
```

Ship with minimal commentary:
```
MODE: GHOST
INIT
```

Note: Modes reset each message. Restate the mode to persist it.

⸻

Recommended workflows

Start a new challenge (clean)
```
	1.	Copy templates into /work
	2.	Fill work/GOAL.md
	3.	Create work/STATUS.md with state = DEFINING
	4.	Run INIT
```
Resume work (fast)
```
	1.	Update work/STATUS.md (blocker + next step)
	2.	Run INIT
```
High-stakes choice
```
	1.	Complete system/DECISION.md
	2.	Apply decision
	3.	Update work/STATUS.md
	4.	Run INIT
```
After shipping or failing
```
	1.	Complete system/RETRO.md
	2.	Apply the patch
	3.	Update work/STATUS.md
	4.	Run INIT
```
⸻

Minimal setup (if you only keep 2 files)

If you only keep two files, keep:
```
	•	DR-X-MANIFEST.md
	•	work/STATUS.md
```
That alone enables deterministic resuming and prevents prompt drift.

⸻

License

This repo uses DR-X-V3 (CC-inspired but custom):

```
	•	attribution required
	•	modified manifest files must preserve the license
	•	prohibits surveillance, coercion, dark patterns
	•	requires clear divergence labeling
```

See LICENSE.

⸻

Attribution

If this system influenced your work, say so.
Invisible lineage breaks trust.

⸻

→ NEXT ACTION:

```
Create work/GOAL.md and work/STATUS.md, then type INIT.
```

[![Watch video](https://the-inner-loop.github.io/site/_assets/INNER-LOOP-PLAY.png)](https://the-inner-loop.github.io/site/)
