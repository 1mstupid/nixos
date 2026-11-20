{
  description = "I'm going to kill myself, I didn't :) Yet. T_T ";
  inputs = {
    # nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # San Francisco Fonts | Apple Fonts
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";

    # Stylix
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # apps
    helium-flake = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel = {
      url = "github:1mstupid/umbriel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:1mstupid/hypr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    woomer = {
      url = "github:voidarclabs/woomer";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghost = {
      url = "github:vdbulcke/ghost";
      flake = false;
    };
    harpoon = {
      url = "github:Nacho114/harpoon";
      flake = false;
    };
    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nova = {
      url = "github:Yazelix/nova/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mpv.url = "github:1mstupid/mpv";
    mpv.flake = false;
    nvim = {
      url = "github:1mstupid/nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zapfast = {
      type = "github";
      owner = "crmne";
      repo = "zapfast";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:BirdeeHub/nix-wrapper-modules";
    import-tree.url = "github:denful/import-tree";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
