" title: command-utils-yield";
" dialect: portable";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" notes: uses a LambdaCore-style $command_utils helper; availability is a core convention";

":process_items(LIST items) => INT";
"Called by batch helpers to periodically yield using a core utility helper.";
{items} = args;
count = 0;
for item in (items)
  $command_utils:suspend_if_needed(0);
  this:process_item(item);
  count = count + 1;
endfor

return count;
