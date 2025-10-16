{
  flake.modules.homeManager.elixir = {pkgs, ...}: {
    home.packages = with pkgs; [
      elixir
      erlang
    ];
  };
}
