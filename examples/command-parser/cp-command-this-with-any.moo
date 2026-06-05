"title: cp-command-this-with-any";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:repair this with any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Shows argspec this with any for commands installed on the object being acted on.";

":repair() => none";
"Called by 'repair this with <tool>' when this object owns the command verb.";
if (dobj != this)
  player:tell("You need to repair this object directly.");
  return;
elseif (!valid(iobj))
  player:tell("Repair it with what?");
  return;
endif
this:repair_with(player, iobj);
player:tell("You start repairing ", this.name, " with ", iobj.name, ".");
