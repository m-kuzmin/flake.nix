{pkgs, ...}: {
  programs.gnupg.agent.enable = true;
  environment.systemPackages = with pkgs; [gh];
  programs.git.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.git.config = [
    {
      init.defaultBranch = "main";
      url."git@github.com:".insteadOf = ["github:"];
      core.editor = "nvim";
    }
  ];
}
