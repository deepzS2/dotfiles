{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules inputs.devshell.flakeModule];
}
