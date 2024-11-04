{ ... }:
{
  programs.lsd = {
    enable = true;
    settings = {
      color.theme = "custom";
    };

    colors = {
      user = 182;
      group = 110;
      permission = {
        read = 222;
        write = 173;
        exec = 167;
        exec-sticky = 151;
        no-access = 103;
        octal = 110;
        acl = 109;
        context = 188;
      };
      date = {
        hour-old = 146;
        day-old = 103;
        older = 60;
      };
      size = {
        none = 238;
        small = 151;
        medium = 109;
        large = 167;
      };
      inode = {
        valid = 188;
        invalid = 167;
      };
      links = {
        valid = 110;
        invalid = 167;
      };
      tree-edge = 152;
      git-status = {
        default = 238;
        unmodified = 238;
        ignored = 238;
        new-in-index = 152;
        new-in-workdir = 109;
        typechange = 151;
        deleted = 167;
        renamed = 109;
        modified = 110;
        conflicted = 167;
      };
    };
  };

  programs.zsh.shellAliases = {
    ls = "lsd -F";
  };

  xdg.configFile."zsh/defer.zsh" = {
    text = ''
      chpwd() {
          lsd -F
      }
    '';
  };
}
