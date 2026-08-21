{ pkgs, ... }:
{
  # Delta's install.sh puts its `delta` symlink here.
  home.sessionPath = [ "$HOME/.local/bin" ];

  # "Open in Zed" looks for a binary literally named `zed`; nixpkgs calls it
  # `zeditor`.
  home.file.".local/bin/zed".source = "${pkgs.zed-editor}/bin/zeditor";
}
