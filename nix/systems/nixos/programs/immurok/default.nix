{
  config,
  hostname,
  lib,
  pkgs,
  ...
}:
let
  immurok = pkgs.callPackage ../../packages/immurok { };
  packaging = "${immurok.src}/packaging";
  integration = pkgs.runCommand "immurok-system-integration-${immurok.version}" { } ''
    mkdir -p "$out/lib/systemd/"{system,user}
    substitute ${packaging}/immurok-daemon.service "$out/lib/systemd/system/immurok-daemon.service" \
      --replace-fail /usr/bin/immurok-daemon ${immurok}/bin/immurok-daemon
    # default.target starts this agent and must be able to finish its own transaction.
    substitute ${packaging}/immurok-session-agent.service "$out/lib/systemd/user/immurok-session-agent.service" \
      --replace-fail /usr/bin/immurok-session-agent ${immurok}/bin/immurok-session-agent \
      --replace-fail 'After=default.target' ""
    install -Dm644 ${packaging}/dbus/immurok.conf "$out/share/dbus-1/system.d/immurok.conf"
  '';
in
lib.mkIf (hostname == "personal-dt") {
  environment.systemPackages = [ immurok ];
  hardware.bluetooth.enable = true;
  users.groups.immurok = { };
  users.users.immurok = {
    isSystemUser = true;
    group = "immurok";
  };

  systemd.packages = [ integration ];
  systemd.services.immurok-daemon = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.systemd ]; # The daemon invokes loginctl.
  };
  systemd.user.services.immurok-session-agent.wantedBy = [ "default.target" ];

  services.dbus.packages = [ integration ];
  security.polkit.enable = true;
  environment.etc."polkit-1/rules.d/49-immurok.rules".source = "${packaging}/polkit/49-immurok.rules";

  security.pam.services = lib.genAttrs [ "sudo" "polkit-1" ] (service: {
    rules.auth.immurok = {
      order = config.security.pam.services.${service}.rules.auth.unix.order - 1;
      control = "sufficient";
      modulePath = "${immurok}/lib/security/pam_immurok.so";
      args = lib.optional (service == "polkit-1") "timeout=10";
    };
  });
}
