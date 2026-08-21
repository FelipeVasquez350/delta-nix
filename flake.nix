{
  description = "Run Zed's Delta beta on NixOS";

  outputs = { self }: {
    nixosModules.default = ./nixos.nix;
    homeModules.default = ./home.nix;
    homeManagerModules = self.homeModules;
  };
}
