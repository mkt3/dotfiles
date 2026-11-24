{
  lib,
  pkgs,
  rustPlatform,
  pkg-config,
  glib,
  gobject-introspection,
  wrapGAppsHook4,
  dbus,
  gtk4,
  libadwaita,
  libnotify,
  pam,
  python3,
}:
let
  source = (pkgs.callPackage ../../../../_sources/generated.nix { }).immurok;
  python = python3.withPackages (ps: [
    ps.dbus-fast
    ps.pygobject3
  ]);
in
rustPlatform.buildRustPackage {
  inherit (source) pname src;
  version = lib.removePrefix "v" source.version;
  cargoLock = source.cargoLock."Cargo.lock";

  # PID 1 in the Nix build sandbox belongs to the build user.
  checkFlags = [ "--skip=tty::tests::pid_1_is_not_mine" ];

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    glib
    gobject-introspection
    wrapGAppsHook4
  ];
  buildInputs = [
    dbus
    glib
    gtk4
    libadwaita
    pam
  ];

  postPatch = ''
    substituteInPlace crates/immurok-daemon/src/ble.rs \
      --replace-fail 'Command::new("python3")' 'Command::new("${python.interpreter}")'
    substituteInPlace crates/immurok-session-agent/src/main.rs \
      --replace-fail 'Command::new("notify-send")' 'Command::new("${lib.getExe' libnotify "notify-send"}")'
    substituteInPlace scripts/immurok-auth-dialog \
      --replace-fail '#!/usr/bin/python3' '#!${python.interpreter}'
    substituteInPlace scripts/ble-notify-helper.py \
      --replace-fail '#!/usr/bin/env python3' '#!${python.interpreter}'
    substituteInPlace packaging/com.immurok.Settings.desktop \
      --replace-fail 'DBusActivatable=true' 'DBusActivatable=false'
  '';

  postBuild = ''
    make -C pam CC="$CC"
  '';
  postCheck = ''
    make -C pam test CC="$CC"
  '';

  postInstall = ''
    install -m755 scripts/immurok-auth-dialog scripts/ble-notify-helper.py "$out/bin/"
    install -Dm755 pam/pam_immurok.so "$out/lib/security/pam_immurok.so"
    install -Dm644 packaging/com.immurok.Settings.desktop \
      "$out/share/applications/com.immurok.Settings.desktop"
    mkdir -p "$out/share/icons"
    cp -R packaging/icons/hicolor "$out/share/icons/"
  '';

  dontWrapGApps = true;
  postFixup = ''
    wrapProgram "$out/bin/immurok-gui" "''${gappsWrapperArgs[@]}"
    wrapProgram "$out/bin/immurok-auth-dialog" "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Linux companion app for the immurok fingerprint security key";
    homepage = "https://github.com/immurok/app-linux-rs";
    changelog = "https://github.com/immurok/app-linux-rs/releases/tag/${source.version}";
    license = lib.licenses.asl20;
    mainProgram = "immurok-gui";
    platforms = lib.platforms.linux;
  };
}
