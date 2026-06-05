"title: cp-any-prep-at";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:look any at this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":look() => none";
"Called by a player command using parser variables; demonstrates argspec any at this.";
if (!valid(iobj))
  player:tell("Look at what?");
  return;
endif
style = dobjstr ? dobjstr | "carefully";
player:tell("You look ", style, " at ", iobj.name, ".");
