"title: utility-list-utils-assoc-prefix";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:assoc_prefix with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR prefix, LIST rows, ?INT index";
"returns: LIST";
"notes: Shows prefix matching against a selected alist column.";

":assoc_prefix(STR prefix, LIST rows, ?INT index) => LIST";
"Return the first row whose index-th element starts with prefix; return {} when no row matches.";
{prefix, rows, ?index = 1} = args;
for row in (rows)
  if (typeof(row) == LIST && length(row) >= index && index(row[index], prefix) == 1)
    return row;
  endif
endfor
return {};
