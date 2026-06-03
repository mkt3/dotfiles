{
  agent-skills,
  config,
  ...
}:
{
  imports = [
    agent-skills.homeManagerModules.default
  ];

  programs.agent-skills = {
    enable = true;

    sources.local = {
      path = ./skills;
    };
    sources.anthropic = {
      input = "anthropic-skills";
      subdir = "skills";
    };

    skills.enableAll = [ "local" ];
    skills.enable = [
      "frontend-design"
      "skill-creator"
    ];

    targets.codex = {
      enable = true;
      dest = "${config.xdg.configHome}/codex/skills";
    };
    targets.claude = {
      enable = true;
      dest = "${config.xdg.configHome}/claude/skills";
    };
  };
}
