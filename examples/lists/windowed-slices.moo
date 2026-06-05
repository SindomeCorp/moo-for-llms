"title: windowed-slices";
"dialect: portable";
"source: original";
"license: MIT";
"topic: lists";
"callable: programmatic";
"args: LIST values, INT size";
"returns: LIST|ERR";
"notes: Shows producing overlapping list windows using portable range slicing.";

":windowed_slices(LIST values, INT size) => LIST|ERR";
"Called by sequence helpers to return overlapping fixed-size windows.";
{values, size} = args;
if (typeof(values) != LIST || typeof(size) != INT || size < 1)
  return E_INVARG;
endif
windows = {};
limit = length(values) - size + 1;
for index in [1..limit]
  windows = {@windows, values[index..index + size - 1]};
endfor
return windows;
