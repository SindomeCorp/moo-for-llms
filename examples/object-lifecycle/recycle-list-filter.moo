"title: recycle-list-filter";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: LIST objects";
"returns: LIST";
"notes: Shows filtering a list to valid objects before lifecycle operations.";

":valid_objects_only(LIST objects) => LIST";
"Called before batch lifecycle operations to discard invalid object references.";
{objects} = args;
result = {};
for object in (objects)
  if (typeof(object) == OBJ && valid(object))
    result = {@result, object};
  endif
endfor
return result;
