"title: utility-list-utils-map-prop";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:map_property with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST objects, STR property, ?MIXED missing";
"returns: LIST";
"notes: Shows intentional delegation to caller_perms() before reading the same property from several objects.";

":map_property(LIST objects, STR property, ?MIXED missing) => LIST";
"Return the value of property on each object, substituting missing when supplied.";
{objects, property, ?missing = E_PROPNF} = args;
set_task_perms(caller_perms());
result = {};
for object in (objects)
  value = `object.(property) ! E_PROPNF => missing';
  result = {@result, value};
endfor
return result;
