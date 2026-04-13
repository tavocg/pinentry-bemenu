{
  description = "bemenu wrapper for pinentry";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forAllSystems = f:
        nixpkgs.lib.genAttrs systems (system: f
          (import nixpkgs { inherit system; }));

    in {
      packages = forAllSystems (pkgs:
        let
          pinentry-bemenu = pkgs.stdenvNoCC.mkDerivation {
            pname = "pinentry-bemenu";
            version = "unstable";
            src = ./.;
            dontUnpack = true;
            nativeBuildInputs = [ pkgs.makeWrapper ];

            installPhase = ''
              install -Dm755 "$src/pinentry-bemenu" "$out/bin/pinentry-bemenu"
              wrapProgram "$out/bin/pinentry-bemenu" \
                --prefix PATH : "${pkgs.lib.makeBinPath [ pkgs.bemenu pkgs.libnotify ]}"
              ln -s "$out/bin/pinentry-bemenu" "$out/bin/pinentry"
            '';

            meta = {
              mainProgram = "pinentry-bemenu";
              platforms = pkgs.lib.platforms.linux;
            };
          };

        in {
          default = pinentry-bemenu;
          inherit pinentry-bemenu;
        });

      apps = forAllSystems (pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${pkgs.system}.default}/bin/pinentry-bemenu";
        };

        pinentry-bemenu = {
          type = "app";
          program = "${self.packages.${pkgs.system}.pinentry-bemenu}/bin/pinentry-bemenu";
        };
      });
  };
}
