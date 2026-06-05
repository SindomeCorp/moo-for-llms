"title: utility-object-utils-ancestors";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:ancestors with permission from Sindome (www.sindome.org); VMS metadata removed, short utility refs expanded, and ToastStunt ancestors() avoided for portability.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ ...";
"returns: LIST";
"notes: Shows walking parent() chains and de-duplicating ancestors.";

":ancestors(OBJ ...) => LIST";
"Return all valid ancestors of the supplied objects, with duplicates removed.";
result = {};
for object in (args)
  current = parent(object);
  while (valid(current))
    $command_utils:suspend_if_needed(0);
    result = setadd(result, current);
    current = parent(current);
  endwhile
endfor
return result;
