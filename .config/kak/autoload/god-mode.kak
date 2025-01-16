# plagiarized from emacs god mode:
# https://github.com/emacsorphanage/god-mode
#
# credits:
# to screwtape for telling me about `:on-key` :)
# to taupiqueur_/alexherbo2 for telling me about -lock functionality :)

declare-option str-list god_alt_bindings \
    'n' 'u' 'o' ',' 's' 'p' '.' \
    'N' 'U' 'O' '(' ')' 'C' 'R'

declare-option str-list god_alt_occurrence_bindings \
    'f' 't' \
    'F' 'T'

declare-option str-list god_alt_prompt_bindings \
    '/' 'k' \
    '?' 'K'

declare-user-mode god-mode

define-command -hidden god-occurrence-bind -params 1 %{
    on-key %{ execute-keys "<a-%arg{1}>" %val{key} ":enter-user-mode god-mode<ret>" }
}

evaluate-commands %sh{
    mappings=""

    eval set -- "$kak_quoted_opt_god_alt_bindings"

    while [ $# -ne 0 ]; do
        mappings="$mappings \n map global god-mode $1 '<a-$1>:enter-user-mode god-mode<ret>'"

        shift 1
    done

    eval set -- "$kak_quoted_opt_god_alt_occurrence_bindings"

    while [ $# -ne 0 ]; do
        mappings="$mappings \n map global god-mode $1 ':god-occurrence-bind $1<ret>'"

        shift 1
    done

    eval set -- "$kak_quoted_opt_god_alt_prompt_bindings"

    while [ $# -ne 0 ]; do
        mappings="$mappings \n map global god-mode $1 '<a-$1>'"

        shift 1
    done

    printf "$mappings"
}
