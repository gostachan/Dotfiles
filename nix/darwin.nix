{ lib, pkgs, ... }:

{
  nix.enable = false;

  nixpkgs.config = import ./nixpkgs-config.nix { inherit lib; };
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = import ./packages.nix { inherit pkgs; };

  system.primaryUser = "user";
  system.stateVersion = 6;

  services.karabiner-elements = {
    enable = true;
    package = pkgs.karabiner-elements;
  };
}
