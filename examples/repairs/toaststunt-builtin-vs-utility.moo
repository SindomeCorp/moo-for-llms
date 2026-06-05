" title: toaststunt-builtin-vs-utility";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippets are shown in comments; executable body is the portable corrected version";

" bad:";
" subset = slice(items, 2, 4);";
" ordered = sort(items);";
" fixed:";
{items} = args;
subset = $list_utils:slice(items, 2, 4);
ordered = $list_utils:sort(items);
return {subset, ordered};
