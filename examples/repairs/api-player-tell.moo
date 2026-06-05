" title: api-player-tell";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (!valid(target))";
"   player:tell(\"Invalid target.\");";
"   return;";
" endif";
" fixed:";
":set_target(OBJ target) => INT|ERR";
"Called by other verbs; returns errors to the caller instead of printing player feedback.";
{target} = args;
if (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif

this.target = target;
return 1;
