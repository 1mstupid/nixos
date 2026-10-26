{
  description = "I'm going to kill myself";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    umbriel = {
      url = "github:1mstupid/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell.url = "github:1mstupid/quickshell";
    quickshell.flake = false;
    mpv.url = "github:1mstupid/mpv";
    mpv.flake = false;
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayugram-desktop = {
      url = "git+https://github.com/ndfined-crp/ayugram-desktop?submodules=1";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; }
      (inputs.import-tree ./modules);
}
