" title: command-feedback-return";
" dialect: portable";
" source: original";
" license: MIT";
" topic: errors";
" setup: @verb object:@use any none none";
" callable: command";

":@use(OBJ target) => none";
"Called by a player command; routine command failures tell the player and return.";
if (!valid(dobj))
  player:tell("Use what?");
  return;
endif

if (!$object_utils:contains(player, dobj) && dobj.location != player.location)
  player:tell("That is not close enough to use.");
  return;
endif

player:tell("You use ", dobj.name, ".");
