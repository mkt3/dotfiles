{ ... }:
{
  home.file.".local/bin/notify.sh" = {
    source = ./notify.sh;
    executable = true;
  };
}
