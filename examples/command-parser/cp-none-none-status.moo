"title: cp-none-none-status";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@status none none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@status() => none";
"Called by a player command using parser variables; demonstrates argspec none none none.";
player:tell("Status: ", this.status);
