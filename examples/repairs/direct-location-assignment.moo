" title: direct-location-assignment";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" target.location = destination;";
" destination.contents = setadd(destination.contents, target);";
" fixed:";
":move_target(OBJ target, OBJ destination) => INT|ERR";
"Called by movement code; uses move() so accept, enterfunc, and exitfunc behavior can run.";
{target, destination} = args;
if (!valid(target) || !valid(destination))
  return E_INVARG;
elseif ($object_utils:contains(target, destination))
  return E_RECMOVE;
endif

result = `move(target, destination) ! E_PERM, E_NACC, E_RECMOVE, E_INVARG';
return typeof(result) == ERR ? result | 1;
