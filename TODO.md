# NixOS Setup — Improvement TODO

## 🟢 Modernization

- [ ] **Adopt `flake-parts`** — reduces boilerplate for multi-system support
- [ ] **Add `formatter` output in flake** — add `formatter.x86_64-linux = pkgs.nixfmt;` to enable `nix fmt`
- [ ] **Add `devShells` output** — add a dev shell providing `sops`, `age`, `nixfmt`, `statix`, `deadnix` so contributors can `nix develop`
- [ ] **Add Nix linting via `git-hooks.nix`** — Nix-native pre-commit hook management from cachix (`statix`, `deadnix`, `nixfmt`)
- [ ] **Create host profiles** — `profiles/desktop.nix`, `profiles/laptop.nix`, `profiles/server.nix` to compose hosts cleanly
- [ ] **Migrate `boot.initrd.secrets`** — deprecated in `tara` and `lara`. Move to `boot.initrd.systemd`-based approach
- [ ] **Rework home-manager import pattern** — `(import ../user/${user} { ... imports ... })` passes `imports` as an argument. Use the standard home-manager module system with `imports` directly
- [ ] **Split user packages into logical modules** — `user/joern/default.nix` mixes fonts, terminal tools, dev tools, and GUI apps. Create `fonts.nix`, `dev-tools.nix`, `gui-apps.nix`

## 🔴 Critical Bugs

- [ ] **Wrong hostname in `hosts/tara/default.nix`** — `networking.hostName = "elenia"` should be `"tara"`
- [ ] **Wrong hostname in `hosts/deepspace9/default.nix`** — `networking.hostName = "vbox"` should be `"deepspace9"`
- [ ] **`deepspace9` and `vbox` are nearly identical** — `deepspace9/default.nix` appears to be a copy-paste of `vbox` that was never customized

## 🟠 Hardcoded Values

- [ ] **UID 1000 hardcoded in sops paths** — `modules/sops/default.nix` and `shell/zsh.nix` use `/run/user/1000/secrets`. Use `config.sops.defaultSymlinkPath` or derive from user config instead
- [ ] **Hostname defined in two places** — each host file hardcodes `networking.hostName`, but it's also passed via `mkHost`. Derive it from `specialArgs` (`networking.hostName = host.hostName;`) to prevent drift
- [ ] **Hardcoded `system = "x86_64-linux"`** — no support for other architectures. Parameterize per-host if needed
- [ ] **Repeated IP in `lara/default.nix`** — `10.179.101.54` appears 3 times; extract to a `let` binding

## 🟠 Code Duplication

- [ ] **Git configs are nearly identical** — `git_gmail.nix`, `git_gmail_nitrokey.nix`, `git_tocadero.nix` repeat most content. Create a shared `git/common.nix` and compose variants with parameters (email, signing key)
- [ ] **Zed extensions listed twice** — once in `extensions` and again in `auto_install_extensions`. Define the list once in a `let` binding, or remove `auto_install_extensions` since `extensions` already handles it
- [ ] **Desktop hosts share the same imports** — `elenia`, `lara`, `tara`, `vbox` all import `os/default.nix` + `pipewire` + `ssh` + `gnome`. Extract into a `profiles/desktop.nix`
- [ ] **`inherit user; inherit stateVersion;` repeated in every `mkHost` call** — default these inside `mkHost`
- [ ] **`networking.networkmanager.enable = true` in every host** — move to the shared `os/default.nix`

## 🟠 Structural Issues

- [ ] **`lib` is shadowed** in `hosts/default.nix` — the function argument `lib` is overwritten by `let lib = nixpkgs.lib;`. Remove one
- [ ] **`pkgs` instantiated but barely used** in `hosts/default.nix` — creates a second `pkgs` set that may diverge from the system's. Pass `pkgs` from the NixOS system evaluation instead
- [ ] **Duplicate nixpkgs in flake.lock** — `nixos-wsl` pulls its own nixpkgs. Add `nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";` to deduplicate
- [ ] **`location = "$HOME/.setup"` won't expand** — it's a Nix string literal, not a shell expression. If used at eval time it's a bug

## 🟡 Dead Code & Cleanup

- [ ] **Nitrokey module is empty** — `modules/nitrokey/default.nix` has all packages commented out but is still imported by `tara`
- [ ] **Boilerplate NixOS comments in host files** — the default `# Edit this configuration file...` comments add no value in a flake setup
- [ ] **Commented-out networking options** — `networking.wireless`, `networking.proxy.*` blocks in 4 host files. Remove
- [ ] **Unused function parameters** — `config` and `pkgs` are destructured but unused in several host files
- [ ] **`busybox` in user packages** — can shadow NixOS system utilities due to its multi-call binary nature
- [ ] **Expand `.gitignore`** — missing `.direnv/`, `*.swp`, `*.swo`, editor temp files
