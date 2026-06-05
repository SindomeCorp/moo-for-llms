" title: direct-indirect-command";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
" setup: @verb object:put any in any";
" callable: command";

if (!valid(dobj))
  player:tell("You do not have " + dobjstr + ".");
  return;
elseif (!valid(iobj))
  player:tell("You do not see " + iobjstr + ".");
  return;
endif

player:tell("You put " + dobj.name + " " + prepstr + " " + iobj.name + ".");
