"title: explicit-container-type";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP type and empty map literal [].";
"source: original";
"license: MIT";
"topic: common-mistakes";
"callable: programmatic";
"args: MIXED cache";
"returns: MAP";
"notes: Shows avoiding falsey empty-container checks by using an explicit MAP type check.";

":ensure_map(MIXED cache) => MAP";
"Called by cache helpers to preserve empty maps instead of treating them as uninitialized.";
{cache} = args;
if (typeof(cache) != MAP)
  cache = [];
endif
return cache;
