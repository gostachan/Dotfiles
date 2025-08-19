#!/usr/bin/env bash
set -euo pipefail

WORK_DIR="$(mktemp -d)"
BIN_BUILD="$HOME/dotfiles/.bin.build"
MASON_BIN="$HOME/.local/share/nvim/mason/bin"

mkdir -p "$BIN_BUILD" "$MASON_BIN"

echo "[laravel-ls] cloning..."
git clone --depth=1 https://github.com/laravel-ls/laravel-ls.git "$WORK_DIR"

echo "[laravel-ls] building..."
cd "$WORK_DIR"
go build -o "$BIN_BUILD/laravel-ls" ./cmd/laravel-ls

echo "[laravel-ls] linking into mason/bin..."
ln -sf "$BIN_BUILD/laravel-ls" "$MASON_BIN/laravel-ls"

echo "[laravel-ls] cleaning up..."
rm -rf "$WORK_DIR"

echo "[laravel-ls] done!"

