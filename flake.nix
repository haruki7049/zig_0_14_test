{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem = { pkgs, stdenv, lib, ... }:
        let
          zig = pkgs.zig_0_14;
          zig_0_14_test = pkgs.stdenv.mkDerivation {
            pname = "zig_0_14_test";
            version = "0.0.0";
            src = lib.cleanSource ./.;

            nativeBuildInputs = [
              zig.hook
            ];
          };
        in
        {
          packages = {
            inherit zig_0_14_test;
            default = zig_0_14_test;
          };

          devShells.default = pkgs.mkShell {
            nativeBuildInputs = [
              # Compiler
              zig

              # LSP
              pkgs.zls
            ];

            shellHook = ''
              export PS1="\n[nix-shell:\w]$ "
            '';
          };
        };
    };
}
