{ pkgs, ... }:
{
  # Delta is a prebuilt binary that updates itself in ~/.local/delta.app, so it
  # runs via nix-ld instead of being packaged. These are the libraries it
  # dlopens; the rest come from its own vendored lib/ directory.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libglvnd
    libx11
    libxcb
    libxkbcommon
    vulkan-loader
    wayland
  ];

  # Delta vendors an FHS-built libxkbcommon that looks for keymaps in
  # /usr/share/X11 and segfaults when it doesn't find them.
  environment.sessionVariables = {
    XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
    XLOCALEDIR = "${pkgs.libx11}/share/X11/locale";
  };
}
