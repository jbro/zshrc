## Install

    $ git clone https://github.com/jbro/zshrc.git ~/.config/zsh

Create `~/.zshenv` containing:

    export ZDOTDIR=~/.config/zsh

## Structure

- `zshrc.d/` — Modular config files sourced by `.zshrc`:
  - `package-managers.zsh` — Homebrew, asdf, bun, cargo PATH setup.
  - `plugins.zsh` — Third-party plugin declarations.
  - `aliases.zsh` — Command aliases for modern replacements.
  - `lazy-completions.zsh` — On-demand completion generation.
- `theme/` — Visual theme data (LS_COLORS).
- `env/` — Environment variables (`<ostype>`, `local`, `quick_paths`).
- `functions/` — Autoloaded functions (`internal/`, `<ostype>/`, `local/`).
- `.completions/` — Cached/generated completions (gitignored).
- `.plugins/` — Third-party plugins (auto-cloned, gitignored).

## Plugins

Minimal built-in plugin loader in `functions/internal/plugin`. Supports full repos, specific branches, sparse-checkout subdirectories (snippets), and conditional loading. Plugins are cloned on first use into `$ZDOTDIR/.plugins/`.

    plugin url='<repo>' [branch='<branch>'] [initfile='<file>'] [subdir='<path>'] [requires='<cmd>']

- `branch` — Clone a specific branch or tag.
- `initfile` — Source this file instead of `*.plugin.zsh`.
- `subdir` — Sparse-checkout a single subdirectory (used for omz snippets).
- `requires` — Only load if `<cmd>` is installed. Returns 1 when skipped, so `&& { }` can gate setup code.

Update all plugins with `zshrc_update_plugins`. Use `--clean` to remove and re-fetch everything.

## Package managers

`add-package-manager` in `functions/internal/` guards PATH setup behind availability checks and tracks registrations for `zshrc_doctor`. Accepts a command name or full path (paths are file-checked, commands use `$+commands`).

    add-package-manager <cmd-or-path> && { ... }

## Aliases

`alias-if` in `functions/internal/` sets an alias only when its backing command is installed, and tracks registrations for `zshrc_doctor`.

    alias-if <cmd> <alias>=<value>

## Lazy completions

`lazy-completion` generates and caches completions on first tab-complete, then version-checks every 20h. Cache lives in `.completions/`.

    lazy-completion <cmd> <generate-cmd> <version-cmd>

## Quick paths

List directories in `env/quick_paths` (one per line, gitignored). They are added to `cdpath` so you can `cd` into their children by name from anywhere.

## Environment

- `env/<ostype>` — OS-specific env vars, sourced automatically (e.g. `env/darwin`).
- `env/local` — Machine-local env vars (gitignored).

## Functions

- `functions/` — Shared functions, autoloaded everywhere.
- `functions/<ostype>/` — OS-specific functions, only loaded on matching OS (e.g. `functions/darwin/`).
- `functions/local/` — Machine-local functions (gitignored).

## Doctor annotations

Tag any conditional feature in `functions/` with:

    # doctor: <description> requires: <cmd> [<cmd> ...]

Functions should also self-disable when dependencies are missing:

    (( $+commands[foo] && $+commands[bar] )) || { unfunction my-func; return 0 }

Run `zshrc_doctor` for a full health report (PATH, fpath, plugins, compiled functions, feature deps, completion cache).

## Auto-compilation

All function files are automatically compiled to `.zwc` on shell startup when the source is newer than the cached version. The `.zwc` files are gitignored.

## Diagnostics

- `zshrc_doctor` — Health check.
- `zshrc_benchmark` — Startup timing per plugin and overall.
- `zshrc_recompile` — Recompile all function files.
- `zshrc_show_new_vars` — List variables introduced by this zshrc.
- `ZSH_PROFILE=1 zsh` then `zshrc_profile` — Full `zprof` output.
