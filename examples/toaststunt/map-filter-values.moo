"title: toaststunt-map-filter-values";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP literal and mapkeys() builtin.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: MAP source, INT minimum";
"returns: MAP";
"notes: Shows filtering a native ToastStunt map by numeric value.";

":filter_values(MAP source, INT minimum) => MAP";
"Called by ToastStunt-only cache helpers to keep entries at or above minimum.";
{source, minimum} = args;
filtered = [];
for key in (mapkeys(source))
  if (source[key] >= minimum)
    filtered[key] = source[key];
  endif
endfor
return filtered;
