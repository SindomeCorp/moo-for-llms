"title: cp-dobjstr-label";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@label any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@label() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (!dobjstr)
  player:tell("Usage: @label <text>");
  return;
endif
this.label = dobjstr;
player:tell("Label set to ", this.label, ".");
