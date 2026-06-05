"title: cp-argstr-preserve-spaces";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@memo any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@memo() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (!argstr)
  player:tell("Usage: @memo <text>");
  return;
endif
this.memo = argstr;
player:tell("Memo saved.");
