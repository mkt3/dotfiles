{
  pkgs,
  homeDirectory,
  ...
}:
{
  home.packages = [ pkgs.git-secrets ];

  programs.git = {
    extraConfig = {
      secrets = {
        providers = "git secrets --aws-provider";
        patterns = [
          "(A3T[A-Z0-9]|AKIA|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{16}"
          "(\"|')?(AWS|aws|Aws)?_?(SECRET|secret|Secret)?_?(ACCESS|access|Access)?_?(KEY|key|Key)(\"|')?\\s*(:|=>|=)\\s*(\"|')?[A-Za-z0-9/\\+=]{40}(\"|')?"
          "(\"|')?(AWS|aws|Aws)?_?(ACCOUNT|account|Account)_?(ID|id|Id)?(\"|')?\\s*(:|=>|=)\\s*(\"|')?[0-9]{4}\\-?[0-9]{4}\\-?[0-9]{4}(\"|')?"
        ];
        allowed = [
          "AKIAIOSFODNN7EXAMPLE"
          "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
        ];
      };
      init = {
        templatedir = "${homeDirectory}/.config/git/git-templates/git-secrets";
      };
    };
  };

  xdg.configFile."git/git-templates/git-secrets".source = ./git-templates/git-secrets;

}
