"title: utility-list-utils-flatten-suspended";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:flatten_suspended with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows recursive flattening while yielding through $command_utils.";

":flatten_suspended(LIST values) => LIST";
"Return values flattened recursively.";
{values} = args;
result = {};
for value in (values)
  $command_utils:suspend_if_needed(0);
  if (typeof(value) == LIST)
    result = {@result, @this:flatten_suspended(value)};
  else
    result = {@result, value};
  endif
endfor
return result;
