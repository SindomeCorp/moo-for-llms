"title: cp-iobj-this-command";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:load any into this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":load() => none";
"Called by a player command using parser variables; demonstrates argspec any into this.";
if (!valid(dobj) || iobj != this)
  player:tell("Usage: load <thing> into ", this.name);
  return;
endif
move(dobj, this);
player:tell("Loaded: ", dobj.name);
