" title: api-raise-error";
" dialect: portable";
" source: original";
" license: MIT";
" topic: errors";
" callable: programmatic";

":require_valid_target(OBJ target) => OBJ";
"Called by other verbs; raises when the caller should not continue after failure.";
{target} = args;
if (!valid(target))
  raise(E_INVARG, "target is not valid");
elseif (!$perm_utils:controls(caller_perms(), target))
  raise(E_PERM, "caller does not control target");
endif

return target;
