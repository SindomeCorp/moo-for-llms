"title: cp-chparent-any-to-any-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $builder:@chparent with permission from Sindome (www.sindome.org); broadcast hooks, raw object references, and VMS history removed.";
"license: used-with-permission";
"topic: command-parser";
"setup: @verb object:@chparent any to any";
"callable: command";
"args: command parser variables";
"returns: none";
"notes: Shows a real builder command using dobjstr/iobjstr matching and player-facing permission errors.";

":@chparent() => none";
"Called by builders as '@chparent <object> to <new parent>'.";
object = player:my_match_object(dobjstr);
if ($command_utils:object_match_failed(object, dobjstr))
  return;
endif
new_parent = player:my_match_object(iobjstr);
if ($command_utils:object_match_failed(new_parent, iobjstr))
  return;
elseif (is_player(object) && !$object_utils:isa(new_parent, $player_class))
  player:tell("That object is a player and the new parent is not a player class.");
  return;
endif

try
  old_parent = parent(object);
  player:_chparent(object, new_parent);
  player:tell("Parent changed from ", old_parent.name, " to ", new_parent.name, ".");
except (E_INVARG)
  player:tell("That object cannot be changed to that parent.");
except (E_PERM)
  player:tell("Either you do not control the object, do not control the parent, or the parent is not fertile.");
except (E_RECMOVE)
  player:tell("That parent is a descendant of the object.");
endtry
