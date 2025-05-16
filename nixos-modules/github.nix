{pkgs, ...}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  programs.ssh.startAgent = true;

  environment.systemPackages = with pkgs; [gh];
  programs.git.enable = true;
  programs.git.config = [
    {
      init.defaultBranch = "main";
      url."git@github.com:".insteadOf = ["github:"];
      core.editor = "nvim";
    }
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
}
