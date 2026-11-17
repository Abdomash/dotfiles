---
name: setup-repo-for-agents
description: Set up or restructure a repository so coding agents work well in it — an AGENTS.md written as defaults (not rules), task-shaped skills in .agents/skills, and scripts for work agents keep rediscovering (checks, test environments, worktree setup). Use when the person asks to make a repo agent-ready, write or rework AGENTS.md, or add agent skills/tooling to a repo.
---

# Set up a repo for agents

The goal is an `AGENTS.md` plus a small set of skills and scripts that give any coding
agent (Claude Code, Codex, OpenCode, others) context and good tools, not a rulebook, and
that future agents keep extending in the same spirit.

The person's instructions override anything here. If they asked for only part of this
(say, just an AGENTS.md), do that part.

## Principles

Apply these to everything you write into the repo.

- **Defaults, not rules.** Write guidance as good defaults with the reason behind them.
  State plainly in AGENTS.md that the person's instructions override anything in it.
- **Explain the cost, then give clear direction.** Prefer "X takes about a minute because
  it rebuilds the database; `scripts/env.sh up` reuses a running one" over "always use
  env.sh". Still be concrete and short: "Use `--fast` while iterating on what you
  changed. Use `--full` sparingly: when a change crosses packages, and once before
  pushing." Vague advice ("use judgement") is as unhelpful as a rigid rule.
- **"Never" only for real hazards**, such as data loss, killing processes you didn't start,
  or pointing tests at a real database. Give each its reason, and keep the list short.
- **No numbers that need maintaining.** No turn budgets, line limits or "run X exactly N
  times". Say what a threshold depends on instead ("small, low-risk diffs").
- **Repo-level only.** Nothing about a particular machine, OS quirk, editor or person's
  setup; that belongs in their global agent config. No model names or vendor-specific
  model routing either: describe how much reasoning a task needs, and defer to the
  person's stated preference or the tool's default.
- **The code is the source of truth.** Don't copy facts that live in code (tokens, config,
  schemas); point to the file. Delete or rewrite stale docs instead of layering new ones
  on top.
- **Short.** AGENTS.md is read on every turn, so every line has to earn its place.
  Knowledge only some jobs need goes in a skill that loads on demand.

## 1. Investigate before proposing (read-only)

Read the README, any existing AGENTS.md, CLAUDE.md or docs, the package manifests, the CI
config, the test setup and the scripts. If past agent transcripts or session logs are
available, read them too: they show where agents actually lose time. Find out:

- What the project is, what lives where, and any naming an agent would get wrong
  (internal code names vs. public names, generated files, code mirrored across apps).
- **What agents keep rediscovering or paying for again and again:** how to verify a change, which
  tests are slow and why, how to start the app or a test environment, how to see the UI,
  how to set up a fresh checkout or worktree, how to seed data.
- Which existing docs are stale or contradict the code.
- The real hazards in this repo.

Time the slow paths you find, so you have "before" numbers.

## 2. Propose a plan and wait for approval

Show the layout, the outline of AGENTS.md, each skill's purpose and `description`, the
scripts and code changes they rely on, what you'd delete, and the order of work. Call
out the decisions the person should make. Don't build until they agree. Their
corrections at this stage are usually where most of the value comes from.

## 3. Build

Target layout. Adapt it to the repo and leave out what it doesn't need:

```
AGENTS.md                      # always-loaded context (outline below)
CLAUDE.md                      # one line: @AGENTS.md
.agents/skills/<name>/SKILL.md # task-shaped skills; YAML frontmatter: name, description
.agents/skills/<name>/scripts/ # helper scripts only agents use
.claude/skills -> ../.agents/skills   # symlink so Claude Code finds them
scripts/                       # tools both people and agents use
```

If `.claude/` is gitignored, change that to `.claude/*` plus `!.claude/skills`.

**Tools for work agents keep rediscovering.** Build the ones this repo needs:

- **A check script** with a fast mode (only what changed, for quick feedback) and a full
  mode (everything, before pushing). Print one summary line per step. On failure, print
  the tail of the output and keep the full log in a gitignored folder.
- **An environment script** (`up | reset | down | status`) for anything slow to start,
  such as the app, a database or e2e fixtures. `up` must be safe to call any number of times and
  near-instant when the environment is already healthy. `down` stops only what it started, by the PID it recorded.
  Derive ports and database names from the checkout path, so parallel worktrees don't
  collide. Tests should reuse a healthy running environment and fall back to a fresh one, so
  CI behaves as before.
- **A checkout/worktree setup script** that is safe to rerun and skips what's already done.
- **A screenshot or "see the result" helper** if the project has a UI.

Measure each one against the "before" numbers.

**Skills.** Keep them few, and build each around a task (for example `e2e`, `design`,
`review` or `workflow`), not around a single command. The `description` decides when a
skill loads, so phrase it as "Use when …". Put anything every agent needs, like checks
and worktrees, in AGENTS.md instead of a skill.

**AGENTS.md outline:**

1. **What this is**, in a few lines, plus naming notes. Then: "These are defaults, not
   hard rules. The person's instructions win."
2. **Map:** what lives where, plus generated files and how to regenerate them.
3. **Checks:** when to use fast and when to use full. Read a failure before rerunning.
   In multi-agent work, only the agent that integrates the work runs the full check.
4. **Worktrees and scratch:** use worktrees only when several agents write at once.
   Unrelated work can share a branch. Read-only agents use `git diff` and `git show`
   instead of a checkout. Fixers work in the existing worktree. Run the setup script in
   a new one. Keep scratch files outside the repo.
5. **Hazards:** the short "never" list, each with its reason.
6. **Skills:** one line each, saying what it's for and when to load it.
7. **Keeping this file useful.** Include this section, adapted:
   > When you notice yourself or another agent rediscovering something, such as a slow
   > command, a setup step or how to see a result, prefer adding a script or a few
   > lines to the right skill over solving it again. Write additions in the same style:
   > explain the cost, give clear "use when" guidance, no hard numbers, nothing
   > specific to a machine or a model. If something here is wrong or stale, fix it in
   > the same change. Keep this file short, and move job-specific knowledge into a skill.

If the repo runs multi-agent workflows, add a `workflow` skill that says:

- Merge phases so each agent does a whole job (build plus self-check; checks, e2e and
  screenshots; review; fix) rather than giving one agent to each command.
- Use per-phase checks or one thorough final review, not both.
- Pass existing worktree paths along instead of creating new worktrees.
- Describe how much reasoning each stage needs instead of naming models.
- Label any tool-specific options as examples in that tool's terms.

## 4. Deliver

- Work on a branch.
- Commit by concern (tooling, doc deletions, AGENTS.md plus skills) so each commit can
  be reviewed on its own.
- Run the full check.
- Give the person a review guide: for each commit, what changed, the decisions you made
  and the risk in each, and before/after timings marked as measured or estimated.
- Don't push until asked.
