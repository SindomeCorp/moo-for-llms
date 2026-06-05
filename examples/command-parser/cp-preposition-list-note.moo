"title: cp-preposition-list-note";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:move any from any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":move() => none";
"Called by a player command using parser variables; demonstrates argspec any from any.";
if (prepstr != "from")
  player:tell("Use: move <thing> from <place>");
  return;
endif
player:tell("Moving ", dobjstr, " from ", iobjstr, ".");
