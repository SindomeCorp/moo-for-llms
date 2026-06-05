"title: task-cleanup-fork-09";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":schedule_cleanup_9(OBJ target, ?INT delay) => INT";
"Called by setup helpers to fork a cleanup task with captured arguments.";
{target, ?delay = 9} = args;
fork (delay)
  if (valid(target) && target.cleanable)
    target:cleanup();
  endif
endfork
return 1;
