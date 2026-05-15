{inputs, ...}: {
  flake.modules.homeManager.ai = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi];

    # I decided to make an activation for this since I will (probably) keep
    # improving my workflow as I keep using it.
    # This setup makes more sense than leaving it in `/nix/store`.
    home.activation.mini-pi = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "$HOME/.pi/agent/.git" ]; then
        ${pkgs.git}/bin/git clone https://codeberg.org/deepzS2/mini.pi "$HOME/.pi/agent"
        ${pkgs.bun}/bin/bun install --cwd="$HOME/.pi/agent"
      fi
    '';
  };
}
