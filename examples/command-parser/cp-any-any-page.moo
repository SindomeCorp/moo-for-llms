"title: cp-any-any-page";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:page any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":page() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (!dobjstr || !argstr)
  player:tell("Usage: page <person> <message>");
  return;
endif
this:page_text(player, dobjstr, argstr);
