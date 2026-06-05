" title: api-return-error";
" dialect: portable";
" source: original";
" license: MIT";
" topic: errors";
" callable: programmatic";

":set_count(INT count) => INT|ERR";
"Called by other verbs; returns E_TYPE or E_PERM instead of printing command feedback.";
{count} = args;
if (typeof(count) != INT)
  return E_TYPE;
elseif (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif

this.count = count;
return 1;
