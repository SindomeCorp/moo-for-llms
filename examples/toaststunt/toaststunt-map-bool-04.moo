"title: toaststunt-map-bool-04";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP/BOOL syntax or map builtins.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: varies";
"returns: varies";

":map_merge_4(MAP left, MAP right) => MAP";
"Called by ToastStunt examples to merge two maps.";
{left, right} = args;
for key in (mapkeys(right))
  left[key] = right[key];
endfor
return left;
