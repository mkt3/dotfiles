{ ... }:
{
  programs.claude-code = {
    enable = true;
    settings = {
      "$schema" = "https://json.schemastore.org/claude-code-settings.json";
      "env" = {
        "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC" = "1";
      };
    };
  };
}
