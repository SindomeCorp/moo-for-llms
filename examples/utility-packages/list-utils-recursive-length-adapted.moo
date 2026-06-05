"title: utility-list-utils-recursive-length";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:length with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values, ?INT recurse";
"returns: INT";
"notes: Shows recursively counting nested list elements while yielding through $command_utils.";

":recursive_length(LIST values, ?INT recurse) => INT";
"Return length(values), or include nested list lengths when recurse is true.";
{values, ?recurse = 0} = args;
total = length(values);
if (!recurse)
  return total;
endif
for value in (values)
  if (typeof(value) == LIST)
    total = total + this:recursive_length(value, recurse);
  endif
  $command_utils:suspend_if_needed(0);
endfor
return total;
