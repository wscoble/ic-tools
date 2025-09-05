{
  description = "A flake for the DFINITY SDK (dfx) with Apple Silicon support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
    version = "0.29.1";
    shas."x86_64-linux" = "0b72c0e73c8279946902a2a790359b9dbaea2088756ec9f83fa58f5ccbb3aac8";
    shas."x86_64-darwin" = "506a639206176395289e820245083b6eb227a5c394c903db89a08dcf64f8bb31";
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
