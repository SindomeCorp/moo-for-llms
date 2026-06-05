" title: guard-args-index";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" value = args[2];";
" player:tell(value);";
" fixed:";
if (length(args) >= 2)
  value = args[2];
else
  value = "";
endif

player:tell(tostr(value));
