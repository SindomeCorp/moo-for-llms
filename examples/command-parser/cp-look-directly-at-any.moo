"title: cp-look-directly-at-any";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:look any at any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Shows using dobjstr as an adverb-like text field and requiring a valid iobj.";

":look() => none";
"Called by 'look directly at John' and 'look at John' using argspec any at any.";
if (!valid(iobj))
  player:tell("Look at whom?");
  return;
endif
modifier = dobjstr ? dobjstr + " " | "";
player:tell("You look ", modifier, "at ", iobj.name, ".");
