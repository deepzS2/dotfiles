# Neovim editor configuration module for Home Manager
# Exported as flake.modules.homeManager.nvim
{inputs, ...}: {
  flake.modules.homeManager.nvim = {pkgs, ...}: let
    inherit (inputs.nixCats) utils;
  in {
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
        lspsAndRuntimeDeps = {
          # Core utilities used for various editor functions
          core = [
            pkgs.universal-ctags
            pkgs.ripgrep
            pkgs.fd
            pkgs.stdenv.cc.cc
          ];

          # Git-related tools
          git = [
            pkgs.lazygit
          ];

          # Documentation tools
          docs = [
            pkgs.nix-doc
          ];

          # Language servers for different languages
          languageServers = [
            # System languages
            pkgs.lua-language-server
            pkgs.nixd
            pkgs.bash-language-server

            # Web development
            pkgs.tailwindcss-language-server
            pkgs.htmx-lsp2
            pkgs.astro-language-server
            pkgs.vtsls # TypeScript

            # Container/configuration languages
            pkgs.docker-ls
            pkgs.docker-compose-language-service
            pkgs.jsonnet-language-server
            pkgs.taplo # TOML

            # AI NES
            pkgs.copilot-language-server

            # Other languages
            pkgs.elixir-ls
            pkgs.gopls
          ];

          # Code formatting tools
          formatters = [
            pkgs.stylua # Lua
            pkgs.prettierd # Web
            pkgs.shfmt # Shell
            pkgs.alejandra # Nix
            pkgs.biome # JavaScript/TypeScript
            pkgs.gofumpt # Go
            pkgs.goimports-reviser # Go imports
          ];

          # Visual enhancements
          visual = [
            pkgs.dwt1-shell-color-scripts
          ];

          # Debugging tools
          debugging = [
            pkgs.delve # Go debugger
          ];

          # Linting tools
          linting = [
            pkgs.markdownlint-cli # Markdown
            pkgs.shellcheck # Shell
            pkgs.hadolint # Dockerfile
            pkgs.gomodifytags # Go struct field tags
            pkgs.impl # Go implement interface
          ];
        };

        # This is for plugins that will load at startup without using packadd:
        # Plugins are organized by their functionality for better maintainability
        startupPlugins = let
          inherit (pkgs) vimPlugins;
        in {
          # Core plugins required for basic functionality
          core = [
            vimPlugins.lazy-nvim # Plugin manager
            vimPlugins.plenary-nvim # Common utilities
            vimPlugins.nui-nvim # UI components
            vimPlugins.which-key-nvim # Keybinding helper
          ];

          # UI and appearance-related plugins
          ui = [
            vimPlugins.bufferline-nvim
            vimPlugins.dressing-nvim
            vimPlugins.fidget-nvim
            vimPlugins.incline-nvim
            vimPlugins.kanagawa-nvim
            vimPlugins.noice-nvim
            vimPlugins.nvim-colorizer-lua
            vimPlugins.snacks-nvim
            vimPlugins.trouble-nvim
            vimPlugins.tiny-inline-diagnostic-nvim
            vimPlugins.smear-cursor-nvim
          ];

          # Editor enhancements for better coding experience
          editor = [
            vimPlugins.nvim-ts-context-commentstring
            vimPlugins.grapple-nvim
            vimPlugins.mini-nvim
            vimPlugins.persistence-nvim
            vimPlugins.vim-tmux-navigator
            vimPlugins.guess-indent-nvim
            vimPlugins.todo-comments-nvim
            vimPlugins.cloak-nvim # Hide sensitive information
          ];

          # Git integration plugins
          git = [
            vimPlugins.gitsigns-nvim
          ];

          # LSP (Language Server Protocol) related plugins
          lsp = [
            vimPlugins.mason-nvim
            vimPlugins.mason-lspconfig-nvim
            vimPlugins.mason-tool-installer-nvim
            vimPlugins.nvim-lspconfig
            vimPlugins.nvim-lint
            vimPlugins.conform-nvim # Formatting
          ];

          # Completion and snippets
          completion = [
            vimPlugins.blink-cmp
            vimPlugins.friendly-snippets
          ];

          # AI assistants
          ai = [
            vimPlugins.sidekick-nvim
          ];

          # Language-specific plugins
          languages = [
            vimPlugins.nvim-treesitter
            vimPlugins.nvim-treesitter-textobjects
            vimPlugins.nvim-ts-autotag
            vimPlugins.crates-nvim # Rust crates
            vimPlugins.rustaceanvim # Rust
            vimPlugins.flutter-tools-nvim # Flutter/Dart
            vimPlugins.SchemaStore-nvim # JSON
          ];

          # Utility plugins
          utils = [
            vimPlugins.img-clip-nvim
            vimPlugins.markview-nvim
            vimPlugins.lazydev-nvim
            vimPlugins.fzf-lua
            vimPlugins.undotree
            vimPlugins.hardtime-nvim
            vimPlugins.grug-far-nvim
            vimPlugins.flash-nvim
          ];

          # Treesitter with grammars
          treesitter = [
            vimPlugins.nvim-treesitter.withAllGrammars
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
            vimPlugins.nvim-dap
            vimPlugins.nvim-dap-ui
            vimPlugins.nvim-nio
            vimPlugins.mason-nvim-dap-nvim
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
        testnvim = _: {
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
