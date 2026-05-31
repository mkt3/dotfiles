{
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      mgr = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      plugin = {
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        # prepend_preloaders = [
        #   {
        #     mime = "application/openxmlformats-officedocument.*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/oasis.opendocument.*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/ms-*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/msword";
        #     run = "office";
        #   }
        #   {
        #     url = "*.docx";
        #     run = "office";
        #   }
        # ];
        # prepend_previewers = [

        #   {
        #     mime = "application/openxmlformats-officedocument.*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/oasis.opendocument.*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/ms-*";
        #     run = "office";
        #   }
        #   {
        #     mime = "application/msword";
        #     run = "office";
        #   }
        #   {
        #     url = "*.docx";
        #     run = "office";
        #   }
        # ];
      };
    };

    flavors = {
      nord = pkgs.yaziPlugins.nord;
    };

    theme.flavor = {
      light = "nord";
      dark = "nord";
    };

    plugins = {
      full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
      };
      chmod = pkgs.yaziPlugins.chmod;
      smart-enter = pkgs.yaziPlugins.smart-enter;
      jump-to-char = pkgs.yaziPlugins.jump-to-char;
      smart-filter = pkgs.yaziPlugins.smart-filter;
      git = {
        package = pkgs.yaziPlugins.git;
        setup = true;
        settings.order = 1500;
      };
      githead = {
        package = pkgs.yaziPlugins.githead;
        setup = true;
        settings = {
          branch_prefix = "on";
          branch_symbol = " ";
          branch_borders = "()";
        };
      };
      nord = pkgs.yaziPlugins.nord;
      clipboard = pkgs.yaziPlugins.clipboard;
      # office = pkgs.yaziPlugins.office;
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "<Enter>";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = [ "y" ];
          run = [
            "yank"
            "plugin clipboard -- --action=copy"
          ];
        }
        {
          on = [ "<C-p>" ];
          run = "plugin clipboard -- --action=paste";
        }
        {
          on = [ "<D-v>" ];
          run = "plugin clipboard -- --action=paste";
        }
        {
          on = [ "<D-p>" ];
          run = "plugin clipboard -- --action=paste";
        }
      ];
    };
  };
}
