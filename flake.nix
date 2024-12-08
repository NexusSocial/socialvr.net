{
  description = "NexusSocial/socialvr.net repo";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
  };

  outputs = inputs@{ flake-utils, ... }:
    let
      # All systems we may care about evaluating nixpkgs for
      systems = with flake-utils.lib.system; [ x86_64-linux aarch64-linux aarch64-darwin x86_64-darwin ];
      perSystem = (system: rec {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            # ((import nix/overlays/nixpkgs-unstable.nix) { inherit inputs; })
          ];
          config = {
            # allowUnfree = true;
          };
        };
      });
      # This `s` helper variable caches each system we care about in one spot
      inherit (flake-utils.lib.eachSystem systems (system: { s = perSystem system; })) s;
    in
    # System-specific stuff goes in here, by using the flake-utils helper functions
    flake-utils.lib.eachSystem systems
      (system:
        let
          inherit (s.${system}) pkgs inputs;
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              just
              nixpkgs-fmt
              simple-http-server
              prettier
            ];
          };
          formatter = pkgs.nixpkgs-fmt;
        }
      );
}
