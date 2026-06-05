" title: fork-reminder";
" dialect: portable";
" source: original";
" license: MIT";
" topic: tasks";
"callable: programmatic";

{message, ?delay = 5} = args;
who = player;

fork (delay)
  if (valid(who))
    who:tell(message);
  endif
endfork

return "Reminder scheduled.";
