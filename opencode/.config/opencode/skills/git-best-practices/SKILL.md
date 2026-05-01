---
name: git-best-practices
description: Instructions for git commits and pull requests.
---

## Commits

- Large changes should be split into multiple, composable, logically-separated commits.
- Commits should be formatted as:

```
<type>(<scope>): <description>

<optional-body>
```

## Pull Requests

- PR titles should be `<type>(<scope>): <description>`.
- Keep PR descriptions focused on high-level changes and their rationale.
- Mention interface changes or new public APIs.
- Do not list files changed, lines added/removed, or similar superficial details.
