# plagiarized from occivink's implementation: https://github.com/occivink/kakoune-snippets/blob/master/snippets.kak
# and based on kkga's implementation: https://kkga.me/notes/kakoune-snippets

declare-option str-list snippets

declare-option -hidden regex snippets_triggers_regex "\A\z" # doing <a-k>\A\z<ret> will always fail

hook global WinSetOption 'snippets=$' %{
	set window snippets_triggers_regex "\A\z"
}

hook global WinSetOption 'snippets=.+$' %{
	set window snippets_triggers_regex %sh{
		eval set -- "$kak_quoted_opt_snippets"

		if [ $(($#%2)) -ne 0 ]; then printf '\A\z'; exit; fi

		result=""

		while [ $# -ne 0 ]; do
			if [ -n "$1" ]; then
				if [ -z "$result" ]; then
					result="$1"
				else
					result="$result|$1"
				fi
			fi

			shift 2
		done

		if [ -z "$result" ]; then
			printf '\A\z'
		else
			printf '(?:%s)' "$result"
		fi
	}
}

define-command snippets-expand-trigger -params ..1 %{
	eval -save-regs '/snc"' %{
		# -draft so that we don't modify anything in case of failure
		eval -draft %{
			# ideally early out in here to avoid going to the (expensive) shell scope
			eval %arg{1}
			# this shell scope generates a block that looks like this
			# except with single quotes instead of %{..}
			#
			# try %{
			#   reg / "\Atrig1\z"
			#   exec -draft <a-k><ret>d
			#   reg c "snipcommand1"
			# } catch %{
			#   reg / "\Atrig2\z"
			#   exec -draft <a-k><ret>d
			#   reg c "snipcommand2"
			# } catch %{
			#   ..
			# }

			eval %sh{
				quadrupleupsinglequotes() {
					rest="$1"

					while :; do
						beforequote="${rest%%"'"*}"
						if [ "$rest" = "$beforequote" ]; then
							printf %s "$rest"
							break
						fi
						printf "%s''''" "$beforequote"
						rest="${rest#*"'"}"
					done
				}

				eval set -- "$kak_quoted_opt_snippets"

				if [ $(($#%2)) -ne 0 ]; then exit; fi

				first=0

				while [ $# -ne 0 ]; do
					if [ -z "$1" ]; then
						shift 2
						continue
					fi

					if [ $first -eq 0 ]; then
						printf "try '\n"
						first=1
					else
						printf "' catch '\n"
					fi

					# put the trigger into %reg{/} as \Atrig\z
					printf "reg / ''\\\A"
					# we're at two levels of nested single quotes (one for try ".." catch "..", one for reg "..")
					# in the arbitrary user input (snippet trigger and snippet name)

					quadrupleupsinglequotes "$1"
					printf "\\\z''\n"
					printf "exec -draft <a-k><ret>d\n"
					printf "reg c ''"

					quadrupleupsinglequotes "$2"
					printf "''\n"
					shift 2
				done

				printf "'"
			}
			reg dquote %reg{c}
			exec P

			# replace leading tabs with the appropriate indent
			try %<
				reg dquote %sh<
					if [ $kak_opt_indentwidth -eq 0 ]; then
						printf '\t'
					else
						printf "%${kak_opt_indentwidth}s"
					fi
				>
				exec -draft '<a-s>s\A\t+<ret>s.<ret>R'
			>

			# align everything with the current line
			eval -draft -itersel -save-regs '"' %<
				try %<
					exec -draft -save-regs '/' '<a-s>),xs^\s+<ret>y'
					exec -draft '<a-s>)<a-,>P'
				>
			>
		}
	}
	reg / '\$\d'
}

hook global WinCreate .+ %{
	hook -group snippets-auto-expand window InsertChar .* %{
		try %{
			snippets-expand-trigger %{ # no need to save-regs '/', since expand-trigger does that for us
				reg / "(%opt{snippets_triggers_regex})|."
				exec ';<a-/><ret>'
				reg / "\A(%opt{snippets_triggers_regex})\z"
				exec '<a-k><ret>'
			}
		}
	}
}

# dont mind me,,, just mystical undocumented boilerplate that loads some
# snippets!

hook global WinSetOption filetype=asciidoc %{
	source '~/.config/kak/snippets/asciidoc.kak'
}
