"title: count-membership-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:count with permission from Sindome (www.sindome.org); short refs and VMS history removed.";
"license: used-with-permission";
"topic: loops";
"callable: programmatic";
"args: MIXED target, LIST values, ?INT yield";
"returns: INT|ERR";
"notes: Shows a while membership loop that advances through the list by slicing after each match.";

":count_occurrences(MIXED target, LIST values, ?INT yield) => INT|ERR";
"Called by list utilities to count occurrences of target without modifying the caller's original list.";
{target, values, ?yield = 0} = args;
if (typeof(values) != LIST)
  return E_INVARG;
endif
count = 0;
while (index = target in values)
  if (yield)
    $command_utils:suspend_if_needed(0);
  endif
  count = count + 1;
  values = values[index + 1..$];
endwhile
return count;
