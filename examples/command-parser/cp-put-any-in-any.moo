"title: cp-put-any-in-any";
"dialect: portable";
"source: original";
"license: MIT";
"topic: command-parser";
"setup: @verb object:put any in any";
"callable: command";
"args: parser variables";
"returns: none";
"notes: Shows a real-world direct-object and indirect-object command with player feedback.";

":put() => none";
"Called by a player command using argspec any in any.";
if (!valid(dobj))
  player:tell("Put what?");
  return;
elseif (!valid(iobj))
  player:tell("Put it in what?");
  return;
elseif ($object_utils:contains(dobj, iobj))
  player:tell("That would create a containment loop.");
  return;
endif
result = `move(dobj, iobj) ! E_NACC, E_PERM, E_RECMOVE';
if (typeof(result) == ERR)
  player:tell("You cannot put ", dobj.name, " in ", iobj.name, ".");
  return;
endif
player:tell("You put ", dobj.name, " in ", iobj.name, ".");
