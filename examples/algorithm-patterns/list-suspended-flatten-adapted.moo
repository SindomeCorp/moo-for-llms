"title: algorithm-list-suspended-flatten";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:flatten_suspended with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST nested";
"returns: LIST";
"notes: Shows recursive list flattening with periodic yielding.";

":flatten_list_suspended(LIST nested) => LIST";
"Called by cleanup tasks to flatten large nested list structures.";
{nested} = args;
result = {};
for value in (nested)
  $command_utils:suspend_if_needed(0);
  if (typeof(value) == LIST)
    result = {@result, @this:flatten_list_suspended(value)};
  else
    result = {@result, value};
  endif
endfor
return result;
