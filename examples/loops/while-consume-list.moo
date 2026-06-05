"title: while-consume-list";
"dialect: portable";
"source: original";
"license: MIT";
"topic: loops";
"callable: programmatic";
"args: LIST queue";
"returns: LIST";
"notes: Shows a while loop that consumes a queue with listdelete().";

":consume_queue(LIST queue) => LIST";
"Called by loop examples to process a queue until it is empty.";
{queue} = args;
processed = {};
while (queue)
  current = queue[1];
  queue = listdelete(queue, 1);
  processed = {@processed, current};
endwhile
return processed;
