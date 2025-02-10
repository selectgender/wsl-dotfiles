# this is literally just the rc script with lines removed

declare-option str comment_line '#'

define-command align-selections-left -docstring 'extend selections to the left to align with the leftmost selected column' %{
	evaluate-commands %sh{
		leftmost_column=$(echo "$kak_selections_desc" | tr ' ' '\n' | cut -d',' -f1 | cut -d'.' -f2 | sort -n | head -n1)
		aligned_selections=$(echo "$kak_selections_desc" | sed -E "s/\.[0-9]+,/.$leftmost_column,/g")
		echo "select $aligned_selections"
	}
}

define-command comment-line -docstring '(un)comment selected lines using line comments' %{
	evaluate-commands %sh{
		if [ -z "${kak_opt_comment_line}" ]; then
			echo "fail \"The 'comment_line' option is empty, could not comment the line\""
		fi
	}

	evaluate-commands -save-regs '"/' -draft %{
		# Select the content of the lines, without indentation
		execute-keys <a-s>gi<a-l>

		try %{
			# Keep non-empty lines
			execute-keys <a-K>\A\s*\z<ret>
		}

		try %{
			set-register / "\A\Q%opt{comment_line}\E\h?"

			try %{
				# See if there are any uncommented lines in the selection
				execute-keys -draft <a-K><ret>
				# There are uncommented lines, so comment everything
				set-register '"' "%opt{comment_line} "
				align-selections-left
				execute-keys P
			} catch %{
				# All lines were commented, so uncomment everything
				execute-keys s<ret>d
			}
		}
	}
}
