{
  description = "Kata boostraper that relies on pinage404-nix-sandboxes";

  # broken on Fish
  # as a workaround, use `nix develop` the first time
  # https://github.com/direnv/direnv/issues/1022
  # nixConfig.extra-substituters = [
  #   "https://pinage404-nix-sandboxes.cachix.org"
  # ];
  # nixConfig.extra-trusted-public-keys = [
  #   "pinage404-nix-sandboxes.cachix.org-1:5zGRK2Ou+C27E7AdlYo/s4pow/w39afir+KRz9iWsZA="
  # ];

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";
      in
      {
        devShells.default = pkgs.mkShellNoCC {
          packages = with pkgs; [
            jq
            mask
            shellcheck
            shfmt
            shunit2
            watchexec
          ];
        };
        packages.bootstrap-kata = 
          pkgs.stdenv.mkDerivation {
            name = "bootstrap-kata";
            src = self;
            dontBuild = true;
            installPhase = ''
              mkdir -p $out/bin; mv ./src/* $out/bin/
              mv $out/bin/main.sh $out/bin/bootstrap-kata
            '';
            buildInputs= with pkgs; [
              bashInteractive
              jq
            ];
          };
        defaultPackage = self.packages.${system}.bootstrap-kata;
        
        apps.bootstrap-kata = {
          type = "app";
          program = "${self.packages.${system}.bootstrap-kata}/bin/bootstrap-kata";
        };

        defaultApp = self.apps.${system}.bootstrap-kata;
      }
    );
}

