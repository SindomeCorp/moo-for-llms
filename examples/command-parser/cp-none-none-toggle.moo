"title: cp-none-none-toggle";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@lock none none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@lock() => none";
"Called by a player command using parser variables; demonstrates argspec none none none.";
this.locked = !this.locked;
player:tell("Locked: ", this.locked);
