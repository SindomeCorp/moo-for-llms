"title: bool-result-helper";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt BOOL constants true and false.";
"source: original";
"license: MIT";
"topic: toaststunt";
"callable: programmatic";
"args: MAP flags, STR key";
"returns: BOOL";
"notes: ToastStunt-specific boolean result from a MAP-backed flag table.";

":flag_enabled(MAP flags, STR key) => BOOL";
"Called by ToastStunt-only helpers that store true BOOL values in MAPs.";
{flags, key} = args;
if (typeof(flags) != MAP)
  return false;
endif
return `flags[key] ! E_RANGE => false' == true;
