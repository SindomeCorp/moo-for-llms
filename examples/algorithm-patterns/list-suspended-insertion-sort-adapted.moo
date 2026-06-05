"title: algorithm-list-suspended-insertion-sort";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:sort_suspended with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: INT interval, LIST values, ?LIST keys";
"returns: LIST";
"notes: Shows an insertion-sort permutation that yields during long input scans.";

":sort_by_keys_suspended(INT interval, LIST values, ?LIST keys) => LIST";
"Called by maintenance tasks to sort large lists without monopolizing the task.";
{interval, values, ?keys = values} = args;
if (typeof(interval) != INT)
  return E_ARGS;
endif
sorted_keys = {};
sorted_values = {};
use_values = length(args) >= 3;
for key in (keys)
  insert_at = $list_utils:find_insert(sorted_keys, key);
  sorted_keys[insert_at..insert_at - 1] = {key};
  if (use_values)
    sorted_values[insert_at..insert_at - 1] = {values[length(sorted_keys)]};
  endif
  $command_utils:suspend_if_needed(interval);
endfor
return use_values ? sorted_values | sorted_keys;
