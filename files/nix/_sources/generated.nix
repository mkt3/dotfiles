# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  aerospace = {
    pname = "aerospace";
    version = "v0.14.2-Beta";
    src = fetchurl {
      url = "https://github.com/nikitabobko/AeroSpace/releases/download/v0.14.2-Beta/AeroSpace-v0.14.2-Beta.zip";
      sha256 = "sha256-xOIP51kFQTy9RbCGQo5gJGMzl/WhZlJ+lCtMOaMCnB8=";
    };
  };
  meetingbar = {
    pname = "meetingbar";
    version = "v4.10.0";
    src = fetchurl {
      url = "https://github.com/leits/MeetingBar/releases/download/v4.10.0/MeetingBar.dmg";
      sha256 = "sha256-8b7UyR5fLdnOYa/fsqm75n4n+sZYKf75hIEh6Dp2t6A=";
    };
  };
  scroll-reverser = {
    pname = "scroll-reverser";
    version = "1.9";
    src = fetchurl {
      url = "https://github.com/pilotmoon/Scroll-Reverser/releases/download/v1.9/ScrollReverser-1.9.zip";
      sha256 = "sha256-CWHbtvjvTl7dQyvw3W583UIZ2LrIs7qj9XavmkK79YU=";
    };
  };
  vivaldi-darwin = {
    pname = "vivaldi-darwin";
    version = "6.9.3447.51";
    src = fetchurl {
      url = "https://downloads.vivaldi.com/stable/Vivaldi.6.9.3447.51.universal.dmg";
      sha256 = "sha256-P6tVW83n0ox2jt4+q0geZSRH9j+PZ72Lhi6/3VX2ttc=";
    };
  };
  vlc = {
    pname = "vlc";
    version = "3.0.21";
    src = fetchurl {
      url = "https://get.videolan.org/vlc/3.0.21/macosx/vlc-3.0.21-arm64.dmg";
      sha256 = "sha256-Fd1lv2SJ2p7Gpn9VhcdMQKWJk6z/QagpWKkW3XQXgEQ=";
    };
  };
}
