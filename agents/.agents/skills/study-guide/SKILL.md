---
name: study-guide
description: Build a one-page visual guide that helps the user understand and present their own project, assignment or past work for an exam, oral, demo or interview. Use when the user says they forgot what a project does, asks to understand or present it, or wants to prepare questions about their own work.
---

# Study guide

The user often comes back to a project they built weeks ago and needs to explain it quickly and confidently. Build them one page they can study from.

## Gather

1. Read the requirements or handout first, then the repo. If course material may be stale (for example on Blackboard), sync it before relying on it.
2. Run the tests and every demo command you plan to recommend. Flag anything that could fail live (slow runs, flags that need a specific machine, missing data).

## Build one page

- Open with a one-paragraph verdict: what the project does and how well it meets the brief.
- A file map: which files matter and what each one does.
- One simple pipeline diagram of how the pieces connect. No sub-labels or secondary titles.
- For each task in the brief: what was asked, what we did, and the key code (short excerpts with file paths).
- Charts drawn from the repo's own results (CSV or logs), not invented numbers.
- A short table of trade-offs and alternatives we didn't take, and why.
- 15 to 20 likely questions with short answers, and a demo script with the exact commands.
- Use public images only. Don't copy anything under NDA or anything private.

## Format

- 17px or larger body text, one column, readable in light and dark, one or two sentences per section.
- Check it with html_preview, then publish it as a claude.ai Artifact. If a guide for this project already exists, update it in place instead of making a new one.
- End the reply with the link, plus a one-line list of anything you couldn't verify.
