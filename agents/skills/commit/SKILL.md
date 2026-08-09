---
name: commit
description: >-
  Conventions for writing git commit messages — scoped imperative subject,
  prose body explaining what changed and why, issue references. Use when
  creating a git commit.
---

Create a git commit for the current changes using a concise subject.

## Format

```
<scope>: <summary>

<long form description>

<references>
```

## Rules

### Subject line

- `scope` OPTIONAL. Short noun in parentheses for the affected area (e.g.,
  `api`, `parser`, `ui`) determined from the file paths of the diff. Use nested
  scopes with `/` when helpful and exclusive (e.g., `ui/components`).
- `summary` REQUIRED. Short, lowercase start (not capitalized), imperative
  mood, no trailing period. Keep it concise—ideally under 60 characters total
  for the whole subject line.

### Long form description

- Describe **what changed**, **what the previous behavior was**, and **how the
  new behavior works** at a high level.
- Use plain prose, not bullet points. Wrap lines at ~72 characters.
- Focus on the _why_ and _how_ rather than restating the diff.
- Keep the tone direct and technical without filler phrases.
- Don't exceed a handful of paragraphs; less is more.

### References

- If the change relates to a GitHub issue, PR, or discussion, list the relevant
  numbers after the description, separated by a blank line. Prefix with a
  keyword like "Fixes" or "Closes" or "Resolves". Default to "See" if there's
  not a more specific keyword. Group each keyword list on its own line.
  E.g. `Fixes #123` or `See #456, #789`.
- If there are no references, omit this section entirely (no blank line).

## Notes

- Only commit; do NOT push.
- Always `git add <path ...>` specific files. Never bulk-add using `git add -A`.
- If it is unclear whether a file should be included, ask the user which files to commit.
