" title: scatter-defaults";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" {required, ?optional} = args;";
" fixed:";
{required, ?optional = 0} = args;
return {required, optional};
