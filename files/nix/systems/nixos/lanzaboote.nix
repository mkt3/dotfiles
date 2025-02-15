{ lanzaboote, ... }:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
    configurationLimit = 7;
  };
}
