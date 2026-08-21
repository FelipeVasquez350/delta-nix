{
  description = "Run Zed's Delta beta on NixOS";

  outputs = _: {
    nixosModules.default = ./nixos.nix;
    homeModules.default = ./home.nix;
  };
}
