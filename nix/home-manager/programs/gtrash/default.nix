{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.gtrash ];

  programs.zsh.shellAliases = {
    rm = "echo -e 'If you want to use rm really, then use \"\\\\rm\" instead.'; false";
    ping = "echo -e 'If you want to ping, consider using \"nc -zv <host> <port>\" to check specific service availability instead.'; false";
  };

  programs.zsh.envExtra = lib.mkAfter ''
    # navi
    GTRASH_PUT_RM_MODE="true"
  '';

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      # Remove only the files that have been deleted more than 7 days ago:
      yes y | gtrash prune --day 7
    '';
  };
}
