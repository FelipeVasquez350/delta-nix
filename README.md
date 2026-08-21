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
`inputs.delta-nix.homeModules.default` to your home-manager imports. Rebuild,
then unpack the tarball Zed gave you:

    tar xzf ~/Downloads/delta-linux-x86_64.tar.gz -C /tmp && /tmp/Delta/install.sh

New nightlies install themselves; you won't need to rebuild for them.

## What it does

nix-ld, because the binary's ELF interpreter is `/lib64/ld-linux-x86-64.so.2`.
Its library list covers what Delta dlopens (vulkan, wayland, EGL, xkb, X11) —
the `DT_NEEDED` ones already resolve through an `$ORIGIN/../lib` RPATH.

`XKB_CONFIG_ROOT` and `XLOCALEDIR` are what stop it crashing on startup. Delta
vendors an FHS-built `libxkbcommon.so.0`, and since the binary uses `DT_RPATH`
(which beats `LD_LIBRARY_PATH`) you can't substitute the nixpkgs one. It looks
for keymaps in `/usr/share/X11/xkb`; when that fails `xkb_context_new` returns
NULL and gpui dereferences it, segfaulting in `xkb_context_ref` on the first key
event.

`~/.local/bin/zed` is a symlink to `zeditor`, since "Open in Zed" looks for a
binary named `zed` and nixpkgs doesn't install one.

x86_64-linux only. Delete this once Delta ships its own flake.
