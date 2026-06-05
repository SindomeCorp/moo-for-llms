"title: toaststunt-map-bool-02";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP/BOOL syntax or map builtins.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: varies";
"returns: varies";

":map_keys_2(MAP data) => LIST";
"Called by ToastStunt examples to return map keys.";
{data} = args;
return mapkeys(data);
