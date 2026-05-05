{ lib, pkgs, ... }:

{
  nix.enable = false;

  nixpkgs.config = import ./nixpkgs-config.nix { inherit lib; };
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages =
    (import ./packages.nix { inherit pkgs; })
    ++ [
      pkgs.karabiner-elements
    ];

  programs.zsh.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];

  homebrew = {
    enable = true;
    casks = [
      "keyboardcleantool"
    ];
  };

  system.primaryUser = "user";
  system.stateVersion = 6;

}
