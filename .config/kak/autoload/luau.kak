define-command lune-serve %{
	nop %sh{
		tmux new-window "lune run serve"
	}
}

# requires you to have a separate analysis script
define-command lune-analyze %{
	nop %sh{
		tmux split-window "while true; do lune run analyze; read -s -k '?Press any key to reanalyze'; clear; done"
	}
}

hook global BufCreate .*[.](luau) %{
	set-option buffer filetype luau
}

hook global WinSetOption filetype=luau %{
	require-module lua
	require-module luau

	add-highlighter window/luau ref luau
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/luau }

	source '~/.config/kak/snippets/luau.kak'

	set-option buffer comment_line "--"

	map -docstring 'runs lune analyze script' buffer language a ':lune-analyze<ret>'
	map -docstring 'runs lune analyze script' buffer language s ':lune-serve<ret>'
}

provide-module luau %§
	add-highlighter shared/luau regions
	add-highlighter shared/luau/code default-region group
	add-highlighter shared/luau/raw_string  region -match-capture   '\[(=*)\[' '\](=*)\]' fill string
	add-highlighter shared/luau/raw_comment region -match-capture '--\[(=*)\[' '\](=*)\]' fill comment
	add-highlighter shared/luau/double_string region '"'   (?<!\\)(?:\\\\)*" fill string
	add-highlighter shared/luau/single_string region "'"   (?<!\\)(?:\\\\)*' fill string
	add-highlighter shared/luau/literal       region "`"  (?<!\\)(\\\\)*`    group
	add-highlighter shared/luau/comment       region '--'  $                 fill comment

	add-highlighter shared/luau/code/variable regex \b\w*\b 0:variable # Everything in Lua is a variable!
	add-highlighter shared/luau/code/function_declaration regex \b(?:function\h+)(?:\w+\h*\.\h*)*([a-zA-Z_]\w*)\( 1:function
	add-highlighter shared/luau/code/function_call regex \b([a-zA-Z_]\w*)\h*(?=[\(\{]) 1:function
	add-highlighter shared/luau/code/keyword regex \b(break|continue|do|else|elseif|end|export|for|function|if|in|local|repeat|return|then|until|while|type)\b 0:keyword
	add-highlighter shared/luau/code/type regex \b(any|nil|string|number|boolean|thread|userdata|vector|buffer)\b 0:type
	add-highlighter shared/luau/code/value regex \b(false|nil|true|self|[0-9]+(:?\.[0-9])?(:?[eE]-?[0-9]+)?|0x[0-9a-fA-F])\b 0:value
	add-highlighter shared/luau/code/symbolic_operator regex (\+|-|\*|/|%|\^|==?|~=|<=?|>=?|\.\.|\.\.\.|#) 0:operator
	add-highlighter shared/luau/code/keyword_operator regex \b(and|or|not)\b 0:operator
	add-highlighter shared/luau/code/module regex \b(_G|_ENV)\b 0:module
	add-highlighter shared/luau/code/attribute regex \B(<[a-zA-Z_]\w*>)\B 0:attribute
	add-highlighter shared/luau/code/label regex \s(::\w*::) 1:meta
	add-highlighter shared/luau/code/goto_label regex "\bgoto (\w*)\b" 1:meta
§
