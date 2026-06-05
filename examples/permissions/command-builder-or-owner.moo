"title: command-builder-or-owner";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"provenance: modeled after LambdaCore-style command verbs that combine player ownership checks with builder role checks";
"setup: @verb object:@seat any any any";
"callable: command";
"args: parser dobj";
"returns: none";
"notes: Shows command UI authorization with player-facing errors, not programmatic caller_perms() checks.";

":@seat() => none";
"Called by the @seat command to add a matched object to this.seats for the current room.";
if (player != this.owner && !$object_utils:isa(player, $builder))
  player:tell("Only the owner or a builder may add seats here.");
  return;
endif
if (!valid(dobj))
  player:tell("Seat what?");
  return;
endif
this.seats = setadd(this.seats, dobj);
player:tell("Seat added: ", dobj.name);
