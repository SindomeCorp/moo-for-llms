" title: move-with-checks";
" dialect: portable";
" source: original";
" license: MIT";
" topic: objects";
" callable: programmatic";

":move_with_checks(OBJ what, OBJ where) => INT|ERR";
"Called by movement code to validate objects and avoid obvious containment loops before move().";
{what, where} = args;
if (!valid(what) || !valid(where))
  return E_INVARG;
elseif ($object_utils:contains(what, where))
  return E_RECMOVE;
endif

result = `move(what, where) ! E_PERM, E_NACC, E_RECMOVE, E_INVARG';
return typeof(result) == ERR ? result | 1;
