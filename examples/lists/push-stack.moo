" title: push-stack";
" dialect: portable";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: lists";
"callable: programmatic";
" provenance: adapted from $list_utils:push";

":push(ANY item, LIST stack) => LIST newstack";
"Adds the item to the end of the stack and return the new stack.";
{item, stack} = args;
return {@stack, item};
