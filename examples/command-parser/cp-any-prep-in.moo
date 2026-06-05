"title: cp-any-prep-in";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:put any in this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":put() => none";
"Called by a player command using parser variables; demonstrates argspec any in this.";
if (!valid(dobj))
  player:tell("Put what in ", this.name, "?");
  return;
endif
move(dobj, this);
player:tell("You put ", dobj.name, " in ", this.name, ".");
