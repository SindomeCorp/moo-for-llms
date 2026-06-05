"title: cp-any-any-say";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:say any any any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":say() => none";
"Called by a player command using parser variables; demonstrates argspec any any any.";
if (!argstr)
  player:tell("Say what?");
  return;
endif
this:announce(player.name, " says, ", argstr);
