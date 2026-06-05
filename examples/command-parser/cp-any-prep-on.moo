"title: cp-any-prep-on";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:place any on this";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":place() => none";
"Called by a player command using parser variables; demonstrates argspec any on this.";
if (!valid(dobj))
  player:tell("Place what on ", this.name, "?");
  return;
endif
this.surface_items = setadd(this.surface_items, dobj);
player:tell("Placed: ", dobj.name);
