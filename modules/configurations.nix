{self, ...}: {
  flake.nixosConfigurations = {
    tojo = self.lib.mkNixos "x86_64-linux" "tojo";
    omi = self.lib.mkNixos "x86_64-linux" "omi";
  };
}
