"title: utility-object-utils-owned-properties";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:owned_properties with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, ?OBJ owner";
"returns: LIST";
"notes: Shows caller_perms().wizard controlling whether an explicit owner argument is honored.";

":owned_properties(OBJ object, ?OBJ owner) => LIST";
"Return visible properties on object and ancestors owned by owner or caller_perms().";
{object, ?owner = caller_perms()} = args;
if (!caller_perms().wizard)
  owner = caller_perms();
endif
properties_found = {};
ancestor = object;
while (valid(ancestor))
  for prop in (properties(ancestor))
    info = `property_info(object, prop) ! E_PROPNF, E_PERM => 0';
    if (info && info[1] == owner)
      properties_found = {@properties_found, prop};
    endif
  endfor
  ancestor = parent(ancestor);
endwhile
return properties_found;
