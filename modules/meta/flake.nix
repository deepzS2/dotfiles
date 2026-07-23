{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules inputs.devshell.flakeModule];

  debug = true;

  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
  };
}
