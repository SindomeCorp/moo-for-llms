"title: algorithm-list-insertion-sort-permutation";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:sort with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST values, ?LIST keys";
"returns: LIST";
"notes: Shows sorting keys while applying the same permutation to a value list.";

":sort_by_keys(LIST values, ?LIST keys) => LIST";
"Called by ranking helpers to sort values using a parallel key list.";
{values, ?keys = values} = args;
sorted_keys = {};
sorted_values = {};
use_values = length(args) >= 2;
for key in (keys)
  insert_at = $list_utils:find_insert(sorted_keys, key);
  sorted_keys[insert_at..insert_at - 1] = {key};
  if (use_values)
    sorted_values[insert_at..insert_at - 1] = {values[length(sorted_keys)]};
  endif
endfor
return use_values ? sorted_values | sorted_keys;
