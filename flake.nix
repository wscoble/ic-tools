{
  description = "A flake for the DFINITY SDK (dfx) with Apple Silicon support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
    version = "0.24.0";
    shas."x86_64-linux" = "876015b7044e35aed6f317937703aaf93c74a36e55f618ad121ce9810d10b4ec";
    shas."x86_64-darwin" = "5a8370afe6fe632dfc05b27e39cf6ab0a392c198f26dbcc0068b9ecadb70864d";
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
