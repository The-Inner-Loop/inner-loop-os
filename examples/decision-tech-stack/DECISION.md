# DECISION — DR-X-V1

A one-shot decision protocol.
Use when stakes are non-trivial or ambiguity is blocking progress.

---

## 0) NAME THE DECISION
Decision:
- Use React or Svelte for the new analytics dashboard?

---

## 1) DEFINE THE OPERATOR
Who is deciding?
- Me (solo developer)

Who is affected?
- Future maintainers (possibly just me)
- Users (indirectly — affects performance and reliability)

---

## 2) DEFINE THE OPTIONS (MAX 3)
Option A:
- React with Vite
- Known ecosystem, huge community, proven at scale

Option B:
- Svelte with SvelteKit
- Smaller bundle, less boilerplate, newer but stable

Option C:
- Not considered (two is enough for this decision)

---

## 3) DEFINE THE SUCCESS CRITERIA (MAX 5)
- Dashboard loads in under 2 seconds
- Can be maintained by a single developer
- Easy to add new chart types
- Doesn't require constant dependency updates
- I actually enjoy working on it

---

## 4) DEFINE CONSTRAINTS (NON-NEGOTIABLES)
- Must work in all modern browsers
- No proprietary lock-in
- Must be deployable to static hosting
- Budget: $0 (open source only)

---

## 5) RISK / REVERSIBILITY CHECK

Option A (React):
- Worst-case outcome: Slower bundle, more boilerplate than needed
- Is it reversible? (Y/N): Y — can rewrite, but costly
- Cost to reverse: 2-3 weeks of work
- Time to detect failure: 1 week (performance issues surface quickly)

Option B (Svelte):
- Worst-case outcome: Hit edge case not covered by smaller ecosystem
- Is it reversible? (Y/N): Y — can rewrite, but costly
- Cost to reverse: 2-3 weeks of work
- Time to detect failure: 2-3 weeks (ecosystem gaps emerge during advanced features)

---

## 6) THE DR-X FILTER

Option A (React):
- Does it increase human agency? Y — widely understood, easy to hire
- Does it reduce cognitive drag? N — more boilerplate than Svelte
- Does it preserve ownership? Y — open source, no lock-in
- Does it keep exit paths? Y — can migrate away if needed

Option B (Svelte):
- Does it increase human agency? Y — less code to maintain
- Does it reduce cognitive drag? Y — simpler mental model
- Does it preserve ownership? Y — open source, no lock-in
- Does it keep exit paths? Y — can migrate away if needed

Neither is hostile. Both pass.

---

## 7) DECIDE (AND WRITE IT DOWN)
Chosen option:
- Option B: Svelte with SvelteKit

Reason (1–3 bullets):
- Less boilerplate = less cognitive drag (aligns with success criteria)
- Smaller bundles = better performance out of the box
- I've been wanting to learn it — motivation matters for solo projects

---

## 8) COMMITMENT CONTRACT
What happens next?

Next Action:
- Create new SvelteKit project with TypeScript template

Owner:
- Me

Deadline:
- Today (2026-01-09)

Rollback Trigger:
- If I can't implement a basic chart component in 3 days, reconsider React.

---

→ NEXT ACTION:
Execute the Next Action exactly. Then update STATUS.md.
