"title: utility-list-utils-zip";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:zip with permission from Sindome (www.sindome.org); source-control metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST ...";
"returns: LIST|ERR";
"notes: Shows variadic list validation and row construction with missing cells filled as 0.";

":zip(LIST ...) => LIST|ERR";
"Return rows made from corresponding positions in each input list.";
longest = 0;
for column in (args)
  if (typeof(column) != LIST)
    return E_INVARG;
  endif
  longest = max(longest, length(column));
endfor
rows = {};
columns = length(args);
for row_index in [1..longest]
  row = $list_utils:make(columns);
  for column_index in [1..columns]
    row[column_index] = `args[column_index][row_index] ! E_RANGE => 0';
  endfor
  rows = {@rows, row};
endfor
return rows;
