"title: utility-list-utils-group-by-column";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:group_by_column with permission from Sindome (www.sindome.org); short refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST rows, ?INT column";
"returns: LIST";
"notes: Shows grouping list rows into {key, rows} pairs without maps.";

":group_by_column(LIST rows, ?INT column) => LIST";
"Called by table-formatting helpers to group rows by one column.";
{rows, ?column = 1} = args;
groups = {};
for row in (rows)
  key = row[column];
  found = 0;
  for index in [1..length(groups)]
    if (!found && groups[index][1] == key)
      groups[index][2] = {@groups[index][2], row};
      found = 1;
    endif
  endfor
  if (!found)
    groups = {@groups, {key, {row}}};
  endif
endfor
return groups;
