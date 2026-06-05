"title: cp-prep-branch-open";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:open any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":open() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (prepstr == "with")
  player:tell("You try opening ", dobjstr, " with ", iobjstr, ".");
elseif (dobjstr)
  player:tell("You try opening ", dobjstr, ".");
else
  player:tell("Open what?");
endif
