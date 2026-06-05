" title: command-raise-invarg";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" setup: @verb object:@use any none none";
" callable: command";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if (!valid(dobj))";
"   raise(E_INVARG);";
" endif";
" fixed:";
":@use(OBJ target) => none";
"Called by a player command; invalid command targets tell the player and return.";
if (!valid(dobj))
  player:tell("Use what?");
  return;
endif

player:tell("You use ", dobj.name, ".");
