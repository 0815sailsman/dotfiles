# AGENTS.md

Personal Linux (Hyprland/Wayland) dotfiles managed with **GNU Stow**. No build/test/lint — just config files.

## Stow layout (critical)
- Each top-level dir (`nvim`, `hypr`, `zsh`, ...) is a Stow *package* whose contents mirror `$HOME` 1:1.
- Edit config files at their real in-repo path (e.g. `nvim/.config/nvim/init.lua`), NOT in `$HOME`. After `setup.sh`, the `$HOME` paths are symlinks back into this repo.
- A package's internal structure = its install location: `zsh/.zshrc` → `~/.zshrc`; `starship/.config/starship.toml` → `~/.config/starship.toml`; `assets/wallpaper.png` → `~/wallpaper.png`.

## Adding a new config package
1. Create `pkg/<path-relative-to-home>/file`.
2. Add the package name to the `base=( ... )` array in `setup.sh` — packages are NOT auto-discovered; if it's not in the array it won't be stowed.
3. Re-run `./setup.sh` (runs `stow -v -R -t $HOME <pkg>` for each).

## Apply / install
- `./setup.sh` — inits git submodules then stows every `base` package. Idempotent (`-R` restows). Requires `stow` installed.
- `useronly=()` array is currently empty (root-vs-user split exists but unused).

## Notes
- `docs/` is documentation only — it is NOT in `base`, so it is never stowed.
- nvim uses **lazy.nvim**; plugins live in `nvim/.config/nvim/lua/saylor/plugins/`, pinned in `lazy-lock.json` (commit lockfile changes intentionally).
- No CI, no tests. Verification = symlinks resolve correctly and the target app loads its config.
