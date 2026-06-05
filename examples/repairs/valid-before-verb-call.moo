" title: valid-before-verb-call";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" target:tell(message);";
" fixed:";
{target, message} = args;
if (valid(target))
  target:tell(message);
endif
