"title: chparent-with-rollback";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ object, OBJ new_parent";
"returns: INT|ERR";
"notes: Shows preserving the old parent so a failed chparent workflow can roll back.";

":chparent_with_rollback(OBJ object, OBJ new_parent) => INT|ERR";
"Called by migration tools that temporarily change object inheritance.";
{object, new_parent} = args;
if (!valid(object) || !valid(new_parent))
  return E_INVARG;
endif
old_parent = parent(object);
result = `chparent(object, new_parent) ! E_PERM, E_INVARG => E_PERM';
if (result == E_PERM)
  return result;
endif
if (!valid(parent(object)))
  `chparent(object, old_parent) ! E_PERM => 0';
  return E_INVARG;
endif
return 1;
