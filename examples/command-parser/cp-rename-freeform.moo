"title: cp-rename-freeform";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"callable: command";
"setup: @verb thing:rename any any any";
"args: command parser variables";
"returns: none";
"notes: Shows using argstr for free-form command text rather than destructuring args.";

"Command body for `rename any any any`.";
"Uses argstr so names containing preposition words are preserved.";
if (!length(argstr))
  player:tell("Rename it to what?");
  return;
endif
this.name = argstr;
player:tell("Renamed to ", this.name, ".");
