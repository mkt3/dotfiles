{
  lib,
  pkgs,
  ...
}:
{
  home.activation.macosMutablePreferences = lib.hm.dag.entryAfter [ "sharedSKKDictionary" ] ''
    ${lib.getExe pkgs.bash} ${./_setup_macos.sh}
  '';

  # Keep TCC permissions stable when Home Manager replaces locally built apps.
  # The signing identity is created once in the user's login keychain.
  home.activation.signPrivacySensitiveApps = lib.hm.dag.entryAfter [ "copyApps" ] ''
    signingIdentity="Local App Code Signing"
    apps=(
      "$HOME/Applications/Home Manager Apps/Emacs.app"
      "$HOME/Applications/Home Manager Apps/WezTerm.app"
      "$HOME/Applications/Home Manager Apps/MeetingBar.app"
    )

    if ! /usr/bin/security find-identity -v -p codesigning \
      | /usr/bin/grep -Fq "\"$signingIdentity\""; then
      echo "warning: code-signing identity not found: $signingIdentity" >&2
    else
      for app in "''${apps[@]}"; do
        if [[ -d "$app" ]]; then
          run /usr/bin/codesign \
            --force \
            --deep \
            --timestamp=none \
            --sign "$signingIdentity" \
            "$app"
        fi
      done
    fi
  '';
}
