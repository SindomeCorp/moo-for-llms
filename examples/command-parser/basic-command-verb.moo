" title: basic-command-verb";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
"callable: command";
" setup: @verb object:push any none none";

if (!valid(dobj))
  player:tell("You do not see that here.");
  return;
endif

player:tell("You push " + dobj.name + ".");
