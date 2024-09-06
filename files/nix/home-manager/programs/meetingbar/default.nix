{ pkgs, ... }:
{
  home.packages = [
    (import ../../packages/meetingbar { inherit pkgs; })
  ];
}
