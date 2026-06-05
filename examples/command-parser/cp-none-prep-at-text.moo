"title: cp-none-prep-at-text";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:wave none at any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":wave() => none";
"Called by a player command using parser variables; demonstrates argspec none at any.";
if (valid(iobj))
  player:tell("You wave at ", iobj.name, ".");
else
  player:tell("You wave at ", iobjstr, ".");
endif
