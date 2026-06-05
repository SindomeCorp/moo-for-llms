" title: expand-short-utility-refs";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" row = $lu:assoc(key, rows);";
" ok = $ou:has_verb(obj, \"look\");";
" fixed:";
{key, rows, obj} = args;
row = $list_utils:assoc(key, rows);
ok = $object_utils:has_verb(obj, "look");
return {row, ok};
