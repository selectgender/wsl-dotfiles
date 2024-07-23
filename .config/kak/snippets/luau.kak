set -add buffer snippets 'local' ',l' %{
  phantom-selection-clear;
	snippets-insert %{local ${}}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'type' ',t' %{
  phantom-selection-clear;
	snippets-insert %{type ${}}
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

set -add buffer snippets 'require' ',q' %{
  phantom-selection-clear;
	snippets-insert %{require(${})}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'if' ',i' %{
  phantom-selection-clear;
	snippets-insert \
%{if ${} then
        ${}
end}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};

set -add buffer snippets 'function' ',f' %{
  phantom-selection-clear;
	snippets-insert \
%{function ${}(${})
        ${}
end}
  phantom-selection-add-selection;
  phantom-selection-iterate-next
};
