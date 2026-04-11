{
  inputs,
  self,
  ...
}: let
  inherit (self) directories;
in {
  # Why perSystem here?
  # With that I can run `nix run path#neovimWrapped` to execute my Neovim config only
  perSystem = {system, ...}: let
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg:
        builtins.elem (inputs.nixpkgs.lib.getName pkg) [
          "copilot-language-server"
        ];
    };

    neovim = inputs.mnw.lib.wrap pkgs {
      appName = "nvim";
      aliases = ["v" "vi" "vim"];
      neovim = pkgs.neovim-unwrapped;

      extraBinPath = with pkgs; [
        # Core utilities
        universal-ctags
        ripgrep
        fd
        stdenv.cc.cc

        # Git tools
        lazygit

        # Documentation
        nix-doc

        # Language servers
        lua-language-server
        nixd
        bash-language-server
        tailwindcss-language-server
        htmx-lsp2
        astro-language-server
        vtsls
        docker-ls
        rust-analyzer
        docker-compose-language-service
        jsonnet-language-server
        taplo
        copilot-language-server
        elixir-ls
        gopls
        kdePackages.qtdeclarative

        # Formatters
        stylua
        prettierd
        shfmt
        alejandra
        biome
        gofumpt
        goimports-reviser

        # Debugging
        delve

        # Linting
        markdownlint-cli
        shellcheck
        hadolint
        gomodifytags
        impl
      ];

      providers = {
        python3.enable = true;
        nodeJs.enable = true;
      };

      # Load main config
      luaFiles = [
        (pkgs.writeText "nixd.lua"
          /*
          lua
          */
          ''
            -- Result: "/home/<user>/.dotfiles"
            local flakePath = '"' .. vim.env.HOME .. '/.dotfiles"'

            vim.g.nixd_config = {
              nixpkgs = 'import ${pkgs.path} {}',
              nixos_expr = '(builtins.getFlake ' .. flakePath .. ').nixosConfigurations.deepz.options',
              home_manager_expr = '(builtins.getFlake ' .. flakePath .. ').nixosConfigurations.deepz.options.home-manager.users.type.getSubOptions []',
              flake_parts_expr = '(builtins.getFlake ' .. flakePath .. ').debug.options',
            }
          '')
        "${directories.config}/nvim/init.lua"
      ];

      plugins = {
        dev.myconfig = {
          impure = "~/.dotfiles/config/nvim";
          pure = "${directories.config}/nvim";
        };

        # Plugins loaded at startup (not lazy-loaded)
        start = with pkgs.vimPlugins; [
          # Core - needed immediately
          lazy-nvim
          nui-nvim

          # Treesitter with all grammars
          nvim-treesitter.withAllGrammars

          # Debugging
          nvim-dap
          nvim-nio
        ];

        # Plugins managed by lazy.nvim (opt)
        opt = with pkgs.vimPlugins; [
          # UI
          fidget-nvim
          incline-nvim
          kanagawa-nvim
          snacks-nvim
          trouble-nvim

          # Editor
          nvim-ts-context-commentstring
          grapple-nvim
          mini-nvim
          vim-tmux-navigator
          guess-indent-nvim
          todo-comments-nvim
          cloak-nvim

          # Git
          gitsigns-nvim

          # LSP (mason plugins disabled when using Nix)
          nvim-lspconfig
          nvim-lint
          conform-nvim

          # Completion
          blink-cmp
          blink-indent
          friendly-snippets

          # AI
          sidekick-nvim

          # Languages
          nvim-treesitter-textobjects
          nvim-ts-autotag
          crates-nvim
          rustaceanvim
          SchemaStore-nvim

          # Utils
          markdown-preview-nvim
          lazydev-nvim
          hardtime-nvim
          grug-far-nvim
          flash-nvim

          # Debugging
          nvim-dap-ui
        ];
      };
    };
  in {
    packages = {
      inherit neovim;

      neovimDev = neovim.devMode;
    };
  };

  flake.modules.homeManager.nvim = {pkgs, ...}: {
    home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.neovim];
  };
}
