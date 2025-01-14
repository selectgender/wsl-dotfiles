define-command fuzzy-edit %{
	evaluate-commands %sh{
		if [ -z "${kak_client_env_TMUX}" ]; then
			printf 'fail "client was not started under tmux"\n'
			exit
		fi

		TMUX="${kak_client_env_TMUX}"

		FILE=$(fd . --type f | fzf --tmux)

		if [ -n "$FILE" ]; then
			printf 'edit "%s"\n' "$FILE"
		fi
	}
}

# junegunn is a fucking saint
# https://junegunn.github.io/fzf/tips/ripgrep-integration/
define-command fuzzy-grep %{
	evaluate-commands %sh{
		if [ -z "${kak_client_env_TMUX}" ]; then
			printf 'fail "client was not started under tmux"\n'
			exit
		fi

		TMUX="${kak_client_env_TMUX}"

		RELOAD='reload:rg --column --color=always --smart-case {q} || :'

		RESULT=$(fzf --tmux --disabled --ansi \
			     --bind "start:$RELOAD" --bind "change:$RELOAD")

		LOCATION=$(echo $RESULT | awk -F ':' '{print $1, $2, $3}')

		if [ -n "$LOCATION" ]; then
			printf "edit $LOCATION\n"
		fi
	}
}

define-command fuzzy-buffer %{
	evaluate-commands %sh{
		if [ -z "${kak_client_env_TMUX}" ]; then
			printf 'fail "client was not started under tmux"\n'
			exit
		fi

		TMUX="${kak_client_env_TMUX}"

		eval "set -- ${kak_quoted_buflist:?}"

		# just do an iteration ahead of time so that it doesn't have
		# that one annoying blank file
		buffers="$1"
		shift

		while [ $# -gt 0 ]; do
			buffers="$1
$buffers"
			shift
		done

		RESULT=$(echo "$buffers" | fzf --tmux)

		if [ -n "$RESULT" ]; then
			printf "buffer $RESULT\n"
		fi
	}
}

define-command fuzzy-delete-buffer %{
	evaluate-commands %sh{
		if [ -z "${kak_client_env_TMUX}" ]; then
			printf 'fail "client was not started under tmux"\n'
			exit
		fi

		TMUX="${kak_client_env_TMUX}"

		eval "set -- ${kak_quoted_buflist:?}"

		buffers="$1"
		shift

		while [ $# -gt 0 ]; do
			buffers="$1
$buffers"
			shift
		done

		RESULT=$(echo "$buffers" | fzf --tmux)

		if [ -n "$RESULT" ]; then
			printf "delete-buffer $RESULT\n"
		fi
	}
}
