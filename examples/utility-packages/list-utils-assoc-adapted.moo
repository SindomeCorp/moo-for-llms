"title: utility-list-utils-assoc";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:assoc with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: MIXED target, LIST rows, ?INT index";
"returns: LIST";
"notes: Shows alist lookup with optional column selection and inline range/type catches.";

":assoc(MIXED target, LIST rows, ?INT index) => LIST";
"Return the first row whose index-th element equals target; return {} when no row matches.";
{target, rows, ?index = 1} = args;
for row in (rows)
  $command_utils:suspend_if_needed(0);
  matches = `row[index] == target ! E_TYPE, E_RANGE => 0';
  if (matches && typeof(row) == LIST && length(row) >= index)
    return row;
  endif
endfor
return {};
