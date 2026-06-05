"title: stable-partition";
"dialect: portable";
"source: original";
"license: MIT";
"topic: lists";
"callable: programmatic";
"args: LIST values, LIST keepers";
"returns: LIST";
"notes: Shows stable partitioning without losing original order.";

":stable_partition(LIST values, LIST keepers) => LIST";
"Called by filters that need matching values before non-matching values.";
{values, keepers} = args;
matches = {};
misses = {};
for value in (values)
  if (value in keepers)
    matches = {@matches, value};
  else
    misses = {@misses, value};
  endif
endfor
return {@matches, @misses};
