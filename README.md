## Install

    $ git clone https://github.com/jbro/zshrc.git ~/.config/zsh

Create `~/.zshenv` containing:

    export ZDOTDIR=~/.config/zsh

To track local files (env, functions, config) with their own git history, run `git-private init local`.

## Structure

`env/`, `functions/`, and `config/` each support three scopes, loaded in order:

- **Dist** — shared, committed to the repo.
- **OS-specific** — `<ostype>/` subfolder (e.g. `darwin/`), committed.
- **Machine-local** — under `local/`, gitignored.

| | Dist | OS-specific | Machine-local |
|---|---|---|---|
| **env** | `env/common` | `env/darwin` | `local/env` |
| **functions** | `functions/*` | `functions/darwin/` | `local/functions/` |
| **config** | `config/*.zsh` | `config/darwin/*.zsh` | `local/config/*.zsh` |

Other directories:

- `functions/internal/` — Helper functions used by config files.
- `theme/` — Visual theme data (LS_COLORS).
- `.completions/` — Cached/generated completions (gitignored).
- `.plugins/` — Third-party plugins (auto-cloned, gitignored).

## Config load order

Config files from all three scopes (`config/`, `config/<ostype>/`, `local/config/`) are collected into a single list and sorted by filename. Numeric prefixes control the global load order:

    config/darwin/10-package-managers.zsh   # homebrew PATH setup
    config/20-package-managers.zsh          # asdf, bun, cargo (need PATH from above)
    config/30-plugins.zsh
    config/40-aliases.zsh
    config/50-lazy-completions.zsh
    local/config/60-quick-paths.zsh

This means a darwin config at `10-*` loads before a dist config at `20-*`, even though they're in different directories. To interleave, just pick the right number -- e.g. `local/config/15-something.zsh` would slot between 10 and 20.

Run `zshrc_doctor` to see the resolved load order.

## Config helpers

Config files in `config/` use helper functions from `functions/internal/`. These are available during init and cleaned up afterwards. All helpers track registrations for `zshrc_doctor`.

**plugin** — Clones and sources third-party plugins. Supports branches, sparse-checkout subdirectories (snippets), and conditional loading with `requires`. Update with `zshrc_update_plugins` (`--clean` to re-fetch).

    plugin url='<repo>' [branch='<branch>'] [initfile='<file>'] [subdir='<path>'] [requires='<cmd>']

**add-package-manager** — Guards PATH setup behind availability checks. Accepts a command name or full path.

    add-package-manager <cmd-or-path> && { ... }

**alias-if** — Sets an alias only when its backing command is installed.

    alias-if <cmd> <alias>=<value>

**lazy-completion** — Generates and caches completions on first tab-complete, version-checks every 20h.

    lazy-completion <cmd> <generate-cmd> <version-cmd>

**quick-path** — Adds a directory to `cdpath` for quick `cd` access. Silently skips directories that don't exist. Typically used in `local/config/quick-paths.zsh`.

    quick-path <dir>

## Shell settings

Keybindings (emacs mode, alt+arrow word navigation, up/down history prefix search), history, completion styles, direnv integration, and p10k prompt customization are configured directly in `.zshrc`.

## Writing functions

Function files are placed in `functions/` (or the appropriate scope directory) and autoloaded by name. The file contents are the function body -- no wrapping `function name { }` definition needed. All function files are automatically compiled to `.zwc` on startup.

Command wrappers should declare their dependencies with a doctor annotation and self-disable when they're missing. `zshrc_doctor` scans for these annotations to report which features are available.

```zsh
# vim: ft=zsh
# doctor: my-func requires: foo bar
(( $+commands[foo] && $+commands[bar] )) || { unfunction my-func; return 0 }

# function body here
```

## Diagnostics

- `zshrc_doctor` — Health check (PATH, fpath, plugins, compiled functions, feature deps, completion cache).
- `zshrc_benchmark` — Startup timing per plugin and overall.
- `zshrc_recompile` — Recompile all function files.
- `zshrc_show_new_vars` — List variables introduced by this zshrc.
- `ZSH_PROFILE=1 zsh` then `zshrc_profile` — Full `zprof` output.
