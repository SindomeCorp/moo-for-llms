"title: algorithm-list-merge-sort-alist";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:sort_alist with permission from Sindome (www.sindome.org); VMS metadata removed and merge loop simplified.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST rows, ?INT column";
"returns: LIST";
"notes: Shows recursive merge sort over alist rows by a selected column.";

":sort_rows_by_column(LIST rows, ?INT column) => LIST";
"Called by table helpers to sort list rows by a selected column.";
{rows, ?column = 1} = args;
count = length(rows);
if (count < 2)
  return rows;
endif
midpoint = count / 2;
left = this:sort_rows_by_column(rows[1..midpoint], column);
right = this:sort_rows_by_column(rows[midpoint + 1..count], column);
merged = {};
left_index = 1;
right_index = 1;
while (left_index <= length(left) && right_index <= length(right))
  $command_utils:suspend_if_needed(0);
  if (left[left_index][column] <= right[right_index][column])
    merged = {@merged, left[left_index]};
    left_index = left_index + 1;
  else
    merged = {@merged, right[right_index]};
    right_index = right_index + 1;
  endif
endwhile
if (left_index <= length(left))
  merged = {@merged, @left[left_index..$]};
endif
if (right_index <= length(right))
  merged = {@merged, @right[right_index..$]};
endif
return merged;
