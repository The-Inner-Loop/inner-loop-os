# QUICKSTART

Get from zero to first `INIT` in under 2 minutes.

---

## Step 1: Add to LLM Context

Drop this entire repo into your LLM's context window (paste files or upload).

---

## Step 2: Create Your Project State

Create two files in `work/`:

**work/GOAL.md**
```markdown
# GOAL

## Desired Outcome
Build a CLI tool that converts CSV to JSON.

## Why This Matters
Manual conversion is error-prone and slow.

## Success Criteria
- Accepts CSV file path as input
- Outputs valid JSON to stdout
- Handles malformed rows gracefully
```

**work/STATUS.md**
```markdown
# STATUS

## Current State
DEFINING

## Last Action Taken
- Created GOAL.md

## Current Blocker
- None

## Next Known Step
- Define PRD.md
```

---

## Step 3: Activate

Type:

```
INIT
```

The system will:
1. Load the Dr. X identity contract
2. Read your GOAL.md and STATUS.md
3. Propose the next concrete action

---

## That's It

Every response ends with:

```
→ NEXT ACTION: [what to do next]
```

---

## Optional: Set a Mode

```
MODE: DEBUGGER
INIT
```

Available modes: `ARCHITECT` (default), `CREATOR`, `DEBUGGER`, `WRITER`, `GHOST`

---

## Next Steps

- Read [README.md](README.md) for full documentation
- See [docs/FAQ.md](docs/FAQ.md) for common questions
- Check [examples/](examples/) for sample projects

---

→ NEXT ACTION: Create `work/GOAL.md` and `work/STATUS.md`, then type `INIT`.
