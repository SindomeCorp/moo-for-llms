"title: utility-string-utils-names-of";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:names_of with permission from Sindome (www.sindome.org); source-control metadata removed and short refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST objects";
"returns: STR";
"notes: Shows formatting valid object names from a list while skipping invalid values.";

":names_of(LIST objects) => STR";
"Return a space-separated string of names for valid objects in objects.";
{objects} = args;
names = {};
for item in (objects)
  if (typeof(item) == OBJ && valid(item))
    names = {@names, `item:name() ! E_VERBNF => item.name'};
  endif
endfor
return $string_utils:from_list(names, " ");
