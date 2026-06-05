"title: cp-any-none-search";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:search any none none";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Command parser example using dobj/iobj text and player-facing failure flow.";

":search() => none";
"Called by a player command using parser variables; demonstrates argspec any none none.";
needle = dobjstr;
if (!needle)
  player:tell("Search for what?");
  return;
endif
player:tell("Searching for ", needle, ".");
