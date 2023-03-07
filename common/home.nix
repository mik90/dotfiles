{ config, lib, pkgs, ... }:
{

  home.username = "mike";
  home.homeDirectory = "/home/mike";
  home.stateVersion = "22.11";

  # Alow unfree home-manager packages
  nixpkgs.config = {
    allowUnfree = true;
  };

  home.packages = with pkgs; [
    htop
    powertop
    neofetch
    gdb
    lldb
    nixpkgs-fmt
    cmake
    gnumake
    rust-analyzer
    ninja
    nix-index
    yarn
    discord
    vlc
    opam
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  dconf.enable = true;
  dconf.settings = {
    # Set dark mode with `gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark`
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
    };
    # Use min/max/close for the window titlebar
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    # Turns off terminal bell sound in firefox, kinda sounds like "boink" tbh
    # https://unix.stackexchange.com/a/444869
    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };
  };
  programs.git = {
    enable = true;
    userName = "Mike Kaliman";
    userEmail = "kaliman.mike@gmail.com";
  };


  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      indentLine
      vim-nix
      nvim-lspconfig
    ];
  };

  xdg.configFile."nvim/init.vim".text =
    let
      plugins = [
        pkgs.vimPlugins.vim-nix
        pkgs.vimPlugins.nvim-lspconfig
        pkgs.vimPlugins.indentLine
      ];
      loadPlugin = plugin: ''
        set rtp^=${plugin.outPath}
        set rtp+=${plugin.outPath}/after
      '';
    in
    ''
      " Workaround for broken handling of packpath by vim8/neovim for ftplugins
      filetype off | syn off
      ${builtins.concatStringsSep "\n"
        (map loadPlugin plugins)}
      filetype indent plugin on | syn on

      " Set package path of lspconfig
      luado package.path = package.path .. ";${pkgs.vimPlugins.nvim-lspconfig.outPath}/lua/?.lua"


      " It doesn't work if i have this in the config section of the above setup
      let g:indentLine_leadingSpaceChar='·'
      let g:indentLine_leadingSpaceEnabled=1

      set shiftwidth=2
      set softtabstop=2
      set backspace=indent,eol,start
      set ruler
      set number
      set relativenumber
      set noexpandtab
      set nohlsearch

      autocmd filetype makefile setlocal noexpandtab 
      autocmd filetype python setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4
      autocmd filetype java setlocal expandtab 
      autocmd filetype cpp setlocal expandtab tabstop=4 softtabstop=4  shiftwidth=4 
      autocmd filetype markdown setlocal expandtab 
      autocmd filetype sh setlocal expandtab 
      autocmd filetype cmake setlocal expandtab 

      lua << EOF
          local opts = { noremap=true, silent=true }
          vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

          -- Use an on_attach function to only map the following keys
          -- after the language server attaches to the current buffer
          local on_attach = function(client, bufnr)
            -- Enable completion triggered by <c-x><c-o>
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            -- See `:help vim.lsp.*` for documentation on any of the below functions
            local bufopts = { noremap=true, silent=true, buffer=bufnr }
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
            vim.keymap.set('n', '<space>wl', function()
              print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, bufopts)
            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          
            vim.keymap.set('n', 'ff', vim.lsp.buf.formatting, opts)
          end

          require('lspconfig')['rust_analyzer'].setup{
            on_attach = on_attach,
            flags = {},
          }
      EOF
    '';
}
