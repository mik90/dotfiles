{ config, pkgs, ... }:
{
  programs.bash = {
    interactiveShellInit = builtins.readFile ./cdu.bash;
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    historyLimit = 5000;
    baseIndex = 1;
    shortcut = "a";
    terminal = "screen-256color";
    extraConfig = ''
      # A lot of these settings are pulled from https://github.com/gpakosz/.tmux

      # Allow scrolling
      set -g mouse on

      bind Enter copy-mode # enter copy mode

      run -b 'tmux bind -t vi-copy v begin-selection 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi v send -X begin-selection 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy C-v rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi C-v send -X rectangle-toggle 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy y copy-selection 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi y send -X copy-selection-and-cancel 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy Escape cancel 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi Escape send -X cancel 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy H start-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi H send -X start-of-line 2> /dev/null || true'
      run -b 'tmux bind -t vi-copy L end-of-line 2> /dev/null || true'
      run -b 'tmux bind -T copy-mode-vi L send -X end-of-line 2> /dev/null || true'

      
      # Ripped from https://unix.stackexchange.com/a/318285
      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      bind -n WheelDownPane select-pane -t= \; send-keys -M
      bind -n C-WheelUpPane select-pane -t= \; copy-mode -e \; send-keys -M
      bind -T copy-mode-vi    C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-vi    C-WheelDownPane send-keys -X halfpage-down
      bind -T copy-mode-emacs C-WheelUpPane   send-keys -X halfpage-up
      bind -T copy-mode-emacs C-WheelDownPane send-keys -X halfpage-down

      # Use vi bindings in copy mode
      setw -g mode-keys vi
      # Update default binding of `Enter` to also use copy-pipe
      unbind -T copy-mode-vi Enter
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection c"
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
      
      bind Enter copy-mode # enter copy mode

      bind b list-buffers  # list paste buffers
      bind p paste-buffer  # paste from the top paste buffer
      bind P choose-buffer # choose which buffer to paste from

      # split current window horizontally
      bind - split-window -v
      bind _ split-window -v
      # split current window vertically
      bind | split-window -h
    '';
  };
}
