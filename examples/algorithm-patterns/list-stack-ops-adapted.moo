"title: algorithm-list-stack-ops";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:push and $list_utils:pop with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST stack, MIXED item";
"returns: LIST";
"notes: Shows stack push/pop behavior represented with plain MOO lists.";

":push_then_pop(LIST stack, MIXED item) => LIST";
"Called by stack tests to append an item and then return {popped, remaining_stack}.";
{stack, item} = args;
stack = {@stack, item};
popped = stack[$];
if (length(stack) > 1)
  stack = stack[1..$ - 1];
else
  stack = {};
endif
return {popped, stack};
