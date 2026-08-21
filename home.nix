{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.delta;
in
{
  options.programs.delta.enable =
    lib.mkEnableOption "adding ~/.local/bin so Delta's installer is on PATH";

  config = lib.mkIf cfg.enable {
    # Delta's install.sh puts its `delta` symlink here.
    home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
  };
}
