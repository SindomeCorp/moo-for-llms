" title: if-assignment";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (target = this.location)";
"   return 1;";
" endif";
" fixed:";
":is_here(OBJ target) => INT";
"Called by matching helpers to check whether target is in this location.";
{target} = args;
if (target == this.location)
  return 1;
endif

return 0;
