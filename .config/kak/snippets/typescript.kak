set -add buffer snippets 'const' ',c' %{
  phantom-selection-clear;
	snippets-insert %{const ${}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'let' ',l' %{
  phantom-selection-clear;
	snippets-insert %{let ${}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'return' ',r' %{
  phantom-selection-clear;
	snippets-insert %{return ${}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'export' ',e' %{
  phantom-selection-clear;
	snippets-insert %{export ${}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'interface' ',i' %{
  phantom-selection-clear;
	snippets-insert \
%{interface ${} {
  ${}
}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'function' ',f' %{
  phantom-selection-clear;
	snippets-insert \
%{function ${}(${}) {
  ${}
}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'anonymous function' ',=' %{
  phantom-selection-clear;
	snippets-insert %{(${}) => {}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};
