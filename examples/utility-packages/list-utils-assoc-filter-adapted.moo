"title: utility-list-utils-assoc-filter";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:assoc_filter with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MIXED target, LIST rows, ?INT index, ?INT mode";
"returns: LIST";
"notes: Shows filtering alist-style rows by a selected column.";

":assoc_filter(MIXED target, LIST rows, ?INT index, ?INT mode) => LIST";
"Return rows whose index-th value matches target when mode is true, or does not match when mode is false.";
{target, rows, ?index = 1, ?mode = 1} = args;
result = {};
for row in (rows)
  if (typeof(row) == LIST && length(row) >= index && ((row[index] == target) == mode))
    result = {@result, row};
  endif
endfor
return result;
