{
  username,
  ...
}:
{
  security.sudo.extraConfig = "${username} ALL=(ALL) NOPASSWD: /etc/profiles/per-user/${username}/bin/wg-quick up *, /etc/profiles/per-user/${username}/bin/wg-quick down *, /etc/profiles/per-user/${username}/bin/wg show *
";

}
