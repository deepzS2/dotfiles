{
  flake.modules.homeManager.rust = {pkgs, ...}: {
    home.packages = with pkgs; [
      rustc
      cargo
      bacon
      cargo-edit
      cargo-expand
      cargo-udeps
      cargo-watch
    ];
  };
}
