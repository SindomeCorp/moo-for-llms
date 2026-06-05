"title: utility-list-utils-iassoc";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:iassoc with permission from Sindome (www.sindome.org); VMS metadata removed and nesting reduced.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MIXED target, LIST rows, ?INT index";
"returns: INT";
"notes: Shows returning the row number of the first alist row matching a selected column.";

":iassoc(MIXED target, LIST rows, ?INT index) => INT";
"Return the index of the first row whose index-th element equals target; return 0 when no row matches.";
{target, rows, ?index = 1} = args;
row_number = 1;
for row in (rows)
  matches = `row[index] == target ! E_TYPE, E_RANGE => 0';
  if (matches && typeof(row) == LIST && length(row) >= index)
    return row_number;
  endif
  row_number = row_number + 1;
endfor
return 0;
