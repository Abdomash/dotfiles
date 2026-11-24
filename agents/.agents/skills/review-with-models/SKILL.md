---
name: review-with-models
description: Run a review round with Fable and/or GPT Astra (plan, bug, UI or simplify review), then fix, check and hand off. Use when the user asks for a review "with Fable and Astra", "with GPT", "both models", a plan/bug/UI/simplify review round, or "review, fix, merge".
---

# Review with models

The user asks for this pipeline often. Run it the same way each time so they don't have to spell it out.

## Setup

- Models: Fable 5.2 (Claude) and GPT 6.2 Astra (Codex), unless the user names others. Keep the model ids in this one line so a version bump is a one-line edit.
- Effort: xhigh for both, unless the user says otherwise. If they give an effort for only one model, use it for both. This overrides the "subagents run at high" default in CLAUDE.md. Always pass Astra's effort explicitly, because Codex defaults to low. State the choice in one line and don't ask about it.
- Rounds: only the ones asked for (plan, bug, UI, simplify). Don't add rounds.

## Each round

1. Commit the work, then pin the reviewed commit: "review `<sha>` against `<base>`. The parent may commit fixes on top."
2. Write one brief and give it to both models: scope, read-only, no command that runs longer than a few minutes, and findings ranked as changes-the-conclusion / bug / polish, each with "re-run needed?".
3. Launch both with delegate_task, Fable first. Keep working on non-conflicting things while they run (tests, screenshots, the next stage).
4. Astra usually finishes first. Apply its findings straight away. When Fable reports, check each finding against the current HEAD and mark "already fixed" where it applies. Fold the rest in as a follow-up commit.
5. Don't poll the reviewers, because their results wake you. If T3 reports that one failed or was cancelled, relaunch it once or carry on without it and say so. Don't set a deadline either: Fable is slow, but it finds things nobody else does.
6. Before acting on a finding that only one reviewer raised, reproduce it.
7. Post a short triage table: finding, found by, verified, accepted/rejected (with the reason), already fixed.

## After the last round

- Run the repo's full check once on the final HEAD, not after every fix.
- Hand off to the repo's own ship steps (AGENTS.md or its skill) if the user asked for merge or deploy.
- If a Claude usage limit hits, tell the user, then continue with Astra only rather than retrying Fable.
- Don't start your own Workflow or Agent review panels on top of these reviewers.
