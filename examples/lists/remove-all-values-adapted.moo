"title: remove-all-values-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:setremove_all with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: lists";
"callable: programmatic";
"args: LIST values, MIXED target";
"returns: LIST";
"notes: Shows splice assignment to remove all matching list elements.";

":remove_all_values(LIST values, MIXED target) => LIST";
"Called by parsers to remove all occurrences of a filler value from a list.";
{values, target} = args;
while (index = target in values)
  values[index..index] = {};
endwhile
return values;
