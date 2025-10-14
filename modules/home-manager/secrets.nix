{config, ...}: {
  age = {
    identityPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    secrets = {
      gemini_key.file = ../../secrets/gemini_key.age;
    };
  };
}
