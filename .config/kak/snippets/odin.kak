set -add buffer snippets ',i' 'import "';

set -add buffer snippets ',p' \
%{:: proc() {
	$1
}};

set -add buffer snippets '\\p' "package "
