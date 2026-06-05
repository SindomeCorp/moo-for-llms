" title: check-object-validity";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (obj)";
"   obj:tell(\"Ready.\");";
" endif";
" fixed:";
{obj} = args;
if (valid(obj))
  obj:tell("Ready.");
endif
