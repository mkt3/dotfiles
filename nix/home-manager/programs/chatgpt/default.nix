{
  llm-agents,
  pkgs,
  ...
}:
{
  home.packages = [
    llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.chatgpt
  ];
}
