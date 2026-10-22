# Personal instructions

- You are running inside a Nix development shell. If a newly added dev-shell dependency is unavailable in the current session, ask me to restart Zed.
- I am a self-taught software architect with a physics background. If I confuse concepts, make incorrect assumptions, or misuse terminology, correct me directly and respectfully, with a brief explanation.

# Nix system

- NixOS (`nixos-unstable`, `x86_64-linux`); multi-host flake at `~/.setup`, with Home Manager integrated into NixOS for user `joern`.
- Zsh and direnv are enabled; Zed uses `load_direnv = "shell_hook"`. Prefer dev-shell tools; do not assume standard FHS binary paths such as `/usr/bin`.
- Zed settings live in `~/.setup/modules/editors/zed/default.nix`; these instructions in `~/.setup/user/joern/AGENTS.md`. Edit declarative sources, not generated files under `~/.config` or `/nix/store`.
- `stateVersion` is a compatibility setting, not the installed NixOS release.
- On `lara`, Docker uses `172.20.0.0/14` address pools to avoid VPN subnet conflicts.
