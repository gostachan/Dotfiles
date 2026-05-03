# dotfiles

個人環境の設定を管理するリポジトリです。

## パッケージ管理方針

基本方針は **Nix を本体、Homebrew は使うとしても cask のみに限定** です。

### 役割分担

- CLI ツール、開発ツール、ライブラリは Nix で管理する
- macOS のシステム設定は `nix-darwin` で管理する
- ユーザー単位の設定は `home-manager` で管理する
- GUI アプリや `.app` 形式の配布物だけ、必要に応じて Homebrew cask に残す

### Nix で管理したいもの

Homebrew formula として入れていたものは、原則 Nix package に移す。

例:

- `git`
- `neovim`
- `ripgrep`
- `tmux`
- `go`
- `nodejs`
- `pnpm`
- `terraform`
- `podman`
- `tree-sitter`

これらは `nix-darwin` の `environment.systemPackages`、または `home-manager` の `home.packages` に寄せる。

### Homebrew に残す可能性があるもの

Homebrew を残す場合でも、対象は cask のみに絞る。

ただし、可能ならこれらも Nix package や別の運用に置き換える。Nix で実用的に管理しにくいツールだけ、Homebrew cask で管理する。

この場合でも Homebrew は cask 用の補助として使うだけで、CLI ツールやライブラリは Nix 側に寄せる。

## nix-darwin の位置づけ

`nix-darwin` は macOS のシステム設定を Nix で宣言管理するための仕組みです。

管理対象の例:

- システム全体のパッケージ
- shell の有効化
- macOS defaults
- `/etc` 周辺の設定
- 必要な場合の Homebrew 連携

Homebrew 連携を使う場合でも、それは「Nix で Homebrew を置き換える」ことではなく、「Nix の設定から Homebrew の状態を操作する」ことです。

## Homebrew を cask だけに絞る理由

CLI ツールは Nix で管理した方が再現性が高い。一方で、macOS の GUI アプリは Nix だけで扱うと次の問題が出やすい。

- `.app` の配置や Launch Services 連携が面倒
- 自動更新、署名、権限まわりで Homebrew cask の方が楽な場合がある
- Nixpkgs に存在しないアプリがある
- GUI アプリは Homebrew の方が更新が早い場合がある

そのため、完全に Homebrew を消せるなら消す。難しい場合は、Homebrew を GUI アプリ用の補助としてだけ使う。

## 移行手順

1. 現在の Homebrew formula を棚卸しする
2. Nixpkgs にある CLI ツールを Nix 側へ移す
3. shell の `PATH` から `/opt/homebrew/bin` 前提の設定を減らす
4. cask が本当に必要なものだけ残す
5. Homebrew formula が空に近づいたら、Homebrew 自体を残すか削除するか判断する

## 注意点

Homebrew cask は内部依存として formula を入れることがある。そのため、`brews = []` にしても `/opt/homebrew/Cellar` が完全に空になるとは限らない。

また、`mise` や shell 初期化で `PATH` を組み直すと、Nix devShell の `/nix/store/.../bin` が後ろに回ることがある。Nix shell 内では Nix が用意した PATH を優先する。

## AI エージェント向けの知識

Codex と Claude Code に残したい編集方針は `AGENTS.md` に書く。`CLAUDE.md` は `AGENTS.md` へのシンボリックリンクにする。

これにより、今後は `AGENTS.md` だけを編集すれば Codex と Claude Code の両方で同じ知識を使える。
