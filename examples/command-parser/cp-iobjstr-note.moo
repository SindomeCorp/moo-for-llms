"title: cp-iobjstr-note";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:write any on this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":write() => none";
"Called by a player command using parser variables; demonstrates argspec any on this.";
if (!dobjstr)
  player:tell("Write what on ", this.name, "?");
  return;
endif
this.note = dobjstr;
player:tell("You write on ", this.name, ".");
