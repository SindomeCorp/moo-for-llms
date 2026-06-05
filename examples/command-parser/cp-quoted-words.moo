"title: cp-quoted-words";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:@tag any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":@tag() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (length(args) < 1)
  player:tell("Usage: @tag <tag words>");
  return;
endif
this.tags = setadd(this.tags, $string_utils:from_list(args, " "));
player:tell("Tag added.");
