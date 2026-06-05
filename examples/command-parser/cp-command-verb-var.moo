"title: cp-command-verb-var";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@which any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@which() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
player:tell("Command verb: ", verb);
