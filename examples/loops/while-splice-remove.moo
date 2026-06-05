"title: while-splice-remove";
"dialect: portable";
"source: original";
"license: MIT";
"topic: loops";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows a while loop that mutates a list with splice assignment while guarding task ticks.";

":remove_blank_values(LIST values) => LIST";
"Called by normalization helpers to remove blank strings from a list.";
{values} = args;
while (index = "" in values)
  $command_utils:suspend_if_needed(0);
  values[index..index] = {};
endwhile
return values;
