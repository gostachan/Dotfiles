{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nix-darwin, nixpkgs }:
    {
      darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/darwin.nix
        ];
      };

      darwinPackages = self.darwinConfigurations."default".pkgs;
    };
}
