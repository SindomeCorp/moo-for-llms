"title: assoc-index-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:assoc with permission from Sindome (www.sindome.org); short refs and VMS history removed.";
"license: used-with-permission";
"topic: lists";
"callable: programmatic";
"args: MIXED target, LIST rows, ?INT index";
"returns: LIST";
"notes: Shows alist lookup with optional index and specific inline error handling for malformed rows.";

":assoc_index(MIXED target, LIST rows, ?INT index) => LIST";
"Called by lookup helpers to return the first row whose indexed element matches target.";
{target, rows, ?index = 1} = args;
for row in (rows)
  $command_utils:suspend_if_needed(0);
  if (`row[index] == target ! E_TYPE, E_RANGE => 0')
    if (typeof(row) == LIST && length(row) >= index)
      return row;
    endif
  endif
endfor
return {};
