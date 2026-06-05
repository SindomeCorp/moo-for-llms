"title: algorithm-list-bounded-recursive-reverse";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:_reverse with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows recursive divide-and-conquer for large lists and insertion at the front for small lists.";

":reverse_values(LIST values) => LIST";
"Called by list display helpers to return a reversed copy without mutating the input list.";
{values} = args;
if (length(values) > 50)
  midpoint = length(values) / 2;
  return {@this:reverse_values(values[midpoint + 1..$]), @this:reverse_values(values[1..midpoint])};
endif
result = {};
for value in (values)
  $command_utils:suspend_if_needed(0);
  result = listinsert(result, value);
endfor
return result;
