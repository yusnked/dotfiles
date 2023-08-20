# https://github.com/bjin/mpv-prescalers

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "mpv-prescalers";
    version = "2023-08-18";

    src = pkgs.fetchFromGitHub {
      owner = "bjin";
      repo = pname;
      rev = "f549d351d6bca0bdea56b8e24a6c03c0553f1139";
      sha256 = "0847k4wk74brmk9aczms1skfi56w7w6jjqimdlmnf16971gkjcfp";
    };

    installPhase = ''
      mkdir -p $out/share/mpv/shaders
      cp ravu* nnedi3* $out/share/mpv/shaders
    '';
  }

