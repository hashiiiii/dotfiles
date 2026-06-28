---
name: git-branch-and-commit-conventions
description: Use when creating a git branch, writing a git commit message, or opening a pull request — at the moment you run `git switch -c` / `git checkout -b`, `git commit`, or `gh pr create`. Symptoms: unsure what to name a branch, which type/prefix to use, how long a commit subject may be, whether to add a commit body, or which label a PR needs.
---

# Git Branch & Commit Conventions

## Overview

One shared `type` vocabulary drives three artifacts: the **branch name**, the **commit subject**, and the **PR label**. Decide the type once and all three line up.

## When to Use

- Right before `git switch -c` / `git checkout -b` — naming a branch
- Right before `git commit` — writing the message
- Right before / at `gh pr create` — labeling the PR

Not for: choosing a branching strategy (git-flow vs trunk), squash/rebase policy, or release tagging.

## The Contract — what each artifact IS

**Branch** — `<type>/<short-english-kebab>`
- English, kebab-case, terse. No issue numbers, no extra prefixes, no personal names, no Japanese.
- e.g. `feat/yaml-parser`, `fix/nested-override-diff`, `docs/cli-usage`

**Commit** — a single line: `<type>: <日本語 subject>`
- The subject is **Japanese**, concise, **≤ 50 文字** (全角・半角ともに 1 文字として数える).
- The message is **exactly one line**. The subject line is the whole message — nothing follows it.
- e.g. `feat: Unity Prefab 用の YAML パーサを実装`

**PR** — apply a GitHub label whose name is the branch `type` (`feat`, `fix`, …) when opening the PR.
- `gh pr create --label <type> ...`
- If that label does not exist in the repo yet, create it first: `gh label create <type>`

## Type vocabulary (shared by branch, commit, and label)

| type | use when |
|------|----------|
| `feat` | a new feature or capability |
| `fix` | a bug fix |
| `docs` | documentation only |
| `style` | formatting / whitespace, no behavior change |
| `refactor` | restructuring without behavior change |
| `perf` | performance improvement |
| `test` | adding or fixing tests |
| `build` | build system or dependencies |
| `ci` | CI configuration |
| `chore` | misc maintenance (e.g. `.gitignore`) |
| `revert` | reverting a prior commit |

Pick the closest one. Do not invent new types.

## Worked example

Change: implemented a YAML parser for `.prefab` files.

```bash
# 1. branch — type / english-kebab
git switch -c feat/yaml-parser

# 2. commit — one line, Japanese subject ≤ 50 文字, no body
git commit -m "feat: Unity Prefab 用の YAML パーサを実装"

# 3. PR — label = type (create the label first if missing)
gh label create feat 2>/dev/null
gh pr create --label feat --title "feat: Unity Prefab 用の YAML パーサを実装"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Adding a body / bullet points under the subject | The commit is one line. Detail belongs in the PR description, not the commit. |
| Writing the subject in English | The subject is Japanese; only the `type:` prefix stays English. |
| Subject longer than 50 文字 | Trim to the essence. 50 文字 is the hard limit. |
| Branch like `feature/…`, `bugfix/…`, `john/…`, or with Japanese | Use a `type` from the table + a short english kebab description. |
| Opening a PR with no label | Add `--label <type>` matching the branch type. |
| Inventing a new type | Only the 11 types above exist. Pick the closest. |
