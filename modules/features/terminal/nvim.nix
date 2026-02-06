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

    baseConfig = {
      appName = "nvim";
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

        # Visual
        dwt1-shell-color-scripts

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
        # Plugins loaded at startup (not lazy-loaded)
        start = with pkgs.vimPlugins; [
          # Core - needed immediately
          lazy-nvim
          plenary-nvim
          nui-nvim

          # Treesitter with all grammars
          nvim-treesitter.withAllGrammars

          # Debugging
          nvim-dap
          nvim-nio

          # Orgmode
          orgmode
          org-roam-nvim
          render-markdown-nvim
          sniprun
          (pkgs.vimUtils.buildVimPlugin {
            pname = "org-bullets.nvim";
            version = "2024-06-12";
            src = pkgs.fetchFromGitHub {
              owner = "nvim-orgmode";
              repo = "org-bullets.nvim";
              rev = "21437cfa99c70f2c18977bffd423f912a7b832ea";
              sha256 = "0zfic6isqvbycn4zq1jsrr6g4yksmvgxzavknzlswg2jymz0hpzy";
            };
            meta.homepage = "https://github.com/nvim-orgmode/org-bullets.nvim";
          })
        ];

        # Plugins managed by lazy.nvim (opt)
        opt = with pkgs.vimPlugins; [
          # UI
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
          which-key-nvim

          # Editor
          nvim-ts-context-commentstring
          grapple-nvim
          mini-nvim
          persistence-nvim
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
          flutter-tools-nvim
          SchemaStore-nvim

          # Utils
          img-clip-nvim
          markview-nvim
          markdown-preview-nvim
          lazydev-nvim
          fzf-lua
          undotree
          hardtime-nvim
          grug-far-nvim
          flash-nvim

          nvim-dap-ui
        ];

        # Dev mode config for hot-reloading
        dev.myconfig = {
          pure = "${directories.config}/nvim";
          impure = "${builtins.getEnv "PWD"}/config/nvim";
        };
      };
    };

    neovimWrapped = inputs.mnw.lib.wrap pkgs (baseConfig // {aliases = ["v" "vi" "vim"];});
  in {
    packages.neovimWrapped = neovimWrapped;
  };

  flake.modules.homeManager.nvim = {pkgs, ...}: {
    home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.neovimWrapped];
  };
}
