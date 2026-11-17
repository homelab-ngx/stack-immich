{
  description = "Immich as a homelab service stack";

  # What the homelab daemon builds, on its base module and the nixpkgs
  # homelab-stack.json recommends (manifest version 7). No inputs: Immich,
  # its NixOS module and Postgres all come from that nixpkgs.
  outputs = _: {
    nixosModules.default = ./stack.nix;
  };
}
