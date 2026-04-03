# AGENTS.md — Dotfiles Repository

This is a personal dotfiles repository managed with [Nix](https://nixos.org/) and
[Home Manager](https://github.com/nix-community/home-manager). It configures two
machines: a macOS host (`MACHXPVL4MXK7`) and a Linux host (`sh101`). The Neovim
configuration lives under `nvim/` and is written in Lua.

---

## Repository Layout

```
flake.nix                        # Nix flake entry point; defines both Home Manager configs
flake.lock                       # Pinned input hashes — do not edit by hand
home/
  sh101-home.nix                 # Linux machine (Thinkpad)
  MACHXPVL4MXK7/
    home.nix                     # Main macOS config (packages + programs)
    git.nix                      # Git + gh CLI config, lolcommits hook
    zsh.nix                      # Zsh, oh-my-zsh, yazi, aliases
    oh-my-posh.nix               # Prompt theme
    darwin-aerospace.nix         # AeroSpace tiling WM (embedded TOML)
    borders.nix                  # JankyBorders (embedded shell script)
    dotfiles.nix                 # Symlinks nvim config + SSH allowed signers
    custom.omp.json              # Oh-my-posh theme JSON
nvim/
  .editorconfig                  # Lua: 4-space indent
  init.lua                       # Single require("config.lazy")
  lazy-lock.json                 # Plugin version lockfile — do not edit by hand
  lua/
    config/                      # lazy.lua, options.lua, keymaps.lua
    plugins/                     # One file per plugin (or small group)
```

---

## Languages

| Language | Location | Purpose |
|----------|----------|---------|
| Nix | `flake.nix`, `home/**/*.nix` | Package management, system config |
| Lua | `nvim/**/*.lua` | Neovim configuration |
| JSON | `*.json` | Lockfiles, prompt theme |
| Zsh/Shell | Inline strings in `*.nix` | Shell init, aliases, git hooks |
| TOML | Embedded in `darwin-aerospace.nix` | Window manager config |

---

## Build / Apply Commands

There is no Makefile, CI pipeline, or test runner. Correctness is validated by
applying the config and observing the result.

### Apply Home Manager configuration

```bash
# macOS machine
home-manager switch --flake .#phnl310118059@MACHXPVL4MXK7

# Linux machine
home-manager switch --flake .#jeroenknoops@sh101
```

### Check Nix syntax without applying

```bash
nix flake check
```

### Format Nix files

```bash
nixfmt flake.nix home/**/*.nix
```

### Neovim plugin management (inside Neovim)

```
:Lazy sync       # Install/update all plugins
:Lazy update     # Update plugins and update lazy-lock.json
:TSUpdate        # Rebuild Treesitter parsers after updates
:Mason           # Install/update LSP servers and formatters
```

### Running a single test

There are no automated tests in this repository.

---

## Code Style — Nix

### Formatting
- Use `nixfmt` (installed as `pkgs.nixfmt` in `home.nix`).
- Two-space indentation is the nixfmt default; do not override it.
- Each Home Manager module is a separate `.nix` file; keep them focused.

### Naming
- File names: `kebab-case.nix` when the name derives from a tool name
  (`darwin-aerospace.nix`, `oh-my-posh.nix`); `snake_case.nix` for generic
  modules (`sh101-home.nix`).
- Nix attribute names follow Home Manager's conventions: `camelCase`
  (`signByDefault`, `enableZshIntegration`, `allowUnfree`).
- Function parameters (module args): `camelCase` — `config`, `pkgs`, `lib`,
  `inputs`.
- Package references: match the nixpkgs attribute name exactly
  (`pkgs.yq-go`, `pkgs.any-nix-shell`, `pkgs.zsh-syntax-highlighting`).

### Module structure
Every module must follow the standard Home Manager module signature:

```nix
{ config, pkgs, lib, inputs, ... }:
{
  # attribute set of Home Manager options
}
```

Compose modules by listing file paths in the `modules` array inside `flake.nix`.
Do not use `imports` inside individual module files unless absolutely necessary.

### Inline content (shell scripts, TOML, JSON)
Multi-line string content embedded in Nix uses `''`-quoted strings (Nix
indented strings). Indent the content consistently with the surrounding Nix
code.

---

## Code Style — Lua (Neovim)

### Formatting
- Formatter: `stylua` (auto-run on save via `conform.nvim`).
- Indentation: **4 spaces**, no tabs (enforced by `nvim/.editorconfig`).
- No manual formatter config file (`stylua.toml`) — use stylua defaults.

### Naming
- **Local variables and functions**: `snake_case`
  (`local lazypath`, `local function client_supports_method`).
- **Augroup name strings**: `kebab-case`
  (`"kickstart-lsp-attach"`, `"YankHighlight"`).
- **Plugin spec files**: `kebab-case.lua` matching the plugin's repo name
  (`blink-cmp.lua`, `nvim-treesitter.lua`, `which-key.lua`).
- **Config modules**: `snake_case.lua` (`keymaps.lua`, `options.lua`, `lazy.lua`).

### Module / require patterns
- Entry point `init.lua` must only contain `require("config.lazy")`.
- Use dot-notation paths relative to `nvim/lua/`:
  ```lua
  require("config.options")
  require("config.keymaps")
  ```
- All plugin files live under `lua/plugins/` and are auto-loaded by lazy.nvim
  via `{ import = "plugins" }`. Each file returns one Lua table or a list of
  tables.
- Use parenthesised `require()` with double quotes consistently:
  ```lua
  -- correct
  require("nvim-treesitter.configs").setup(...)
  -- avoid (inconsistent style found in codebase — do not replicate)
  require'nvim-treesitter.configs'
  ```
- Inline `require()` calls inside callbacks are preferred for lazy-loading:
  ```lua
  keys = {
    { "<leader>ff", function() require("fzf-lua").files() end },
  }
  ```

### Error handling
- Use `vim.v.shell_error ~= 0` to check exit codes from `vim.fn.system()`.
- Surface errors via `vim.api.nvim_echo` with `"ErrorMsg"` / `"WarningMsg"`
  highlight groups, then `os.exit(1)` for fatal bootstrap failures.
- Nil-guard LSP client objects before use: `if client and client.method then`.
- Use `notify_on_error = true` in conform.nvim so formatting errors are visible.
- Avoid `pcall`/`xpcall` unless wrapping third-party code that may throw.

### Plugin spec conventions
- One plugin per file when the config is non-trivial; group tiny complementary
  plugins (e.g. UI micro-plugins) in a single file.
- Always specify `event`, `keys`, `ft`, or `cmd` to trigger lazy-loading where
  possible to keep startup time low.
- Keep `config` functions small; extract complex setup into a named local
  function above the spec table.

---

## Code Style — Shell / Zsh

- Shell snippets are embedded as Nix `''`-strings inside `zsh.nix` and
  `git.nix`. Keep them short and POSIX-compatible where possible.
- Git hook scripts use `&&`-chained commands and must be marked executable
  (`executable = true` in the `home.file` attribute).
- Aliases are defined as a Nix attribute set under
  `programs.zsh.shellAliases`; keep them alphabetically sorted.

---

## Git Workflow

- Commits on any repository on the machine trigger lolcommits (webcam capture)
  via a global `core.hooksPath`. This is expected behaviour — do not disable it.
- Do not edit `flake.lock` or `lazy-lock.json` by hand; use
  `nix flake update` / `:Lazy update` respectively.
- Commit messages have no enforced convention; short imperative sentences are
  conventional for this repo.

---

## Common Pitfalls

- `flake.lock` and `lazy-lock.json` are generated lockfiles. Always commit them
  after running `nix flake update` or `:Lazy update` so builds are reproducible.
- The machine-specific directory `home/MACHXPVL4MXK7/` is named after the
  macOS hostname; do not rename or refactor it without updating `flake.nix`.
- `nixfmt` is installed as a package but is not wired to any pre-commit hook.
  Run it manually before committing Nix changes.
- There is no `stylua.toml`; stylua runs with its built-in defaults. Do not add
  one unless you need to override a specific default.
