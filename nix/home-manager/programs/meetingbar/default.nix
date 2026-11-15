{ pkgs, ... }:
{
  targets.darwin.appIdentity.apps = [ pkgs.meetingbar ];
}
