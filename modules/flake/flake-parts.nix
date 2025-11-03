{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules inputs.home-manager.flakeModules.home-manager inputs.devshell.flakeModule];

  debug = true;
}
