" title: add-verb-doc-comments";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" {types, ?filter = \"\"} = args;";
" return filter ? $list_utils:assoc(filter, types) | types;";
" fixed:";
":filter_types(LIST types, ?STR filter) => LIST";
"Called by search helpers to optionally narrow a list of type rows by filter.";
{types, ?filter = ""} = args;
return filter ? $list_utils:assoc(filter, types) | types;
