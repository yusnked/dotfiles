# https://github.com/bloc97/Anime4K

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "anime4k";
    version = "4.0.1";

    src = pkgs.fetchurl {
      name = "anime4k";
      url = "https://github.com/bloc97/Anime4K/releases/download/v4.0.1/Anime4K_v4.0.zip";
      sha256 = "sha256-E5zSgghkV8Wtx5yve3W4uCUJHXHJtUlYwYdF/qYtftc=";
    };

    dontUnpack = true;

    buildInputs = with pkgs; [ unzip ];

    installPhase = ''
      unzip ${src} -d anime4k
      mkdir -p $out/share/mpv/shaders
      cp anime4k/* $out/share/mpv/shaders
    '';
  }

