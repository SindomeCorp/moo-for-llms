"title: task-yielding-loop-17";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":process_items_17(LIST items) => INT";
"Called by maintenance tasks to process a list while yielding periodically.";
{items} = args;
count = 0;
for item in (items)
  count = count + 1;
  if (count % 20 == 0)
    suspend(0);
  endif
endfor
return count;
