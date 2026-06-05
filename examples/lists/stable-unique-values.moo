"title: stable-unique-values";
"dialect: portable";
"source: original";
"license: MIT";
"topic: lists";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Preserves first-seen order while removing duplicates.";

":stable_unique(LIST values) => LIST";
"Called by normalization helpers that need deterministic first-seen ordering.";
{values} = args;
result = {};
for value in (values)
  if (!(value in result))
    result = {@result, value};
  endif
endfor
return result;
