"title: task-cleanup-fork-04";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":schedule_cleanup_4(OBJ target, ?INT delay) => INT";
"Called by setup helpers to fork a cleanup task with captured arguments.";
{target, ?delay = 4} = args;
fork (delay)
  if (valid(target) && target.cleanable)
    target:cleanup();
  endif
endfork
return 1;
