# this is literally just the rc script with lines removed

define-command -hidden -params 2.. tmux-terminal-impl %{
	evaluate-commands %sh{
		tmux=${kak_client_env_TMUX:-$TMUX}

		if [ -z "$tmux" ]; then
			echo "fail 'This command is only available in a tmux session'"
			exit
		fi

		tmux_args="$1"

		if [ "${1%%-*}" = split ]; then
			tmux_args="$tmux_args -t ${kak_client_env_TMUX_PANE}"
		elif [ "${1%% *}" = new-window ]; then
			session_id=$(tmux display-message -p -t ${kak_client_env_TMUX_PANE} '#{session_id}')
			tmux_args="$tmux_args -t $session_id"
		fi

		shift

		# ideally we should escape single ';' to stop tmux from interpreting it as a new command
		# but that's probably too rare to care
		if [ -n "$TMPDIR" ]; then
			TMUX=$tmux tmux $tmux_args env TMPDIR="$TMPDIR" "$@"
		else
			TMUX=$tmux tmux $tmux_args "$@"
		fi
	}
}

define-command tmux-split-vertical %{
	tmux-terminal-impl 'split-window -v' kak -c %val{session}
}

define-command tmux-split-horizontal %{
	tmux-terminal-impl 'split-window -h' kak -c %val{session}
}

define-command tmux-terminal-window -params 1 %{
    tmux-terminal-impl 'new-window' %arg{@}
}
