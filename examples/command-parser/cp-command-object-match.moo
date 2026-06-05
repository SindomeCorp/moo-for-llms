"title: cp-command-object-match";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:mark any none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":mark() => none";
"Called by a player command using parser variables; demonstrates argspec any none none.";
if (valid(dobj))
  this.marked = dobj;
  player:tell("Marked ", dobj.name, ".");
else
  player:tell("No match for ", dobjstr, ".");
endif
