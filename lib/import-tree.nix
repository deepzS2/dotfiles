lib: dir: let
  rel = p: lib.removePrefix (toString dir) (toString p);
  isModule = p: let r = rel p; in lib.hasSuffix ".nix" r && !lib.hasInfix "/_" r;
in
  map import (lib.filter isModule (lib.filesystem.listFilesRecursive dir))
