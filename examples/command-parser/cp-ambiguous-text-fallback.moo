"title: cp-ambiguous-text-fallback";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:target any none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":target() => none";
"Called by a player command using parser variables; demonstrates argspec any none none.";
if (!valid(dobj))
  this.pending_target_text = dobjstr;
  player:tell("Target text saved: ", dobjstr);
  return;
endif
this.target = dobj;
player:tell("Target set to ", dobj.name, ".");
