# delta-nix

Runtime bits needed to run Zed's Delta beta on NixOS.

Delta updates itself in place, so packaging it in a derivation breaks the
updater. The bundle stays in `~/.local/delta.app` and these modules just make it
runnable.

## Install

```nix
inputs.delta-nix.url = "github:FelipeVasquez350/delta-nix";
```

Add `inputs.delta-nix.nixosModules.default` to your host's modules and
`inputs.delta-nix.homeModules.default` (or `homeManagerModules.default`) to
your home-manager imports:

```nix
# configuration.nix / a NixOS module
{ programs.delta.enable = true; }

# home-manager
{ programs.delta.enable = true; }
```

Rebuild and log back in so `nix-ld` session variables apply, then unpack the
tarball Zed gave you:

    tar xzf ~/Downloads/delta-linux-x86_64.tar.gz -C /tmp && /tmp/Delta/install.sh

This flake does not hash that tarball. Delta will keep updating itself from
Zed's channel; new nightlies install themselves and you will not need to
rebuild for them.

Vulkan needs NixOS graphics ICDs (`hardware.graphics.enable`, or
`hardware.opengl.enable` on older nixpkgs).

## What it does

nix-ld, because the binary's ELF interpreter is `/lib64/ld-linux-x86-64.so.2`.
Its library list covers what Delta dlopens (vulkan, wayland, EGL, xkb, X11,
alsa) — the `DT_NEEDED` ones already resolve through an `$ORIGIN/../lib` RPATH.
`libxkbcommon` is still on the nix-ld list as a fallback; it cannot replace the
vendored copy while `DT_RPATH` is set.

`XKB_CONFIG_ROOT` and `XLOCALEDIR` are what stop it crashing on startup. Delta
vendors an FHS-built `libxkbcommon.so.0`, and since the binary uses `DT_RPATH`
(which beats `LD_LIBRARY_PATH`) you can't substitute the nixpkgs one. It looks
for keymaps in `/usr/share/X11/xkb`; when that fails `xkb_context_new` returns
NULL and gpui dereferences it, segfaulting in `xkb_context_ref` on the first key
event.

`~/.local/bin` is added to PATH so the `delta` symlink from `install.sh` is
found. This flake does not install a `zed` binary: nixpkgs renamed that to
`zeditor` to avoid clashing with ZFS Event Daemon, and Home Manager should not
own a path `install.sh` also writes.

x86_64-linux only. Delete this once Delta ships its own flake.
