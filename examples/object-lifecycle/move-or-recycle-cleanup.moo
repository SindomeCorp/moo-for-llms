"title: move-or-recycle-cleanup";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ object, OBJ destination";
"returns: INT|ERR";
"notes: Shows cleanup when move() fails after an object was freshly created.";

":move_or_recycle_cleanup(OBJ object, OBJ destination) => INT|ERR";
"Called by builders after creating an object that must be moved into place.";
{object, destination} = args;
if (!valid(object) || !valid(destination))
  return E_INVARG;
endif
move_result = `move(object, destination) ! E_PERM, E_INVARG => E_PERM';
if (move_result == E_PERM)
  recycle(object);
  return E_PERM;
endif
return 1;
