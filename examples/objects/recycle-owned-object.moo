" title: recycle-owned-object";
" dialect: portable";
" source: original";
" license: MIT";
" topic: objects";
" callable: programmatic";

":recycle_owned_object(OBJ target) => INT|ERR";
"Called by cleanup code to recycle an object only when caller permissions control it.";
{target} = args;
if (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(caller_perms(), target))
  return E_PERM;
endif

result = `recycle(target) ! E_PERM, E_INVARG';
return typeof(result) == ERR ? result | 1;
