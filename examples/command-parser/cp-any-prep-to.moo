"title: cp-any-prep-to";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:give any to any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":give() => none";
"Called by a player command using parser variables; demonstrates argspec any to any.";
if (!valid(dobj) || !valid(iobj))
  player:tell("Usage: give <thing> to <person>");
  return;
endif
move(dobj, iobj);
player:tell("You give ", dobj.name, " to ", iobj.name, ".");
