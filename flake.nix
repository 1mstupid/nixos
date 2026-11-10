{
  description = "I'm going to kill myself, I didn't :) Yet. T_T ";
  inputs = {
    # nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # apps
    umbriel = {
      url = "github:1mstupid/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    quickshell.url = "github:1mstupid/quickshell";
    quickshell.flake = false;
    mpv.url = "github:1mstupid/mpv";
    mpv.flake = false;
    nvim.url = "github:1mstupid/nvim";
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    claude-desktop = {
      url = "github:Realdhiru/claude-desktop-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapfast = {
      type = "github";
      owner = "crmne";
      repo = "zapfast";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ayugram-desktop = {
      url = "git+https://github.com/ndfined-crp/ayugram-desktop?submodules=1";
    };

    # flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
