{ pkgs, ... }:
let
  omniwm = pkgs.callPackage ../../packages/omniwm { };
in
{
  home.packages = [ omniwm ];
}
