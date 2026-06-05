" title: optional-arg-destructuring";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" {name, count} = args;";
" fixed:";
{name, ?count = 1} = args;
return {name, count};
