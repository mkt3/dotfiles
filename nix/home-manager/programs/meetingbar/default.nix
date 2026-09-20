{ pkgs, ... }:
let
  meetingbar = pkgs.meetingbar.overrideAttrs (old: {
    # The upstream DMG contains extended attributes unpacked by 7-Zip as
    # ordinary colon-suffixed files. They are metadata, not bundle resources,
    # and make the code signer reject Contents/MacOS as mixed executable data.
    postInstall = (old.postInstall or "") + ''
      find "$out/Applications/MeetingBar.app" \
        -type f -name '*:com.apple.*' -delete
    '';
  });
in
{
  targets.darwin.appIdentity.apps = [ meetingbar ];
}
