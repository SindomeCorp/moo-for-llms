"title: task-fork-capture-player-21";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Task scheduling and suspension example.";

":defer_notice_21(OBJ who, STR message, ?INT delay) => INT";
"Called by command verbs to send delayed feedback after revalidating the captured player.";
{who, message, ?delay = 21} = args;
fork (delay)
  if (valid(who))
    who:tell(message);
  endif
endfork
return 1;
