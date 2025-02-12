# this is literally just the rc script with lines removed

hook global BufCreate (.*/)?(kakrc|.*\.kak) %{
	set-option buffer filetype kak
}

hook -group kak-highlight global WinSetOption filetype=kak %{
	require-module kak

	add-highlighter window/kakrc ref kakrc
	hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/kakrc }
}

provide-module kak %§

require-module sh

add-highlighter shared/kakrc regions
add-highlighter shared/kakrc/code default-region group
add-highlighter shared/kakrc/comment region (^|\h)\K# $ fill comment
add-highlighter shared/kakrc/double_string region -recurse %{(?<!")("")+(?!")} %{(^|\h)\K"} %{"(?!")} group
add-highlighter shared/kakrc/single_string region -recurse %{(?<!')('')+(?!')} %{(^|\h)\K'} %{'(?!')} group
add-highlighter shared/kakrc/shell1 region -recurse '\{' '(^|\h)\K%?%sh\{' '\}' ref sh
add-highlighter shared/kakrc/shell2 region -recurse '\(' '(^|\h)\K%?%sh\(' '\)' ref sh
add-highlighter shared/kakrc/shell3 region -recurse '\[' '(^|\h)\K%?%sh\[' '\]' ref sh
add-highlighter shared/kakrc/shell4 region -recurse '<'  '(^|\h)\K%?%sh<'  '>'  ref sh
add-highlighter shared/kakrc/shell5 region -recurse '\{' '(^|\h)\K-?shell-script(-completion|-candidates)?\h+%\{' '\}' ref sh
add-highlighter shared/kakrc/shell6 region -recurse '\(' '(^|\h)\K-?shell-script(-completion|-candidates)?\h+%\(' '\)' ref sh
add-highlighter shared/kakrc/shell7 region -recurse '\[' '(^|\h)\K-?shell-script(-completion|-candidates)?\h+%\[' '\]' ref sh
add-highlighter shared/kakrc/shell8 region -recurse '<'  '(^|\h)\K-?shell-script(-completion|-candidates)?\h+%<'  '>'  ref sh

evaluate-commands %sh{
	keywords="add-highlighter alias arrange-buffers buffer buffer-next buffer-previous catch
		  change-directory colorscheme debug declare-option declare-user-mode define-command complete-command
		  delete-buffer delete-buffer! echo edit edit! enter-user-mode evaluate-commands execute-keys
		  fail hook info kill kill! map nop on-key prompt provide-module quit quit!
		  remove-highlighter remove-hooks rename-buffer rename-client rename-session require-module
		  select set-face set-option set-register source trigger-user-hook try
		  unalias unmap unset-face unset-option update-option
		  write write! write-all write-all-quit write-quit write-quit!"

	attributes="global buffer window current
		    normal insert prompt goto view user object
		    number-lines show-matching show-whitespaces fill regex dynregex group flag-lines
		    ranges line column wrap ref regions region default-region replace-ranges"

	types="int bool str regex int-list str-list completions line-specs range-specs str-to-str-map"

	values="default black red green yellow blue magenta cyan white yes no false true"

	join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

	printf '%s\n' "add-highlighter shared/kakrc/code/keywords regex (?:\s|\A)\K($(join "${keywords}" '|'))(?:(?=\s)|\z) 0:keyword
		       add-highlighter shared/kakrc/code/attributes regex (?:\s|\A)\K($(join "${attributes}" '|'))(?:(?=\s)|\z) 0:attribute
		       add-highlighter shared/kakrc/code/types regex (?:\s|\A)\K($(join "${types}" '|'))(?:(?=\s)|\z) 0:type
		       add-highlighter shared/kakrc/code/values regex (?:\s|\A)\K($(join "${values}" '|'))(?:(?=\s)|\z) 0:value"
}

add-highlighter shared/kakrc/code/colors regex \b(rgb:[0-9a-fA-F]{6}|rgba:[0-9a-fA-F]{8})\b 0:value
add-highlighter shared/kakrc/code/numbers regex \b\d+\b 0:value

add-highlighter shared/kakrc/double_string/fill fill string
add-highlighter shared/kakrc/double_string/escape regex '""' 0:default+b
add-highlighter shared/kakrc/single_string/fill fill string
add-highlighter shared/kakrc/single_string/escape regex "''" 0:default+b

add-highlighter shared/kak ref kakrc

§
