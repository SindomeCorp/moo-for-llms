" title: try-except-syntax";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippets are shown in comments; executable body is the corrected version";

" bad:";
" try {";
"   value = toint(args[1]);";
" } catch (E_INVARG) {";
"   value = 0;";
" }";
" fixed:";
try
  value = toint(args[1]);
except (E_INVARG, E_TYPE)
  value = 0;
endtry

return value;
