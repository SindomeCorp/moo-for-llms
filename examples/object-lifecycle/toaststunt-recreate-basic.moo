"title: toaststunt-recreate-basic";
"dialect: toaststunt";
"dialect_reason: Uses the ToastStunt recreate() builtin for object lifecycle mutation.";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ object, OBJ new_parent";
"returns: INT|ERR";
"notes: Shows ToastStunt-specific recreate() guarded by caller permissions.";

":recreate_as(OBJ object, OBJ new_parent) => INT|ERR";
"Called by administrative lifecycle tools to recreate an object under a new parent.";
{object, new_parent} = args;
if (!valid(object) || !valid(new_parent))
  return E_INVARG;
elseif (!caller_perms().wizard && !$perm_utils:controls(caller_perms(), object))
  return E_PERM;
endif
result = `recreate(object, new_parent) ! E_PERM, E_INVARG, E_QUOTA';
return typeof(result) == ERR ? result | 1;
