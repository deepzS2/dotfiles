# Secrets management configuration module for Home Manager
# Exported as flake.modules.homeManager.secrets
{
  flake.modules.homeManager.secrets = {config, ...}: {
    age = {
      identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
      secrets = {
        gemini_key.file = ../../secrets/gemini_key.age;
      };
    };
  };
}
