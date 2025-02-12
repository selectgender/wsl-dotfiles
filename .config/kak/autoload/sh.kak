# this is literally just the rc script with lines removed

hook global BufCreate .*\.((z|ba|c|k|mk)?(sh(rc|_profile|env)?|profile)) %{
	set-option buffer filetype sh
}

hook -group sh-highlight global WinSetOption filetype=sh %{
	add-highlighter window/sh ref sh
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/sh }
}

provide-module sh %§

add-highlighter shared/sh regions
add-highlighter shared/sh/code default-region group
add-highlighter shared/sh/arithmetic region -recurse \(.*?\( (\$|(?<=for)\h*)\(\( \)\) group
add-highlighter shared/sh/double_string region  %{(?<!\\)(?:\\\\)*\K"} %{(?<!\\)(?:\\\\)*"} group
add-highlighter shared/sh/single_string region %{(?<!\\)(?:\\\\)*\K'} %{'} fill string
add-highlighter shared/sh/expansion region -recurse (?<!\\)(?:\\\\)*\K\$\{ (?<!\\)(?:\\\\)*\K\$\{ \}|\n fill value
add-highlighter shared/sh/comment region (?<!\\)(?:\\\\)*(?:^|\h)\K# '$' fill comment
add-highlighter shared/sh/heredoc region -match-capture '<<-?\h*''?(\w+)''?' '^\t*(\w+)$' fill string

add-highlighter shared/sh/arithmetic/expansion ref sh/double_string/expansion
add-highlighter shared/sh/double_string/fill fill string

evaluate-commands %sh{
	# Generated with `compgen -k` in bash
	keywords="if then else elif fi case esac for select while until do done in
		  function time coproc"

	# Generated with `compgen -b` in bash
	builtins="alias bg bind break builtin caller cd command compgen complete
		  compopt continue declare dirs disown echo enable eval exec
		  exit export false fc fg getopts hash help history jobs kill
		  let local logout mapfile popd printf pushd pwd read readarray
		  readonly return set shift shopt source suspend test times trap
		  true type typeset ulimit umask unalias unset wait"

	join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

	# Highlight keywords
	printf %s\\n "add-highlighter shared/sh/code/ regex (?<!-)\b($(join "${keywords}" '|'))\b(?!-) 0:keyword"

	# Highlight builtins
	printf %s "add-highlighter shared/sh/code/builtin regex (?<!-)\b($(join "${builtins}" '|'))\b(?!-) 0:builtin"
}

add-highlighter shared/sh/code/operators regex [\[\]\(\)&|]{1,2} 0:operator
add-highlighter shared/sh/code/variable regex ((?<![-:])\b\w+)= 1:variable
add-highlighter shared/sh/code/alias regex \balias(\h+[-+]\w)*\h+([\w-.]+)= 2:variable
add-highlighter shared/sh/code/function regex ^\h*(\S+(?<!=))\h*\(\) 1:function

add-highlighter shared/sh/code/unscoped_expansion regex (?<!\\)(?:\\\\)*\K\$(\w+|#|@|\?|\$|!|-|\*) 0:value
add-highlighter shared/sh/double_string/expansion regex (?<!\\)(?:\\\\)*\K\$(\w+|#|@|\?|\$|!|-|\*|\{.+?\}) 0:value

§
