"title: create-owned-initialize";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ parent, STR name";
"returns: OBJ|ERR";
"notes: Shows create(), ownership assignment, and cleanup if initialization fails.";

":create_owned_initialize(OBJ parent, STR name) => OBJ|ERR";
"Called by builder tools to create a child object and assign a display name.";
{parent, name} = args;
if (!valid(parent) || typeof(name) != STR || !length(name))
  return E_INVARG;
endif
child = `create(parent) ! E_PERM => E_PERM';
if (child == E_PERM)
  return child;
endif
try
  child.name = name;
except (E_PERM, E_PROPNF)
  recycle(child);
  return E_PERM;
endtry
return child;
