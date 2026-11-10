{
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake.nixosModules.tmux = moduleWithSystem (
    { self' }: {
      environment.systemPackages = with self'.packages; [
        tmux
      ];
    }
  );

  perSystem = { pkgs, ... }: {
    packages.tmux =
      let
        tmuxConf = pkgs.writeText "tmux.conf" ''
          # Terminal
          set -s default-terminal "tmux-256color"

          set -as terminal-features ',alacritty:RGB:clipboard,alacritty*:RGB:clipboard,xterm-kitty:RGB:clipboard'
          set -sg terminal-overrides ",*:RGB"
          set -as terminal-overrides ',*:Smulx=\E[4::%p1%d'

          set -g allow-passthrough on
          set-option -s extended-keys on
          set -g extended-keys-format csi-u

          # General
          set -g renumber-windows on
          set -g allow-rename on
          set -g set-clipboard on
          set -g mouse off

          # Prefix / Sticky mode
          # Ctrl-b Ctrl-b enters sticky mode.
          # Escape exits sticky mode.
          # Ctrl-b in sticky mode returns to normal prefix mode.

          bind-key -T prefix C-b switch-client -T sticky

          bind-key -T sticky Escape switch-client -T root
          bind-key -T sticky C-b switch-client -T root


          # Pane navigation
          bind-key -T sticky h select-pane -L \; switch-client -T sticky
          bind-key -T sticky j select-pane -D \; switch-client -T sticky
          bind-key -T sticky k select-pane -U \; switch-client -T sticky
          bind-key -T sticky l select-pane -R \; switch-client -T sticky

          # Cycle panes
          bind-key -T sticky o select-pane -t '{next}' \; switch-client -T sticky
          bind-key -T sticky O select-pane -t '{previous}' \; switch-client -T sticky

          # Cycle pane layouts
          bind-key -T sticky Space next-layout \; switch-client -T sticky

          # Pane splits
          bind-key -T sticky '|' split-window -h \; switch-client -T sticky
          bind-key -T sticky - split-window -v \; switch-client -T sticky

          # Pane resizing
          bind-key -T sticky C-h resize-pane -L 5 \; switch-client -T sticky
          bind-key -T sticky C-j resize-pane -D 5 \; switch-client -T sticky
          bind-key -T sticky C-k resize-pane -U 5 \; switch-client -T sticky
          bind-key -T sticky C-l resize-pane -R 5 \; switch-client -T sticky

          # Pane management
          bind-key -T sticky x kill-pane \; switch-client -T sticky
          bind-key -T sticky X confirm-before -p "Kill window #W? (y/n)" kill-window
          bind-key -T sticky z resize-pane -Z \; switch-client -T sticky

          # Swap panes
          bind-key -T sticky H swap-pane -U \; switch-client -T sticky
          bind-key -T sticky L swap-pane -D \; switch-client -T sticky

          # Pane selection
          bind-key -T sticky q display-panes \; switch-client -T sticky

          # Window navigation
          bind-key -T sticky n next-window \; switch-client -T sticky
          bind-key -T sticky p previous-window \; switch-client -T sticky

          bind-key -T sticky 1 select-window -t :1 \; switch-client -T sticky
          bind-key -T sticky 2 select-window -t :2 \; switch-client -T sticky
          bind-key -T sticky 3 select-window -t :3 \; switch-client -T sticky
          bind-key -T sticky 4 select-window -t :4 \; switch-client -T sticky
          bind-key -T sticky 5 select-window -t :5 \; switch-client -T sticky
          bind-key -T sticky 6 select-window -t :6 \; switch-client -T sticky
          bind-key -T sticky 7 select-window -t :7 \; switch-client -T sticky
          bind-key -T sticky 8 select-window -t :8 \; switch-client -T sticky
          bind-key -T sticky 9 select-window -t :9 \; switch-client -T sticky

          # Window management
          bind-key -T sticky c new-window \; switch-client -T sticky
          bind-key -T sticky , command-prompt -I "#W" "rename-window '%%'"
          bind-key -T sticky w choose-tree -Zw

          # Session management
          bind-key -T sticky s choose-tree -Zs
          bind-key -T sticky $ command-prompt -I "#S" "rename-session '%%'"
          bind-key -T sticky d detach-client

          # Utilities
          bind-key -T sticky R refresh-client \; switch-client -T sticky
          bind-key -T sticky G new-window -n 'lazygit' lazygit \; switch-client -T sticky

          # External popup
          bind-key -T sticky e display-popup \; switch-client -T sticky

          # Copy mode
          setw -g mode-keys vi

          bind v copy-mode
          bind -T copy-mode-vi y send -X copy-selection-and-cancel
          bind -T copy-mode-vi v send -X begin-selection
          bind -T copy-mode-vi Escape send -X cancel

          # Appearance
          set -g status-position top
          set -g status-interval 5
          set -g status-style 'fg=default bg=default'
          set -g message-style 'fg=default,bg=default'
          set -g message-command-style reverse

          set -g status-left '#{?#{==:#{client_key_table},sticky},#[bg=yellow]#[fg=black] STICKY #[default],} #S '

          set -g status-justify absolute-centre
          setw -g window-status-current-style 'fg=green bold bg=default'
          setw -g window-status-style 'fg=default'
          setw -g window-status-format "#I:#W"
          setw -g window-status-current-format "#I:#W"

          set -g pane-border-lines simple
          set -g pane-border-style fg=colour241
          set -g pane-active-border-style fg=colour39

          # Status toggle
          bind-key b set-option status
        '';
      in
      inputs.wrappers.wrappers.tmux.wrap {
        inherit pkgs;

        addFlag = [
          "-f"
          "${tmuxConf}"
        ];
      };
  };
}
