"title: cp-dobjstr-search-text";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"callable: command";
"setup: @verb thing:search any none none";
"args: command parser variables";
"returns: none";
"notes: Shows using dobjstr as text when command matching may not find an object.";

"Command body for `search any none none`.";
"Uses dobjstr because the command searches text, not necessarily a matched object.";
if (!length(dobjstr))
  player:tell("Search for what?");
  return;
endif
results = this:search_text(dobjstr);
player:tell("Found ", length(results), " result", length(results) == 1 ? "." | "s.");
