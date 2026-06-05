" title: preposition-branch";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
" setup: @verb object:look none at any; @verb object:look any at any";
" callable: command";

if (prepstr != "at" || !valid(iobj))
  player:tell("Look at what?");
  return;
endif

modifier = dobjstr ? dobjstr + " " | "";
player:tell("You look ", modifier, "at ", iobj.name, ".");
