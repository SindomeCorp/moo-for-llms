"title: cp-no-args-command";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@ping none none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@ping() => none";
"Called by a player command using parser variables; demonstrates argspec none none none.";
player:tell("pong");
