{ pkgs }:

with pkgs;

let
  languages = [
    go
    nodejs
    pnpm
  ];

  languageServers = [
    clang-tools
    gopls
    pyright
    sqls
    terraform-ls
  ];

  cliTools = [
    buf
    codex
    claude-code
    ipcalc
    marp-cli
    neovim
    podman
    ripgrep
    terraform
    tmux
    tree-sitter
    uv
    zsh
  ];
in
languages ++ languageServers ++ cliTools
