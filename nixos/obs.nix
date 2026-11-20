{pkgs, ...}: {
  environment.systemPackages = [pkgs.qpwgraph];

  programs.obs-studio = {
    enable = true;

    plugins = builtins.attrValues {
      inherit (pkgs.obs-studio-plugins) obs-pipewire-audio-capture obs-vkcapture;
    };
  };
}
