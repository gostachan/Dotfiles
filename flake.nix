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
    let
      nonRootUser = value: value != "" && value != "root";
      sudoUser = builtins.getEnv "SUDO_USER";
      user = builtins.getEnv "USER";
      logname = builtins.getEnv "LOGNAME";
      primaryUser =
        if nonRootUser sudoUser then sudoUser
        else if nonRootUser user then user
        else if nonRootUser logname then logname
        else throw "Could not determine the current non-root user. Use .bin/bootstrap.sh or run darwin-rebuild from the target user with --impure.";

      mkDarwinConfiguration = system: nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit primaryUser;
        };
        modules = [
          ./nix/darwin.nix
        ];
    };
    in
    {
      darwinConfigurations.default = mkDarwinConfiguration "aarch64-darwin";

      darwinPackages = self.darwinConfigurations.default.pkgs;
    };
}
