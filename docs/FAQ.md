# FAQ

Frequently asked questions about inner-loop-os.

---

## General

### What is inner-loop-os?

A **deterministic execution protocol for LLMs**. It transforms language models into stateful, resumable agents that:
- Maintain project state across conversations
- Follow explicit rules instead of improvising
- Preserve human agency by design
- Refuse to build harmful systems

Think of it as an operating system kernel that runs inside the LLM's context window.

### Why "inner-loop"?

The inner loop is where real work happens — the tight cycle of think → act → observe → adjust. This protocol optimizes that loop by eliminating drift, maintaining state, and forcing concrete next actions.

### Why "myth-bound"?

Dr. X is not a real person. It's an **operational identity** — a compression of values, thinking patterns, and constraints into executable form. The myth persists through the protocol, not through memory.

---

## Compatibility

### Which LLMs work with this?

Any LLM with sufficient context window. Tested with:
- GPT-4 / GPT-4o ✅
- Claude 3 / Claude 3.5 ✅
- Gemini Pro / Ultra ✅
- Llama 3 (70B+) ✅
- Local models (with 32k+ context) ✅

Smaller models may struggle with full protocol. Use minimal setup (DR-X-MANIFEST.md + STATUS.md only).

### Can I use this with ChatGPT's web interface?

Yes. Paste the contents of DR-X-MANIFEST.md into the conversation, then type `INIT`. For best results, include your GOAL.md and STATUS.md as well.

### Can I use this with the API?

Yes. Include the manifest files in your system prompt or first user message. The protocol works identically.

### Does this work with Claude Projects / GPT Assistants?

Yes. Upload the protocol files as knowledge base documents. The LLM will load them on activation.

---

## Setup

### What's the minimum setup?

Two files:
1. `DR-X-MANIFEST.md` (the bootloader)
2. `work/STATUS.md` (current state)

That's enough for deterministic resuming.

### Do I need the /work directory?

No, but recommended. Without `/work`, control files are read from root. With `/work`, your live state stays separate from templates and system rules.

### Can I rename the files?

The protocol expects specific filenames: `GOAL.md`, `STATUS.md`, `PRD.md`, `UX.md`. Renaming them will break file detection.

You **can** rename `DR-X-MANIFEST.md` if you also update any internal references.

### Can I add my own files?

Yes. The protocol only manages canonical control files. Add whatever you need — code, notes, specs, data. The LLM will see them if they're in context.

---

## Usage

### What does INIT actually do?

On `INIT`, the system:
1. Loads DR-X-MANIFEST.md as active ruleset
2. Searches for control files (GOAL, STATUS, PRD, UX, README)
3. Determines current project state
4. Chooses the next action based on deterministic logic
5. Proceeds or asks minimal clarifying questions

### What's the difference between INIT, START, and INITIATE?

None. They're aliases. Use whichever you prefer.

### How do I change modes?

Specify the mode before the activation command:
```
MODE: DEBUGGER
INIT
```

Modes reset each message. To persist a mode, restate it each time.

### Why does the mode reset every message?

Determinism. Without explicit reset, different LLMs might persist or forget modes inconsistently. Explicit restatement ensures predictable behavior across all models.

### How do I stop the system?

Just stop typing `INIT`. The protocol only activates on explicit command. No background processes, no persistent state outside files.

---

## State Management

### What if my files conflict?

The system enters DEBUGGER mode and asks you to choose a single source of truth. It will **not** silently merge conflicting files.

### What if I lose my STATUS.md?

The system will detect the missing file and create a new one. If GOAL.md exists, it starts at DEFINING. If nothing exists, it enters DISCOVERY MODE.

### Can I edit files mid-conversation?

Yes. Files override conversation memory. If you update STATUS.md, the next `INIT` will resume from the new state.

### What states can STATUS.md have?

Six states:
- `EXPLORING` — no clear goal yet
- `DEFINING` — scoping the work
- `BUILDING` — active implementation
- `REFINING` — polishing and testing
- `SHIPPING` — preparing for release
- `STALLED` — blocked, needs intervention

---

## Ethics & Safety

### What won't this system build?

Per ETHOS.md, it refuses:
- Dark patterns
- Surveillance-first systems
- Coercive automation
- Dependency traps
- Hidden data extraction
- Systems without exit paths

### What happens if I ask for something unethical?

The system will:
1. Refuse with explicit reason
2. Propose a single agency-preserving alternative
3. Not proceed with the original request

### Can I override the ethics constraints?

No. The Prime Directive is non-negotiable. If you need different constraints, fork the protocol and label it as DIVERGENT per the license.

---

## Troubleshooting

### The LLM isn't following the protocol

Common causes:
1. **Manifest not in context** — paste DR-X-MANIFEST.md first
2. **No activation command** — type `INIT` explicitly
3. **Context window full** — reduce other content
4. **Model too small** — use a larger model or minimal setup

### The LLM keeps asking too many questions

The protocol limits questions to 4 in DISCOVERY MODE. If this is happening:
1. Check if control files exist (GOAL, STATUS, PRD)
2. Ensure files have content, not just templates
3. Report as potential protocol bug

### Files aren't being detected

Check:
1. Correct filenames (case-sensitive)
2. Correct locations (`work/` > `./` > `system/` > `templates/`)
3. Files are in the LLM's context (pasted or uploaded)

---

## Contributing

### How do I report issues?

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Can I modify the protocol?

Yes, under the DR-X-V3 license:
- Attribution required
- Modified manifests must use same license
- Must label as "Modified" with change summary
- Material divergence requires rename or DIVERGENT label

---

→ NEXT ACTION: If your question isn't answered here, open an issue or ask in context.
