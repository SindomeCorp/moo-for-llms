"title: cp-this-none-polish";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:polish this none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":polish() => none";
"Called by a player command using parser variables; demonstrates argspec this none none.";
if (dobj != this)
  player:tell("You cannot polish that with this command.");
  return;
endif
player:tell("You polish ", this.name, ".");
