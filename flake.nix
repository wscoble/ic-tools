{
  description = "A flake for the DFINITY SDK (dfx) with Apple Silicon support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let

    version = "0.18.0";
    shas."x86_64-linux" = "117a9c6a9b39e01e7363d5c8021bbfb007fb48be1448efa993329eec0fce7f09";
    shas."x86_64-darwin" = "d13deffe47dfd4a190424c0cb963447cf787edd05818c312df77ac2f9b8d24d7";

  in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        dfx-bin = pkgs.stdenv.mkDerivation {
          name = "dfx-${version}";
          src = pkgs.fetchurl {
            url = "https://github.com/dfinity/sdk/releases/download/${version}/dfx-${version}-${system}.tar.gz";
            sha256 = shas."${system}";
          };
          buildInputs = [ pkgs.makeWrapper ];
          unpackPhase = ''
            tar -zxf $src
          '';
          installPhase = ''
            mkdir -p $out/bin
            tar -zxf $src -C $out/bin
            
            # Rename the dfx binary to dfx-wrapped
            mv $out/bin/dfx $out/bin/dfx-wrapped
            
            # Install the wrapper script as dfx
            cp ${./dfx-wrapper.sh} $out/bin/dfx
            chmod +x $out/bin/dfx
            
            # Use makeWrapper to adjust the wrapper, ensuring it calls dfx-wrapped
            # wrapProgram $out/bin/dfx --add-flags "$out/bin/dfx-wrapped"
          '';
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ dfx-bin ];
        };
        defaultPackage = dfx-bin;
      });
}
