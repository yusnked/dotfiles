# https://github.com/romkatv/zsh-defer

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "zsh-defer";
    version = "2022-06-13";

    src = pkgs.fetchFromGitHub {
      owner = "romkatv";
      repo = pname;
      rev = "57a6650ff262f577278275ddf11139673e01e471";
      sha256 = "1dvh0w5yg5dvki1h3d5bc1rp9pmn0zwjrv3qv2q22kqvc15hidzy";
    };

    installPhase = ''
      mkdir -p $out/share/zsh-defer
      cp zsh-defer zsh-defer.plugin.zsh $out/share/zsh-defer
    '';
  }

