set -add buffer snippets ',r' 'return '
set -add buffer snippets ',c' 'continue;'

set -add buffer snippets ',i' \
%{if ($1) {
	$0
}}

set -add buffer snippets ',e' \
%{else ($1) {
	$0
}}

set -add buffer snippets ',f' \
%{for (int $1 = 0; $1 < $2; $1++) {
	$0
}}

set -add buffer snippets ',w' \
%{while ($1) {
	$0
}}

set -add buffer snippets ',d' \
%{do {
	$0
} while ($1)}

set -add buffer snippets ',C' \
%{/*
	$1.c

	$0
*/}

set -add buffer snippets ',S' \
%{#include <stdio.h>

int main(int argc, char **argv) {
	return 0;
}}

set -add buffer snippets '\\p' 'printf("'
