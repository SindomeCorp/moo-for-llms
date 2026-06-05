"title: command-signature";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verb-docs";
"setup: @verb object:@rename any any any";
"callable: command";
"args: parser argstr";
"returns: none";
"notes: Shows top documentation for a command verb, including parser-driven invocation.";

":@rename() => none";
"Called by players as `@rename <new name>`; uses argstr from the command parser and tells the player on failure.";
if (!argstr)
  player:tell("Usage: @rename <new name>");
  return;
endif
this.name = argstr;
player:tell("Renamed to ", this.name, ".");
