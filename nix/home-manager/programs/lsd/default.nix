{ ... }:
let
  nord = import ../nord/palette.nix;
in
{
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      color.theme = "custom";
      indicators = true;
    };

    colors = {
      user = nord.accent;
      group = nord.accentBlue;
      permission = {
        read = nord.success;
        write = nord.warning;
        exec = nord.purple;
        exec-sticky = nord.orange;
        no-access = nord.muted;
        octal = nord.accent;
        acl = nord.accentAlt;
        context = nord.text;
      };
      date = {
        hour-old = nord.success;
        day-old = nord.accent;
        older = nord.muted;
      };
      size = {
        none = nord.muted;
        small = nord.success;
        medium = nord.warning;
        large = nord.danger;
      };
      inode = {
        valid = nord.accent;
        invalid = nord.danger;
      };
      links = {
        valid = nord.accentAlt;
        invalid = nord.danger;
      };
      tree-edge = nord.muted;
      git-status = {
        default = nord.text;
        unmodified = nord.muted;
        ignored = nord.muted;
        new-in-index = nord.success;
        new-in-workdir = nord.accentAlt;
        typechange = nord.orange;
        deleted = nord.danger;
        renamed = nord.accentBlue;
        modified = nord.warning;
        conflicted = nord.danger;
      };
      file-type = {
        file = {
          exec-uid = nord.warning;
          uid-no-exec = nord.warning;
          exec-no-uid = nord.success;
          no-exec-no-uid = nord.text;
        };
        dir = {
          uid = nord.accent;
          no-uid = nord.accentBlue;
        };
        pipe = nord.purple;
        symlink = {
          default = nord.accentAlt;
          broken = nord.danger;
          missing-target = nord.danger;
        };
        block-device = nord.orange;
        char-device = nord.orange;
        socket = nord.purple;
        special = nord.warning;
      };
    };
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      chpwd() {
          lsd
      }
    '';
  };
}
