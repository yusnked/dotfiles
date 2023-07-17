# https://github.com/Amar1729/yabai-zsh-completions

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "yabai-zsh-completions";
    version = "2023-05-02";

    src = pkgs.fetchFromGitHub {
      owner = "Amar1729";
      repo = pname;
      rev = "881878d0f6a50429af55b33532f9ec7139e1f208";
      sha256 = "1afciv4vixsb00v6l1fwsy1hjgxlcc884a0swp3pxjzm2wz4yzpy";
    };

    installPhase = ''
      mkdir -p $out/share/zsh/site-functions
      cp src/_yabai $out/share/zsh/site-functions/_yabai
    '';
  }

