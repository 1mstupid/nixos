{
  inputs,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.zellij = moduleWithSystem (
    {self'}: {
      environment.systemPackages = with self'.packages; [
        zellij
      ];
    }
  );

  perSystem = {pkgs, ...}: let
    # WASM cross-compilation package set
    wasmPkgs = pkgs.pkgsCross.wasm32-wasip1;

    # Generic Zellij WASM plugin builder
    mkWasmPlugin = {
      pname,
      src,
      wasmName,
    }:
      wasmPkgs.callPackage
      (
        {
          rustPlatform,
          lld,
          ...
        }:
          rustPlatform.buildRustPackage {
            inherit pname src;

            version = "git";

            cargoLock.lockFile = "${src}/Cargo.lock";

            # WASM linker
            env.RUSTFLAGS = "-C linker=wasm-ld";

            nativeBuildInputs = [
              lld
            ];

            doCheck = false;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/zellij/plugins

              cp target/wasm32-wasip1/release/${wasmName}.wasm \
                $out/share/zellij/plugins/${wasmName}.wasm

              runHook postInstall
            '';
          }
      )
      {};

    # Ghost plugin
    ghost = mkWasmPlugin {
      pname = "ghost";
      src = inputs.ghost;
      wasmName = "ghost";
    };

    # Harpoon plugin
    harpoon = mkWasmPlugin {
      pname = "harpoon";
      src = inputs.harpoon;
      wasmName = "harpoon";
    };

    # zjstatus plugin
    zjstatus = inputs.zjstatus.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Layout
    layoutDir = pkgs.writeTextDir "layouts/default.kdl" ''
      layout {
        default_tab_template {
          pane size=1 borderless=true {
            plugin location="file:${zjstatus}/bin/zjstatus.wasm" {
              format_left "{mode} #[fg=#89B4FA,bold]{session}"
              format_center "{tabs}"
              format_right "{command_git_branch} {datetime}"

              border_enabled "false"

              mode_normal "#[bg=#89B4FA,fg=#1e1e2e,bold] NORMAL "
              mode_tmux "#[bg=#fab387,fg=#1e1e2e,bold] STICKY "

              tab_normal "#[fg=#6c7086] {name} "
              tab_active "#[fg=#a6e3a1,bold] {name} "

              command_git_branch_command "git rev-parse --abbrev-ref HEAD"
              command_git_branch_format "#[fg=#89b4fa] {stdout} "
              command_git_branch_interval "10"
              command_git_branch_rendermode "static"
              command_git_branch_cwd "{focused_pane_cwd}"

              datetime "#[fg=#6c7086] {format}"
              datetime_format "%d/%m/%Y %H:%M"
            }
          }

          children
        }
      }
    '';
    # Zellij configuration
    zellijConfig = pkgs.writeText "config.kdl" ''
      // General
      pane_frames true
      mouse_mode false
      copy_on_select false
      scroll_buffer_size 10000

      default_layout "default"
      layout_dir "${layoutDir}/layouts"

      // Keybindings
      keybinds clear-defaults=true {

        // Enter sticky mode
        shared_except "locked" {
          bind "Ctrl b" {
            SwitchToMode "tmux";
          }
        }

        // Sticky mode
        tmux {
          // Exit sticky mode
          bind "Esc" {
            SwitchToMode "normal";
          }

          bind "Ctrl b" {
            SwitchToMode "normal";
          }

          // Pane navigation
          bind "h" { MoveFocus "Left"; }
          bind "j" { MoveFocus "Down"; }
          bind "k" { MoveFocus "Up"; }
          bind "l" { MoveFocus "Right"; }

          // Cycle panes
          bind "o" { SwitchFocus; }

          // Pane splits
          bind "|" { NewPane "Right"; }
          bind "-" { NewPane "Down"; }

          // Pane resizing
          bind "Ctrl h" { Resize "Left"; }
          bind "Ctrl j" { Resize "Down"; }
          bind "Ctrl k" { Resize "Up"; }
          bind "Ctrl l" { Resize "Right"; }

          // Pane management
          bind "x" { CloseFocus; }
          bind "z" { ToggleFocusFullscreen; }

          // Swap panes
          bind "H" { MovePane "Left"; }
          bind "L" { MovePane "Right"; }

          // Pane selection
          bind "q" { SwitchToMode "pane"; }

          // Window / tab navigation
          bind "n" { GoToNextTab; }
          bind "p" { GoToPreviousTab; }

          bind "1" { GoToTab 1; }
          bind "2" { GoToTab 2; }
          bind "3" { GoToTab 3; }
          bind "4" { GoToTab 4; }
          bind "5" { GoToTab 5; }
          bind "6" { GoToTab 6; }
          bind "7" { GoToTab 7; }
          bind "8" { GoToTab 8; }
          bind "9" { GoToTab 9; }

          // Tab management
          bind "c" { NewTab; }
          bind "," { SwitchToMode "renametab"; }

          // Session management
          bind "s" {
            LaunchOrFocusPlugin "zellij:session-manager" {
              floating true;
            }
          }

          bind "d" { Detach; }

          // Ghost
          bind "e" {
            LaunchOrFocusPlugin "file:${ghost}/share/zellij/plugins/ghost.wasm" {
              floating true;
              move_to_focused_tab true;

              shell "zsh";
              shell_flag "-ic";
            }
          }

          // Harpoon
          bind "a" {
            LaunchOrFocusPlugin "file:${harpoon}/share/zellij/plugins/harpoon.wasm" {
              floating true;
              move_to_focused_tab true;
            }
          }
        }

        // Pane mode
        pane {
          bind "Esc" { SwitchToMode "tmux"; }

          bind "h" {
            MoveFocus "Left";
            SwitchToMode "tmux";
          }

          bind "j" {
            MoveFocus "Down";
            SwitchToMode "tmux";
          }

          bind "k" {
            MoveFocus "Up";
            SwitchToMode "tmux";
          }

          bind "l" {
            MoveFocus "Right";
            SwitchToMode "tmux";
          }

          bind "x" {
            CloseFocus;
            SwitchToMode "tmux";
          }
        }

        // Rename tab
        renametab {
          bind "Esc" { SwitchToMode "tmux"; }
          bind "Enter" { SwitchToMode "tmux"; }
        }
      }

      // Clipboard
      copy_command "wl-copy"
    '';
  in {
    # Zellij executable with automatic config
    packages.zellij = pkgs.symlinkJoin {
      name = "zellij";

      paths = [
        pkgs.zellij
      ];

      nativeBuildInputs = [
        pkgs.makeWrapper
      ];

      postBuild = ''
        wrapProgram $out/bin/zellij \
          --add-flags "--config ${zellijConfig}"
      '';
    };

    # Individual plugin packages
    packages.ghost = ghost;
    packages.harpoon = harpoon;
  };
}
