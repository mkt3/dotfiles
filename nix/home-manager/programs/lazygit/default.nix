{ ... }:
let
  nord = import ../nord/palette.nix;
in
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gui.theme = {
        activeBorderColor = [
          nord.accent
          "bold"
        ];
        inactiveBorderColor = [ nord.muted ];
        searchingActiveBorderColor = [
          nord.accent
          "bold"
        ];
        optionsTextColor = [ nord.accent ];
        selectedLineBgColor = [ nord.selection ];
        inactiveViewSelectedLineBgColor = [ nord.surface ];
        cherryPickedCommitFgColor = [ nord.accent ];
        cherryPickedCommitBgColor = [ nord.background ];
        markedBaseCommitFgColor = [ nord.textBright ];
        markedBaseCommitBgColor = [ nord.surface ];
        unstagedChangesColor = [ nord.danger ];
        defaultFgColor = [ nord.text ];
      };

      git = {
        diffRenderers = [
          {
            command = "delta --dark --paging=never --24-bit-color=auto -n";
            colorArg = "always";
          }
        ];
      };
    };
  };
}
