"title: recycler-aware-list-filter";
"dialect: portable";
"source: original";
"license: MIT";
"topic: objects";
"callable: programmatic";
"args: LIST objects";
"returns: LIST";
"notes: LambdaCore-style recycler-aware object validity filter.";

":valid_objects(LIST objects) => LIST";
"Called by object-list helpers on cores where $recycler:valid differs from valid().";
{objects} = args;
result = {};
for object in (objects)
  if ($recycler:valid(object))
    result = {@result, object};
  endif
endfor
return result;
