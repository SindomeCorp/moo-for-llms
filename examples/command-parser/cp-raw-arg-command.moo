"title: cp-raw-arg-command";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@topic any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@topic() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
this.topic = argstr;
player:tell("Topic: ", this.topic);
