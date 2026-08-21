{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.delta;
in
{
  options.programs.delta.enable =
    lib.mkEnableOption "runtime support for Zed's Delta beta";

  config = lib.mkIf cfg.enable {
    # Delta is a prebuilt binary that updates itself in ~/.local/delta.app, so it
    # runs via nix-ld instead of being packaged. These are the libraries it
    # dlopens; the rest come from its own vendored lib/ directory.
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      alsa-lib
      libglvnd
      libx11
      libxcb
      libxkbcommon
      vulkan-loader
      wayland
    ];

    # Delta vendors an FHS-built libxkbcommon that looks for keymaps in
    # /usr/share/X11 and segfaults when it doesn't find them. mkDefault so an
    # existing XKB_CONFIG_ROOT (e.g. extra-layouts) wins.
    environment.sessionVariables = {
      XKB_CONFIG_ROOT = lib.mkDefault "${pkgs.xkeyboard_config}/share/X11/xkb";
      XLOCALEDIR = lib.mkDefault "${pkgs.libx11}/share/X11/locale";
    };
  };
}
