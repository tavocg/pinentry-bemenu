{
  description = "anypinentry shell scripts";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f
          (import nixpkgs { inherit system; }));

    in {
      packages = forAllSystems (pkgs:
        let
          anypinentry = pkgs.stdenvNoCC.mkDerivation {
          pname = "anypinentry";
          version = "unstable";
          src = ./.;
          dontUnpack = true;

          installPhase = ''
            install -Dm755 "$src/anypinentry" "$out/bin/anypinentry"
            install -Dm755 "$src/menu" "$out/bin/menu"
            ln -s "$out/bin/anypinentry" "$out/bin/pinentry"
          '';

          meta.mainProgram = "anypinentry";
        };

        in {
        default = anypinentry;
        inherit anypinentry;
      });

      apps = forAllSystems (pkgs: {
        default = {
        type = "app";
        program = "${self.packages.${pkgs.system}.default}/bin/anypinentry";
      };

      anypinentry = {
        type = "app";
        program = "${self.packages.${pkgs.system}.anypinentry}/bin/anypinentry";
      };

      menu = {
        type = "app";
        program = "${self.packages.${pkgs.system}.anypinentry}/bin/menu";
      };
    });
  };
}
