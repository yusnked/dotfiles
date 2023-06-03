# https://github.com/oguna/rustmigemo

{ pkgs, ... }:
  pkgs.stdenv.mkDerivation rec {
    pname = "rustmigemo";
    version = "0.1.2";

    src = pkgs.fetchFromGitHub {
      owner = "oguna";
      repo = pname;
      rev = "v0.1.2";
      sha256 = "sha256-2qyfLOrKs3Gw4KchcNvAOYpHmJyXEfJOeUQE3kpOYTE=";
    };

    buildInputs = with pkgs; [ rustc cargo ];

    buildPhase = ''
      export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      cargo build --release
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp target/release/rustmigemo $out/bin
    '';
  }

