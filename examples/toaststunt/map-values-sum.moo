"title: toaststunt-map-values-sum";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt mapvalues() builtin.";
"source: original";
"license: MIT";
"topic: maps";
"callable: programmatic";
"args: MAP counts";
"returns: INT";
"notes: Shows iterating native map values without converting through an alist.";

":map_values_sum(MAP counts) => INT";
"Called by ToastStunt-only analytics helpers to total count values.";
{counts} = args;
total = 0;
for value in (mapvalues(counts))
  total = total + value;
endfor
return total;
