{ pkgs, lib, config, inputs, ... }:
  let 
    cfg = config.editor.nvim;
    utils = inputs.nixCats.utils;
  in {
    options = {
      editor.nvim.enable = lib.mkEnableOption "Neovim";
    };

    config = lib.mkIf cfg.enable {
      nixCats = {
        enable = true;

        addOverlays = /* (import ./overlays inputs) ++ */ [
          (utils.standardPluginOverlay inputs)
        ];

        packageNames = [ "nvim" ];

        luaPath = ../../../config/nvim;

        categoryDefinitions.replace = ({ pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {
          # to define and use a new category, simply add a new list to a set here,
          # and later, you will include categoryname = true; in the set you
          # provide when you build the package using this builder function.
          # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

          # lspsAndRuntimeDeps:
          # this section is for dependencies that should be available
          # at RUN TIME for plugins. Will be available to PATH within neovim terminal
          # this includes LSPs
          lspsAndRuntimeDeps = with pkgs; {
            general = [
              universal-ctags
              ripgrep
              fd
              stdenv.cc.cc
              nix-doc
              lua-language-server
              nixd
              stylua
              lazygit
              dwt1-shell-color-scripts
              tailwindcss-language-server
              docker-ls
              taplo
              docker-compose-language-service
              astro-language-server
              elixir-ls
              bash-language-server
              htmx-lsp2
              biome
              vtsls
              jsonnet-language-server
              prettierd
              shellcheck
              shfmt
              hadolint
              alejandra
            ];
            debugging = [
              delve
            ];
            linting = [
              markdownlint-cli
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = with pkgs.vimPlugins; {
            general = [
              lazy-nvim
              comment-nvim
              luasnip
              blink-cmp
              blink-cmp-avante
              bufferline-nvim
              cloak-nvim
              avante-nvim
              conform-nvim
              crates-nvim
              dressing-nvim
              fidget-nvim
              flutter-tools-nvim
              friendly-snippets
              gitsigns-nvim
              go-nvim
              grapple-nvim
              incline-nvim
              kanagawa-nvim
              lazydev-nvim
              mason-lspconfig-nvim
              mason-nvim-dap-nvim
              mason-tool-installer-nvim
              mason-nvim
              mini-nvim
              noice-nvim
              nui-nvim
              nvim-colorizer-lua
              nvim-lint
              nvim-lspconfig
              tmux-navigator
              nvim-treesitter
              nvim-treesitter-textobjects
              nvim-ts-autotag
              persistence-nvim
              plenary-nvim
              rustaceanvim
              snacks-nvim
              tailwind-tools-nvim
              todo-comments-nvim
              trouble-nvim
              undotree
              vim-sleuth
              which-key-nvim

              nvim-treesitter.withAllGrammars
              # This is for if you only want some of the grammars
              # (nvim-treesitter.withPlugins (
              #   plugins: with plugins; [
              #     nix
              #     lua
              #   ]
              # ))
            ];
            debugging = [
              nvim-dap
              nvim-dap-ui
              nvim-nio
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          # NOTE: this template is using lazy.nvim so, which list you put them in is irrelevant.
          # startupPlugins or optionalPlugins, it doesnt matter, lazy.nvim does the loading.
          # I just put them all in startupPlugins. I could have put them all in here instead.
          optionalPlugins = {};

          # shared libraries to be added to LD_LIBRARY_PATH
          # variable available to nvim runtime
          sharedLibraries = {
            general = with pkgs; [ 
              # libgit2
            ];
          };


          # environmentVariables:
          # this section is for environmentVariables that should be available
          # at RUN TIME for plugins. Will be available to path within neovim terminal
          environmentVariables = {
            test = {
              CATTESTVAR = "It worked!";
            };
          };

          # If you know what these are, you can provide custom ones by category here.
          # If you dont, check this link out:
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
          extraWrapperArgs = {
            test = [
              '' --set CATTESTVAR2 "It worked again!"''
            ];
          };

          # lists of the functions you would have passed to
          # python.withPackages or lua.withPackages
          # do not forget to set `hosts.python3.enable` in package settings

          # get the path to this python environment
          # in your lua config via
          # vim.g.python3_host_prog
          # or run from nvim terminal via :!<packagename>-python3
          python3.libraries = {
            test = (_:[]);
          };
          # populates $LUA_PATH and $LUA_CPATH
          extraLuaPackages = {
            test = [ (_:[]) ];
          };
        });

        # see :help nixCats.flake.outputs.packageDefinitions
        packageDefinitions.replace = {
          # These are the names of your packages
          # you can include as many as you wish.
          nvim = {pkgs, name, ... }: {
            # they contain a settings set defined above
            # see :help nixCats.flake.outputs.settings
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
              # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
              hosts.python3.enable = true;
              hosts.node.enable = true;
            };
            # and a set of categories that you want
            # (and other information to pass to lua)
            # and a set of categories that you want
            categories = {
              general = true;
              gitPlugins = true;
              customPlugins = true;
              test = true;

              debugging = true;
              linting = true;

              # this kickstart extra didnt require any extra plugins
              # so it doesnt have a category above.
              # but we can still send the info from nix to lua that we want it!
              kickstart-gitsigns = true;

              # we can pass whatever we want actually.
              have_nerd_font = false;

              example = {
                youCan = "add more than just booleans";
                toThisSet = [
                  "and the contents of this categories set"
                  "will be accessible to your lua with"
                  "nixCats('path.to.value')"
                  "see :help nixCats"
                  "and type :NixCats to see the categories set in nvim"
                ];
              };
            };
            # anything else to pass and grab in lua with `nixCats.extra`
            extra = {
              nixdExtras.nixpkgs = ''import ${pkgs.path} {}'';
            };
          };
        };
      };
    };
  }