{
  description = "Digital Ocean CLI (doctl) package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "doctl";
          version = "1.115.0";

          src = pkgs.fetchurl {
            url = "https://github.com/digitalocean/doctl/releases/download/v${version}/doctl-${version}-linux-amd64.tar.gz";
            hash = "sha256-L0UENpjbsouOJ8ITqxmZpFchDUkgJlDT8hFoZC4EibU=";
          };

          nativeBuildInputs = [ pkgs.autoPatchelfHook ];
          buildInputs = [ pkgs.stdenv.cc.cc.lib ];

          unpackPhase = ''
            tar xf $src
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp doctl $out/bin/
            chmod +x $out/bin/doctl
          '';

          meta = with pkgs.lib; {
            description = "The official command line interface for the DigitalOcean API";
            homepage = "https://github.com/digitalocean/doctl";
            license = licenses.asl20;
            platforms = platforms.linux;
          };
        };
      }
    );
}
