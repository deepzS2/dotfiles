let
  deepz = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQFTKMjuQ+sqMzWEfemY3I7es715gvvgpe5zKZvYx2U";
  users = [deepz];
in {
  "gemini_key.age".publicKeys = users;
}
