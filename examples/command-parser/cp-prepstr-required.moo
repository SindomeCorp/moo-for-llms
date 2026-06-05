"title: cp-prepstr-required";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:compare any with any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":compare() => none";
"Called by a player command using parser variables; demonstrates argspec any with any.";
if (prepstr != "with" || !valid(dobj) || !valid(iobj))
  player:tell("Usage: compare <thing> with <thing>");
  return;
endif
player:tell("You compare ", dobj.name, " with ", iobj.name, ".");
