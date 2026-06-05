"title: toaststunt-bool-map-guidance";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP and true BOOL values.";
"source: original";
"license: MIT";
"topic: toaststunt-differences";
"callable: programmatic";
"args: STR key";
"returns: BOOL";
"notes: Shows ToastStunt map and BOOL values as non-portable MOO code features.";

":has_flag(STR key) => BOOL";
"Called by ToastStunt-only helpers that store true boolean values in a MAP.";
{key} = args;
flags = ["enabled" -> true, "hidden" -> false];
return `flags[key] ! E_RANGE => false';
