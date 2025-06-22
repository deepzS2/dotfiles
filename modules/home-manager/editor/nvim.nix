{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.editor.nvim;
  utils = inputs.nixCats.utils;
in {
  options = {
    editor.nvim.enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.vectorcode # Code repository indexing tool
    ];

    nixCats = {
      enable = true;

      addOverlays =
        /*
        (import ./overlays inputs) ++
        */
        [
          (utils.standardPluginOverlay inputs)
        ];

      packageNames = ["nvim" "testnvim"];

      luaPath = ../../../config/nvim;

      categoryDefinitions.replace = {pkgs, ...}: {
        # to define and use a new category, simply add a new list to a set here,
        # and later, you will include categoryname = true; in the set you
        # provide when you build the package using this builder function.
        # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

        # lspsAndRuntimeDeps:
        # this section is for dependencies that should be available
        # at RUN TIME for plugins. Will be available to PATH within neovim terminal
        lspsAndRuntimeDeps = with pkgs; {
          # Core utilities used for various editor functions
          core = [
            universal-ctags
            ripgrep
            fd
            stdenv.cc.cc
          ];

          # Git-related tools
          git = [
            lazygit
          ];

          # Documentation tools
          docs = [
            nix-doc
          ];

          # Language servers for different languages
          languageServers = [
            # System languages
            lua-language-server
            nixd
            bash-language-server

            # Web development
            tailwindcss-language-server
            htmx-lsp2
            astro-language-server
            vtsls # TypeScript

            # Container/configuration languages
            docker-ls
            docker-compose-language-service
            jsonnet-language-server
            taplo # TOML

            # Other languages
            elixir-ls
          ];

          # Code formatting tools
          formatters = [
            stylua # Lua
            prettierd # Web
            shfmt # Shell
            alejandra # Nix
            biome # JavaScript/TypeScript
          ];

          # Visual enhancements
          visual = [
            dwt1-shell-color-scripts
          ];

          # Debugging tools
          debugging = [
            delve # Go debugger
          ];

          # Linting tools
          linting = [
            markdownlint-cli # Markdown
            shellcheck # Shell
            hadolint # Dockerfile
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        # Plugins are organized by their functionality for better maintainability
        startupPlugins = with pkgs.vimPlugins; {
          # Core plugins required for basic functionality
          core = [
            lazy-nvim # Plugin manager
            plenary-nvim # Common utilities
            nui-nvim # UI components
            which-key-nvim # Keybinding helper
          ];

          # UI and appearance-related plugins
          ui = [
            bufferline-nvim
            dressing-nvim
            fidget-nvim
            incline-nvim
            kanagawa-nvim
            noice-nvim
            nvim-colorizer-lua
            snacks-nvim
            trouble-nvim
            tiny-inline-diagnostic-nvim
            smear-cursor-nvim
            (pkgs.vimUtils.buildVimPlugin {
              pname = "guihua.lua";
              version = "2025-06-13";
              src = pkgs.fetchFromGitHub {
                owner = "ray-x";
                repo = "guihua.lua";
                rev = "87bea7b98429405caf2a0ce4d029b027bb017c70";
                hash = "sha256-R/ckeCwzWixvL7q2+brvqcvfSK9Mx8pu6zOFgh2lde4=";
              };
              buildPhase = ''
                (
                  cd lua/fzy
                  make
                )
              '';
              nvimSkipModules = ["fzy.fzy-lua-native"];
            })
          ];

          # Editor enhancements for better coding experience
          editor = [
            comment-nvim
            grapple-nvim
            mini-nvim
            persistence-nvim
            vim-tmux-navigator
            undotree
            vim-sleuth
            todo-comments-nvim
            cloak-nvim # Hide sensitive information
          ];

          # Git integration plugins
          git = [
            gitsigns-nvim
          ];

          # LSP (Language Server Protocol) related plugins
          lsp = [
            mason-nvim
            mason-lspconfig-nvim
            mason-tool-installer-nvim
            nvim-lspconfig
            nvim-lint
            conform-nvim # Formatting
          ];

          # Completion and snippets
          completion = [
            luasnip
            blink-cmp
            friendly-snippets
          ];

          # AI assistants
          ai = [
            codecompanion-nvim
            codecompanion-history-nvim
            copilot-lua
            vectorcode-nvim
          ];

          # Language-specific plugins
          languages = [
            nvim-treesitter
            nvim-treesitter-textobjects
            nvim-ts-autotag
            crates-nvim # Rust crates
            rustaceanvim # Rust
            go-nvim # Go
            flutter-tools-nvim # Flutter/Dart
            tailwind-tools-nvim # Tailwind CSS
            SchemaStore-nvim # JSON
          ];

          # Utility plugins
          utils = [
            img-clip-nvim
            render-markdown-nvim
            lazydev-nvim
            fzf-lua
            undotree
            hardtime-nvim
          ];

          # Treesitter with grammars
          treesitter = [
            nvim-treesitter.withAllGrammars
            # Selective grammar loading alternative:
            # (nvim-treesitter.withPlugins (
            #   plugins: with plugins; [
            #     nix
            #     lua
            #   ]
            # ))
          ];

          # Debugging support
          debugging = [
            nvim-dap
            nvim-dap-ui
            nvim-nio
            mason-nvim-dap-nvim
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
          general = [
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
            ''--set CATTESTVAR2 "It worked again!"''
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
          test = _: [];
        };
        # populates $LUA_PATH and $LUA_CPATH
        extraLuaPackages = {
          test = [(_: [])];
        };
      };

      # see :help nixCats.flake.outputs.packageDefinitions
      packageDefinitions.replace = {
        # These are the names of your packages
        # you can include as many as you wish.
        nvim = {pkgs, ...}: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = true;
            # IMPORTANT:
            # your alias may not conflict with your other packages.
            aliases = ["vim"];
            # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
            hosts.python3.enable = true;
            hosts.node.enable = true;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          # and a set of categories that you want
          categories = {
            # Core functionality
            core = true;

            # User interface plugins
            ui = true;

            # Editor enhancements
            editor = true;

            # Git related plugins
            git = true;

            # LSP and code intelligence
            lsp = true;

            # Completion
            completion = true;

            # AI assistants
            ai = true;

            # Language specific plugins
            languages = true;

            # Utility plugins
            utils = true;

            # Treesitter and syntax highlighting
            treesitter = true;

            # Debugging support
            debugging = true;

            # Language servers and runtime dependencies
            languageServers = true;
            formatters = true;
            linting = true;
            visual = true;
            docs = true;

            # Required for backwards compatibility
            general = true;
            gitPlugins = true;
            customPlugins = true;
            test = true;

            # Additional settings
            have_nerd_font = true;

            # Example of complex settings (preserved from original)
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

        # an extra test package with normal lua reload for fast edits
        # nix doesnt provide the config in this package, allowing you free reign to edit it.
        # then you can swap back to the normal pure package when done.
        testnvim = {...}: {
          settings = {
            suffix-path = true;
            suffix-LD = true;
            wrapRc = false;
            unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/.dotfiles/config/nvim'";
          };
          categories = {
            core = true;
            ui = true;
            editor = true;
            git = true;
            lsp = true;
            completion = true;
            ai = true;
            languages = true;
            utils = true;
            treesitter = true;
            debugging = true;
            languageServers = true;
            formatters = true;
            linting = true;
            visual = true;
            docs = true;
            general = true;
            gitPlugins = true;
            customPlugins = true;
            test = true;
            have_nerd_font = true;
          };
          extra = {};
        };
      };
    };
  };
}
