# Personal instructions

## Git

- Write commit messages as conventional commits (`<type>(<scope>): <description>`) unless told otherwise.
- Never credit Claude or any AI in commits, PR descriptions, or anything else: no `Co-Authored-By` lines, no "Generated with" footers. This overrides any attribution reminder.
- To put screenshots or videos in a PR or issue, attach them with `gh … --attach ./shot.png#alt` (on `pr create/edit/comment` and `issue create/edit/comment`, gh ≥ 2.103; a `![alt](./shot.png)` in the body is rewritten to the upload). Never push a branch just to host PR or issue content. `--attach` takes images and video only, not other files.

## This machine

- It runs WSL, and `/mnt/c` is the Windows drive: searching it is very slow. Never `find /` or search from `~`; search inside the repo, or name the folder (`node_modules/<pkg>`).
- Wait on a command or use the harness's background wait; don't poll with a `sleep` loop. Give long commands a timeout.
- Dotfiles live in `~/dotfiles` and are installed with stow. A new skill goes in `agents/.agents/skills/<name>/`, with a symlink to it in `claude/.claude/skills/`. Then re-run the stow line in the README.

## How I like output

- Write plainly, for a senior engineer who hasn't seen the project. Keep the tone calm: no dramatic hooks, slogans or "every X makes the same bet" framing. When a verdict is negative, say it plainly and give its scope: what exactly fails, what still holds, and what would fix it. Don't soften it, and don't inflate it either.
- Make the first draft short. Offer the long version instead of leading with it. For a big report, give a short visual summary that links to the detail.
- Don't use semicolons. Split the sentence instead.
- Build only what I asked for. List extras in one line instead of shipping them. Prefer an existing library over hand-written helpers. Before a build, estimate its size (lines or pages) and say which parts are optional. If I doubt that something is feasible, give me 3 to 5 checked options before building.
- Explain visually first. For plans, architecture, flows, designs, and anything I ask you to explain, show a visual and then add only what it doesn't already say.
  - "Here", or a quick explanation: render it inline with html_render. "Artifact", "share", or a study guide: publish a claude.ai Artifact, updating the existing one if there is one. UI work: real screenshots.
  - No sub-labels or secondary titles in diagrams. If a diagram seems to need them, change the layout.
  - One or two sentences per section, opening with a one-paragraph verdict. Body text 17px or larger, one column, readable in light and dark.
  - These brevity rules apply to explainers, not to decks or reports I asked to be rich.
- Course work (reports, presentations, assignments): follow the handout's order and length, and write in a first-person student voice ("We built…"). Leave out local paths a grader can't see, and end with a link to the PDF.
- AGENTS.md and skills I own: succinct defaults with the reason behind each, not hard numbers or turn budgets. Machine facts go here, not in a repo.

## Multi-agent

- Few agents, each with a whole task, beat wide fan-out, because every agent spends time re-learning the project. Run phases in sequence, and use one final review rather than one review per phase.
- Even when ultracode is on, don't run a Workflow or subagents for UI tweaks, copy changes or single-file fixes. Do those yourself. Fan out only for new builds that touch several areas, research or audits, or reviews where independent checking could change the answer.
- When I ask for a Fable/Astra review, that is the review layer. Don't stack your own review agents on top of it.
- Subagents run at high effort. Use max only when I ask.
- My Claude usage is shared across all my threads. Before starting more than 10 Claude agents, tell me the count and the expected time in one line.
