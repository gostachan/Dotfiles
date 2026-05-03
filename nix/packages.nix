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
    claude-code
    ipcalc
    marp-cli
    neovim
    podman
    terraform
    tmux
    tree-sitter
  ];
in
languages ++ languageServers ++ cliTools
