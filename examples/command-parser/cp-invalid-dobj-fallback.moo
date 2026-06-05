"title: cp-invalid-dobj-fallback";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:inspect any none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":inspect() => none";
"Called by a player command using parser variables; demonstrates argspec any none none.";
if (!valid(dobj))
  player:tell("You do not see ", dobjstr, " here.");
  return;
endif
player:tell("You inspect ", dobj.name, ".");
