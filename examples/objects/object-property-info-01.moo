"title: object-property-info-01";
"dialect: portable";
"source: original";
"license: MIT";
"topic: objects";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Object, property, or verb introspection example.";

":property_owner_1(OBJ object, STR prop) => OBJ|ERR";
"Called by audit helpers to read a property owner with specific error fallback.";
{object, prop} = args;
info = `property_info(object, prop) ! E_PROPNF, E_PERM => E_PROPNF';
if (info == E_PROPNF)
  return E_PROPNF;
endif
return info[1];
