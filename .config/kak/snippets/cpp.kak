set -add buffer snippets ',un' "using namespace ";

set -add buffer snippets ',r' "return ";

set -add buffer snippets ',f' \
%{$1 $2($3) {
	$0
}};

set -add buffer snippets ',n' \
%{for (int $1 = $2; $1 < $3; $1++) {
	$0
}};

set -add buffer snippets ',w' \
%{while ($1) {
	$0
}}

set -add buffer snippets ',c' \
%{class $1 {
private:
	$2

public:
	$3
}}

set -add buffer snippets ',#' \
%{#ifndef $1_H
#define $1_H

$0

#endif
}

set -add buffer snippets ',C' \
%{/* $1.cpp - $2
   Author:  $3
   Module:  $4
   Project: $5
   Problem Statement: $6

   Algorithm / Plan:
         1. $7
*/}

set -add buffer snippets '\\i' "#include <";
