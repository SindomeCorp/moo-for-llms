"title: create-child-owned";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ parent, STR name";
"returns: OBJ|ERR";
"notes: Shows create(parent, caller_perms()) with explicit permission and quota error handling.";

":create_child_owned(OBJ parent, STR name) => OBJ|ERR";
"Called by setup helpers to create a named child owned by caller permissions.";
{parent, name} = args;
if (!valid(parent))
  return E_INVARG;
endif
child = `create(parent, caller_perms()) ! E_PERM, E_QUOTA, E_INVARG';
if (typeof(child) == ERR)
  return child;
endif
name_result = `child.name = name ! E_PERM, E_INVARG';
return typeof(name_result) == ERR ? name_result | child;
