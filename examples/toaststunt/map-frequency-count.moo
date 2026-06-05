"title: map-frequency-count";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt MAP literal and map indexing.";
"source: original";
"license: MIT";
"topic: toaststunt";
"callable: programmatic";
"args: LIST values";
"returns: MAP";
"notes: ToastStunt-specific frequency table using native MAP values.";

":frequency_map(LIST values) => MAP";
"Called by ToastStunt-only analytics helpers that can use native map storage.";
{values} = args;
counts = [];
for value in (values)
  counts[value] = `counts[value] ! E_RANGE => 0' + 1;
endfor
return counts;
