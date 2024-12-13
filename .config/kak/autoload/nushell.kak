# ~90% of this shit is highlighted from sh.kak LMAO
# keyword list stolen from the treesitter impl

hook global BufCreate .*[.](nu) %{
	set-option buffer filetype nu
}

hook global WinSetOption filetype=nu %{
	require-module nu
	set-option window static_words %opt{nu_static_words}
}

hook -group nu-highlight global WinSetOption filetype=nu %{
	add-highlighter window/nu ref nu
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/nu }
}

provide-module nu %§
	add-highlighter shared/nu regions
	add-highlighter shared/nu/code default-region group
	add-highlighter shared/nu/double_string region '"' (?<!\\)(?:\\\\)*" fill string
	add-highlighter shared/nu/single_string region "'" (?<!\\)(?:\\\\)*' fill string
	add-highlighter shared/nu/comment region '#' $ fill comment

	evaluate-commands %sh{
		# sadly... have to use spaces here children,,,, `join` demands it...
		keywords="def alias export-env export extern module let let-env
                          mut const hide-env source source-env overlay register
                          loop while error do if else try catch match break
                          continue return"

		builtins="all ansi any append ast bits bytes cal cd char clear
                          collect columns compact complete config cp date debug
                          decode default detect dfr drop du each encode enumerate
                          every exec exit explain explore export-env fill filter
                          find first flatten fmt format from generate get glob
                          grid group group-by hash headers histogram history http
                          input insert inspect interleave into is-empty is-not-empty
                          is-terminal items join keybindings kill last length
                          let-env lines load-env ls math merge metadata mkdir
                          mktemp move mv nu-check nu-highlight open panic par-each
                          parse path plugin port prepend print ps query random
                          range reduce reject rename reverse rm roll rotate
                          run-external save schema select seq shuffle skip sleep
                          sort sort-by split split-by start stor str sys table
                          take tee term timeit to touch transpose tutor ulimit
                          uname uniq uniq-by update upsert url values view watch
                          where which whoami window with-env wrap zip"

		join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

		# Add the language's grammar to the static completion list
		printf %s\\n "declare-option str-list nu_static_words $(join "${keywords}" ' ') $(join "${builtins}" ' ')"

		# Highlight keywords
		printf %s\\n "add-highlighter shared/nu/code/ regex (?<!-)\b($(join "${keywords}" '|'))\b(?!-) 0:keyword"

		# Highlight builtins
		printf %s "add-highlighter shared/nu/code/builtin regex (?<!-)\b($(join "${builtins}" '|'))\b(?!-) 0:builtin"
	}

	add-highlighter shared/sh/code/operators regex [\[\]\(\)&|]{1,2} 0:operator
	add-highlighter shared/sh/code/variable regex ((?<![-:])\b\w+)= 1:variable
	add-highlighter shared/sh/code/alias regex \balias(\h+[-+]\w)*\h+([\w-.]+)= 2:variable
	add-highlighter shared/sh/code/function regex ^\h*(\S+(?<!=))\h*\(\) 1:function
§
