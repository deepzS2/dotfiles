{ lib, config, pkgs, ... }:
  let 
    mkLang = name: defaultPkg: {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable ${name}";
      };
      package = lib.mkOption {
        type = lib.types.package;
        default = defaultPkg;
        description = "Package to install for ${name}";
      };
    };
  in {
    options.programming-languages = {
      node    = mkLang "Node.js"      pkgs.nodejs;
      deno    = mkLang "Deno"         pkgs.deno;
      bun     = mkLang "Bun"          pkgs.bun;
      rust    = mkLang "Rust"         pkgs.rust;
      elixir  = mkLang "Elixir"       pkgs.elixir;
    };

    config = let
      langs = lib.filterAttrs (_: v: v.enable) config.programming-languages;
      pkgsToAdd = lib.concatMap (_: l: [ l.package ]) (lib.attrValues langs);
    in {
      home.packages = pkgsToAdd;
    };
  }