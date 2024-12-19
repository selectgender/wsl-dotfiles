set -add buffer snippets ',l' "local ";
set -add buffer snippets ',t' "type ";
set -add buffer snippets ',r' "return ";
set -add buffer snippets ',c' "continue ";
set -add buffer snippets ',e' "export ";
set -add buffer snippets ',b' "break";
set -add buffer snippets ',q' "require(";

set -add buffer snippets ',i' \
%{if $1 then
	$2
end};

set -add buffer snippets ',f' \
%{function $1($2)
	$3
end};

set -add buffer snippets ',n' \
%{for $1 = $2, $3 do
	$4
end};

set -add buffer snippets ',p' \
%{for $1, $2 in $3 do
	$4
end};

set -add buffer snippets ',w' \
%{while $1 do
	$2
end};

set -add buffer snippets ',u' \
%{repeat
	$2
until $1};

set -add buffer snippets ',C' \
%{--[[
	$1
]]};

set -add buffer snippets '\\p' "print("
set -add buffer snippets '\\w' "warn("
set -add buffer snippets '\\g' %{game:GetService("}
set -add buffer snippets '\\i' %{Instance.new("}

set -add buffer snippets '\\ti' "table.insert("
set -add buffer snippets '\\tr' "table.remove("
set -add buffer snippets '\\tf' "table.find("

set -add buffer snippets '\\vn' "Vector3.new($1, $2, $3)"
set -add buffer snippets '\\vz' "Vector3.zero"
set -add buffer snippets '\\vo' "Vector3.one"
set -add buffer snippets '\\vx' "Vector3.xAxis"
set -add buffer snippets '\\vy' "Vector3.yAxis"
set -add buffer snippets '\\vz' "Vector3.zAxis"

set -add buffer snippets '\\un' "UDim2.new($1, $2, $3, $4)"
set -add buffer snippets '\\uf' "UDim2.fromScale($1, $2)"
