"title: protected-chparent-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $sysobj:bf_chparent with permission from Sindome (www.sindome.org); raw object references and VMS history removed.";
"license: used-with-permission";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ object, OBJ new_parent";
"returns: INT|ERR";
"notes: Shows the protected-builtin wrapper shape for chparent with caller permission, player-class, and fertile-parent checks.";

":protected_chparent(OBJ object, OBJ new_parent) => INT|ERR";
"Called by protected object-management wrappers before changing an object's parent.";
{object, new_parent} = args;
who = caller_perms();
if (typeof(object) != OBJ || typeof(new_parent) != OBJ)
  return E_TYPE;
elseif (!valid(object) || !valid(new_parent))
  return E_INVARG;
elseif (!$perm_utils:controls(who, object))
  return E_PERM;
elseif (is_player(object) && !$object_utils:isa(new_parent, $player_class) && !who.wizard)
  return E_PERM;
elseif (!$perm_utils:controls(who, new_parent) && !new_parent.f)
  return E_PERM;
endif

result = `chparent(object, new_parent) ! E_PERM, E_INVARG, E_RECMOVE';
return typeof(result) == ERR ? result | 1;
