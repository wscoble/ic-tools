{
  description = "A flake for the DFINITY SDK (dfx) with Apple Silicon support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: let
    version = "0.29.2";
    shas."x86_64-linux" = "d1473ae15ece44e782f0f2f8ac586ead349fe434189df8b587eb738becce0138";
    shas."x86_64-darwin" = "be1079c5f48e4bb88c2421f65b501040250a13a4ea57c6ccc1d3edf17812f674";
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
