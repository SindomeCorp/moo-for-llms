" title: direct-object-command";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
" setup: @verb object:inspect any none none";
" callable: command";

if (!valid(dobj))
  player:tell("You do not see " + dobjstr + " here.");
  return;
endif

player:tell("You inspect " + dobj.name + ".");
