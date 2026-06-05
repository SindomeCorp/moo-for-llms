"title: cp-this-prep-to";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:attach this to any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":attach() => none";
"Called by a player command using parser variables; demonstrates argspec this to any.";
if (dobj != this || !valid(iobj))
  player:tell("Usage: attach ", this.name, " to <target>");
  return;
endif
this.attached_to = iobj;
player:tell("Attached to ", iobj.name, ".");
