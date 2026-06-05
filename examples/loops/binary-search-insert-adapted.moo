"title: binary-search-insert-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:find_insert with permission from Sindome (www.sindome.org); short refs and history comments removed.";
"license: used-with-permission";
"topic: loops";
"callable: programmatic";
"args: LIST sorted_values, MIXED key";
"returns: INT";
"notes: Shows a while loop implementing binary search over a sorted list.";

":find_insert(LIST sorted_values, MIXED key) => INT";
"Called by sorted-list utilities to find the first position whose value is greater than key.";
{sorted_values, key} = args;
right = length(sorted_values);
if (right < 25)
  for left in [1..right]
    $command_utils:suspend_if_needed(0);
    if (sorted_values[left] > key)
      return left;
    endif
  endfor
  return right + 1;
endif
left = 1;
while (right >= left)
  $command_utils:suspend_if_needed(0);
  mid = (right + left) / 2;
  if (key < sorted_values[mid])
    right = mid - 1;
  else
    left = mid + 1;
  endif
endwhile
return left;
