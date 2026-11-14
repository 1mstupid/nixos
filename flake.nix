{
  description = "I'm going to kill myself, I didn't :) Yet. T_T ";
  inputs = {
    # nix
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    rust-overlay.url = "github:oxalica/rust-overlay";

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
    ghost = {
      url = "github:vdbulcke/ghost";
      flake = false;
    };
    harpoon = {
      url = "github:Nacho114/harpoon";
      flake = false;
    };
    zjstatus.url = "github:dj95/zjstatus";
    nova.url = "github:Yazelix/nova/stable";
    millennium.url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
    quickshell.url = "github:1mstupid/quickshell";
    quickshell.flake = false;
    mpv.url = "github:1mstupid/mpv";
    mpv.flake = false;
    nvim.url = "github:1mstupid/nvim";
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

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
