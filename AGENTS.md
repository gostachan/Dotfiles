# Agent Instructions

This file is shared by Codex and Claude Code. `CLAUDE.md` is a symlink to this file, so update this file when changing agent-facing project knowledge.

## Repository

- This repository manages personal dotfiles.
- Keep edits scoped to files in this repository unless explicitly asked otherwise.
- Do not rewrite generated runtime state unless the task is specifically about that state.
- Be careful with shell startup files because they affect login shells, interactive shells, and Nix devShell behavior.

## Package Management

- Prefer Nix for CLI tools, development tools, and libraries.
- Use `nix-darwin` for macOS system-level configuration.
- Use `home-manager` for user-level configuration.
- Avoid adding new Homebrew formula dependencies.
- If Homebrew remains necessary, keep it limited to casks for macOS GUI apps or binary apps that are not practical to manage with Nix.
- Tools that are difficult to manage practically with Nix may be declared as Homebrew casks through `nix-darwin`.

## Nix And PATH

- Nix devShell paths should stay ahead of system paths.
- Watch for shell initialization code that rebuilds `PATH`, especially `mise`, `path_helper`, and Homebrew shell setup.
- In Nix shells, avoid changing `PATH` in a way that moves `/nix/store/.../bin` behind `/usr/bin` or `/opt/homebrew/bin`.

## Editing Notes

- This repo uses a whitelist-style `.gitignore`; add new tracked root files explicitly.
- Do not remove unrelated user changes from the working tree.
- Keep documentation concise and actionable.
