"title: toaststunt-map-bool-03";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP/BOOL syntax or map builtins.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: varies";
"returns: varies";

":bool_result_3(MIXED value) => BOOL";
"Called by ToastStunt examples to return a true BOOL value.";
{value} = args;
if (typeof(value) == BOOL)
  return value;
endif
return value ? true | false;
