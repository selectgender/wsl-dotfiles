# plagiarized from emacs god mode:
# https://github.com/emacsorphanage/god-mode

# i dont like pressing alt :(
# and i already have ctrl binded to caps lock

declare-option str-list god_alt_bindings \
	'f' 't' '/' 's' 'k' 'p' \
	'F' 'T' '?' 'R'

declare-option str-list god_hold_alt_bindings \
	'n' 'u' 'o' ',' \
	'N' 'U' 'O' '(' ')' 'C'

declare-user-mode god-mode-alt
declare-user-mode god-mode-hold-alt

evaluate-commands %sh{
	eval set -- "$kak_quoted_opt_god_alt_bindings"

	mappings=""

	while [ $# -ne 0 ]; do
		mappings="$mappings \n map global god-mode-alt $1 '<a-$1>'"

		shift 1
	done

	printf "$mappings"
}

evaluate-commands %sh{
	eval set -- "$kak_quoted_opt_god_hold_alt_bindings"

	mappings=""

	while [ $# -ne 0 ]; do
		mappings="$mappings \n map global god-mode-hold-alt $1 '<a-$1>:enter-user-mode god-mode-hold-alt<ret>'"

		shift 1
	done

	printf "$mappings"
}
