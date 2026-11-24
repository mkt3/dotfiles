{ pkgs, ... }:
{
  environment.systemPackages = [ (pkgs.callPackage ../../packages/immurok { }) ];
}
