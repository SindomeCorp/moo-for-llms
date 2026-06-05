" title: create-owned-child";
" dialect: portable";
" source: original";
" license: MIT";
" topic: objects";
" callable: programmatic";

":create_owned_child(OBJ parent, STR name) => OBJ|ERR";
"Called by setup code to create a child object using the caller's effective permissions.";
{parent, name} = args;
if (!valid(parent))
  return E_INVARG;
elseif (!caller_perms().programmer)
  return E_PERM;
endif

child = `create(parent, caller_perms()) ! E_PERM, E_QUOTA, E_INVARG';
if (typeof(child) == ERR)
  return child;
endif

child.name = name;
return child;
