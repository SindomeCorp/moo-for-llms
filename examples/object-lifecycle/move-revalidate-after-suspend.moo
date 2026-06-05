"title: move-revalidate-after-suspend";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ thing, OBJ destination";
"returns: INT|ERR";
"notes: Shows revalidating objects after suspend before lifecycle mutation.";

":move_after_wait(OBJ thing, OBJ destination) => INT|ERR";
"Called by delayed movement helpers; revalidates object state after yielding.";
{thing, destination} = args;
if (!valid(thing) || !valid(destination))
  return E_INVARG;
endif
suspend(1);
if (!valid(thing) || !valid(destination))
  return E_INVARG;
elseif ($object_utils:contains(thing, destination))
  return E_RECMOVE;
endif
result = `move(thing, destination) ! E_NACC, E_PERM, E_RECMOVE';
return typeof(result) == ERR ? result | 1;
