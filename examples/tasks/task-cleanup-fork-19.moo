"title: task-cleanup-fork-19";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":schedule_cleanup_19(OBJ target, ?INT delay) => INT";
"Called by setup helpers to fork a cleanup task with captured arguments.";
{target, ?delay = 19} = args;
fork (delay)
  if (valid(target) && target.cleanable)
    target:cleanup();
  endif
endfork
return 1;
