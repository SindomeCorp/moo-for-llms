"title: utility-list-utils-slice";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:slice with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST rows, ?INT index";
"returns: LIST";
"notes: Shows optional args, field selection from row lists, and yielding through $command_utils.";

":slice(LIST rows, ?INT index) => LIST";
"Return the index-th field from each row in a list of lists.";
{rows, ?index = 1} = args;
result = {};
for row in (rows)
  $command_utils:suspend_if_needed(0);
  result = {@result, row[index]};
endfor
return result;
