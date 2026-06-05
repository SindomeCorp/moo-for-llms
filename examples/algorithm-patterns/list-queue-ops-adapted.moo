"title: algorithm-list-queue-ops";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $list_utils:unshift and $list_utils:shift with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST queue, MIXED item";
"returns: LIST";
"notes: Shows queue-style front insertion and front removal with ordinary lists.";

":unshift_then_shift(LIST queue, MIXED item) => LIST";
"Called by queue tests to prepend an item and then return {shifted, remaining_queue}.";
{queue, item} = args;
queue = {item, @queue};
shifted = queue[1];
if (length(queue) > 1)
  queue = queue[2..$];
else
  queue = {};
endif
return {shifted, queue};
