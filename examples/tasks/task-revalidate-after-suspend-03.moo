"title: task-revalidate-after-suspend-03";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":safe_after_suspend_3(OBJ target) => INT|ERR";
"Called by asynchronous helpers to revalidate an object after suspend.";
{target} = args;
suspend(0);
if (!valid(target))
  return E_INVARG;
endif
target.last_checked = time();
return 1;
