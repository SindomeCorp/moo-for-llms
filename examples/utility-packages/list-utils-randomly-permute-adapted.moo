"title: utility-list-utils-randomly-permute";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:randomly_permute_suspended with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows building a random permutation while yielding through $command_utils.";

":randomly_permute(LIST values) => LIST";
"Return values in a random order.";
{values} = args;
result = {};
for index in [1..length(values)]
  result = listinsert(result, values[index], random(index));
  $command_utils:suspend_if_needed(0);
endfor
return result;
