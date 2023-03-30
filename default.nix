{ sources ? import ./nix/sources.nix
} :
let
  niv = import sources.nixpkgs {
    overlays = [
      (_ : _ : { niv = import sources.niv {}; })
    ] ;
    config = {};
  };
  pkgs = niv.pkgs;
  src = pkgs.lib.cleanSourceWith {
    filter = name: type: !(pkgs.lib.hasSuffix ".cabal" name);
    src = ./.;
  };
  myHaskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: rec {
        discord-haskell  = self.callCabal2nix "discord-haskell" (builtins.fetchTarball {
          url = "https://hackage.haskell.org/package/discord-haskell-1.12.5/discord-haskell-1.12.5.tar.gz";
        }) {};
      };
    };
in
myHaskellPackages.callCabal2nix "HaskellNixCabalStarter" (src) {}
