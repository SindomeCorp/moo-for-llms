" title: deep-nesting";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (valid(user))";
"   if (user.enabled)";
"     for item in (items)";
"       if (item.active)";
"         results = {@results, item};";
"       endif";
"     endfor";
"   endif";
" endif";
" fixed:";
":active_items_for(OBJ user, LIST items) => LIST";
"Called by filtering helpers; uses early returns and a shallow loop.";
{user, items} = args;
if (!valid(user) || !user.enabled)
  return {};
endif

results = {};
for item in (items)
  if (item.active)
    results = {@results, item};
  endif
endfor

return results;
