"title: cp-dobj-this-use";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:use any on this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":use() => none";
"Called by a player command using parser variables; demonstrates argspec any on this.";
if (!valid(dobj))
  player:tell("Use what on ", this.name, "?");
  return;
endif
this.last_used = dobj;
player:tell("You use ", dobj.name, " on ", this.name, ".");
