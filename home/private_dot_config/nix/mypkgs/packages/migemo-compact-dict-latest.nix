# https://github.com/oguna/migemo-compact-dict-latest

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "migemo-compact-dict-latest";
    version = "0.2";

    src = pkgs.fetchurl {
      name = "migemo-compact-dict";
      url = "https://github.com/oguna/migemo-dict-latest/releases/download/v2021-05-07/migemo-dict.zip";
      sha256 = "sha256-9AEAgRTHgznPvuew/kkGdSl58ownA225gPyARLiJl9Q=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/migemo-compact-dict
      cp ${src} $out/share/migemo-compact-dict/migemo-compact-dict
    '';
  }

