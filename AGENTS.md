# AGENTS.md

Design rationale for AI agents (Claude Code, etc.) working in this repo.
**This file holds WHY only.** For WHAT — commands, layout, how to use it — see
[`README.md`](README.md); for the canonical machine-setup declarations, read
[`mise.toml`](mise.toml). `CLAUDE.md` is a symlink to this file so Claude Code
picks it up automatically.

## Why `mise bootstrap` is the center of gravity

Machine setup is **declarative and convergent**: almost everything lives in
`mise.toml` and is applied by `mise bootstrap` (idempotent, re-runnable). The
only imperative code is `bootstrap.sh`, which does the bare minimum to get
Homebrew + mise onto a fresh machine, then hands off. One command, one source of
truth, safe to re-run — no bespoke install scripts to drift out of sync.

## Why `~/.config` is a whole-directory symlink, but `~/.claude` is not

`~/.config` is a single directory symlink into this repo, so editing the repo IS
editing the live config. That is safe because `~/.config` is mostly static and
guarded by the `.gitignore` allowlist.

`~/.claude` is the opposite: ~660MB of runtime/secret data sits next to its
settings — `projects/` (full conversation logs), `security/`, `history.jsonl`,
and `0600` dirs like `sessions/` and `daemon/`. Whole-directory symlinking it
into a **public** repo would leak secrets and keep `git status` perpetually
dirty. So only the settings subset is linked — `~/.claude/settings.json` and
`~/.claude/hooks` from `home/.claude/`. Runtime data stays out of the repo by
construction. (Repo-root `.claude/` for project-local settings was removed;
agent behavior is configured globally via `home/.claude/`.)

## Why the Brewfile stays, and formulae are NOT moved into mise `[tools]`

mise's package backend handles Homebrew **formulae** only — not casks or Mac App
Store apps. Casks/MAS must live in the `Brewfile`. Moving just the formulae into
mise `[tools]` would split package management across two files for no gain, so
all Homebrew packages stay in one place and `mise bootstrap` runs `brew bundle`.

## Why there is no plugin manager (sheldon was removed)

Once the zsh plugin set shrank to a handful, a dedicated manager stopped paying
for itself. `zsh-autosuggestions`, `zsh-fast-syntax-highlighting`, and `fzf` are
brew formulae, so they install via the Brewfile (one bootstrap path) and are
`source`d directly in `.zshrc`. This drops a dependency and folds plugin install
into `mise bootstrap`. The cost is losing `zsh-defer`'s lazy loading (no brew
formula for it), but startup is ~0.1s, so synchronous sourcing is fine.

## Why `.zprofile` and `.zshrc` are split by role

`.zprofile` (login shell, once) holds environment + PATH; `.zshrc` (every
interactive shell) holds plugins, prompt, history, key bindings, aliases. Keeping
PATH/env out of `.zshrc` makes non-interactive `zsh -c` and SSH behavior
predictable. `.zshenv` is intentionally unused — the two-file split is enough.

## Why `.gitignore` is an allowlist

Because `~/.config` is a whole-directory symlink into a PUBLIC repo, any tool
that writes under `~/.config/<tool>/` writes straight into the working tree. So
`.config/*` is default-denied and only known-safe tool dirs are explicitly
allowed, with credential files re-excluded. The allowlist is the primary guard;
the gitleaks pre-commit hook is defense-in-depth.

## Why `bootstrap.sh` is POSIX `sh`

It must run on a stock macOS shell before anything is installed. No bashisms
(`[[ ]]`, arrays, `local`, `pipefail`) so it works on the default `/bin/sh`.

## Recovery is forward-only

mise converges forward; it does not roll back. Manual recovery (unlink symlinks,
`chsh` back, `brew uninstall`) is documented in the README. There is
intentionally no automated restore.
