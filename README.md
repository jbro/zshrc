## Install

    $ git clone https://github.com/jbro/zshrc.git ~/.config/zsh

Create `~/.zshenv` containing:

    export ZDOTDIR=~/.config/zsh

## Plugins

Minimal built-in plugin loader in `functions/internal/plugin`. Supports full repos, specific branches, and sparse-checkout subdirectories (snippets). Plugins are cloned on first use into `$ZDOTDIR/plugins/`.

    plugin url='<repo>' [branch='<branch>'] [initfile='<file>'] [subdir='<path>']

- `branch` — Clone a specific branch or tag.
- `initfile` — Source this file instead of `*.plugin.zsh`.
- `subdir` — Sparse-checkout a single subdirectory (used for omz snippets).

Update all plugins with `update_zsh_plugins`. Use `--clean` to remove and re-fetch everything.

## Lazy completions

`lazy-completion` generates and caches completions on first tab-complete, then version-checks every 20h. Cache lives in `completions/local/`.

    lazy-completion <cmd> <generate-cmd> <version-cmd>

## Quick paths

List directories in `quick_paths` (one per line). They are added to `cdpath` so you can `cd` into their children by name from anywhere.

## Environment

- `env/<ostype>` — OS-specific env vars, sourced automatically (e.g. `env/darwin`).
- `env/local` — Machine-local env vars (gitignored).

## Functions

- `functions/` — Shared functions, autoloaded everywhere.
- `functions/<ostype>/` — OS-specific functions, only loaded on matching OS (e.g. `functions/darwin/`).
- `functions/local/` — Machine-local functions (gitignored).

## Doctor annotations

Tag any conditional feature in `.zshrc` or `functions/` with:

    # doctor: <description> requires: <cmd> [<cmd> ...]

Functions should also self-disable when dependencies are missing:

    (( $+commands[foo] && $+commands[bar] )) || { unfunction my-func; return 0 }

Run `zshrc_doctor` for a full health report (PATH, fpath, plugins, compiled functions, feature deps, completion cache).

## Auto-compilation

All function files are automatically compiled to `.zwc` on shell startup when the source is newer than the cached version. The `.zwc` files are gitignored.

## Diagnostics

- `zshrc_doctor` — Health check.
- `zshrc_benchmark` — Startup timing per plugin and overall.
- `zshrc_show_new_vars` — List variables introduced by this zshrc.
- `ZSH_PROFILE=1 zsh` then `zshrc_profile` — Full `zprof` output.
