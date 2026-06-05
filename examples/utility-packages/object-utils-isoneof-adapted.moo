"title: utility-object-utils-isoneof";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:isoneof with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, LIST ancestors";
"returns: INT";
"notes: Shows walking parent() until the root is no longer valid.";

":isoneof(OBJ object, LIST ancestors) => INT";
"Called by type guards to test whether an object inherits from any object in a list.";
{object, ancestors} = args;
while (valid(object))
  if (object in ancestors)
    return 1;
  endif
  object = parent(object);
endwhile
return 0;
