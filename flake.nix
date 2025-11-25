{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            ruby
            libffi
            gnumake
          ];

          shellHook = ''
            # Set up Ruby gem environment to use local vendor directory
            export GEM_HOME="$(pwd)/vendor/bundle"
            export GEM_PATH="$GEM_HOME:${pkgs.ruby}/lib/ruby/gems/3.3.0"
            export PATH="$GEM_HOME/bin:$PATH"

            echo "🚀 Development environment loaded!"
            echo "📦 Ruby: $(ruby --version)"
            echo "📦 Node: $(node --version)"
            echo "💎 Gems: $GEM_HOME"
            echo ""
            echo "💡 Run 'bundle install' if gems are missing"
            echo "💡 Run 'npm install' if node_modules are missing"
            echo "💡 Run 'make dev' to start Jekyll server"
          '';
        };
      }
    );
}
