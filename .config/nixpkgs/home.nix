{ config, lib, pkgs, ... }:

{
  imports = [
    "${fetchTarball "https://github.com/msteen/nixos-vscode-server/tarball/master"}/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;

  home.packages = with pkgs; [ thefuck nodejs ];

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" ];
      theme = "robbyrussell";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = { enable = true; };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [ 
      coc-nvim
      coc-rust-analyzer
      coc-pyright
      rust-vim
    ];
    extraPackages = with pkgs; [ rust-analyzer python-language-server ];
    extraConfig = ''
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)

      let g:rustfmt_autosave = 1
      let g:rustfmt_emit_files = 1
      let g:rustfmt_fail_silently = 0
      let g:rust_clip_command = 'xclip -selection clipboard'

      set relativenumber
      set number
      set colorcolumn=80
      set showcmd
      set mouse=a
      set shiftwidth=8
      set softtabstop=8
      set tabstop=8
      set noexpandtab
      set splitright
      set splitbelow
      set autoindent
    '';
  };
}
