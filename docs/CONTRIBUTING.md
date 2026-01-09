# CONTRIBUTING

Guidelines for contributing to inner-loop-os.

---

## Philosophy

This protocol values:
- **Determinism** over flexibility
- **Clarity** over cleverness  
- **Constraints** over features
- **Shipping** over discussing

Contributions should increase determinism, not decrease it.

---

## What We Accept

### ✅ Welcome

- Bug fixes (typos, broken references, logic errors)
- Clarifications (ambiguous rules made precise)
- Edge case handlers (undefined behavior made explicit)
- Examples (real demonstrations of protocol in use)
- Documentation improvements (FAQ entries, glossary terms)
- Validation improvements (better error detection)

### ⚠️ Requires Discussion

- New modes (must justify why existing modes don't cover the case)
- New control files (must justify why existing files don't cover the case)
- Changes to activation commands
- Changes to execution logic
- Changes to file priority rules

### ❌ Likely Rejected

- Features that reduce determinism
- Optional behaviors (the protocol should be predictable)
- Model-specific workarounds (protocol must be portable)
- Additions without clear problem statements
- Changes that violate the Prime Directive

---

## How to Contribute

### 1. Bug Reports

Open an issue with:
- **Title**: Clear description of the bug
- **Protocol version**: (e.g., v1.3.0)
- **Steps to reproduce**: Exact sequence that triggers the bug
- **Expected behavior**: What should happen per protocol
- **Actual behavior**: What happens instead
- **Model tested**: Which LLM exhibited the behavior

### 2. Clarification Requests

Open an issue with:
- **Title**: "Clarify: [ambiguous rule]"
- **Quote**: Exact text that's unclear
- **Interpretation A**: One way to read it
- **Interpretation B**: Another way to read it
- **Proposed resolution**: Your suggested clarification

### 3. Pull Requests

1. Fork the repository
2. Create a branch: `fix/typo-in-ethos` or `feature/new-edge-handler`
3. Make changes
4. Update CHANGELOG.md (under "Unreleased")
5. Submit PR with:
   - Clear title
   - Problem statement (what's broken or missing)
   - Solution (what your change does)
   - Testing (how you verified it works)

### 4. Examples

To contribute an example:
1. Create a new directory under `examples/`
2. Include at minimum: `GOAL.md`, `STATUS.md`
3. Add `README.md` explaining the scenario
4. Ensure example is **synthetic** (no real proprietary data)
5. Submit PR

---

## Code Style (for Markdown)

- Use ATX headers (`#`, `##`, `###`)
- Use `-` for unordered lists
- Use `1.` for ordered lists (let Markdown auto-number)
- One sentence per line in source (easier diffs)
- No trailing whitespace
- End files with single newline
- Use fenced code blocks with language hints

---

## Protocol Changes

Changes to core protocol files require:

1. **Problem statement**: What undefined/ambiguous behavior exists?
2. **Evidence**: At least 2 different LLMs exhibiting inconsistent behavior
3. **Proposed patch**: Exact diff
4. **Simulation**: Test case showing before/after behavior
5. **Determinism impact**: Does this increase or decrease the determinism score?

Core protocol files:
- `DR-X-MANIFEST.md`
- `system/ETHOS.md`
- `system/DECISION.md`
- `system/RETRO.md`

---

## Versioning

We use [Semantic Versioning](https://semver.org/):

- **MAJOR** (2.0.0): Breaking changes to protocol
- **MINOR** (1.4.0): New features, backward compatible
- **PATCH** (1.3.1): Bug fixes, clarifications

Version bumps happen on release, not per-commit.

---

## Review Process

1. All PRs require at least one review
2. Protocol changes require testing on 2+ LLMs
3. Controversial changes may be deferred to next major version
4. Maintainers have final say on determinism tradeoffs

---

## License

By contributing, you agree that your contributions will be licensed under DR-X-V3.

If your contribution includes substantial new protocol elements, you will be credited in the changelog.

---

## Contact

- Issues: GitHub Issues
- Discussions: GitHub Discussions (if enabled)
- Security: Report privately via GitHub Security tab

---

→ NEXT ACTION: Found a bug or gap? Open an issue with reproduction steps.
