"title: cp-this-iobj-command";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:pour this into any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":pour() => none";
"Called by a player command using parser variables; demonstrates argspec this into any.";
if (dobj != this || !valid(iobj))
  player:tell("Usage: pour ", this.name, " into <container>");
  return;
endif
move(this, iobj);
player:tell("Poured into ", iobj.name, ".");
