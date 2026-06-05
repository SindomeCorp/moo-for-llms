"title: cp-args-word-count";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@count-words any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@count-words() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
player:tell("Words: ", length(args));
