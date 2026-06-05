"title: recycler-recycle-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $recycler:_recycle with permission from Sindome (www.sindome.org); gameplay hooks and historical metadata removed.";
"license: used-with-permission";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ item";
"returns: INT|ERR";
"notes: Shows recycler-style permission checks before turning an object into reusable garbage.";

":recycle_checked(OBJ item) => INT|ERR";
"Called by cleanup tools to recycle an object only when the caller controls it.";
{item} = args;
if (!$perm_utils:controls(caller_perms(), item))
  raise(E_PERM);
elseif (is_player(item))
  raise(E_INVARG);
elseif (`item:recycle_denied() ! E_VERBNF => 0')
  raise(E_PERM);
elseif (`item.recycle_denied ! E_PROPNF => 0')
  return E_PERM;
endif
this:add_orphan(item);
result = `$building_utils:recreate(item, $garbage) ! E_PERM, E_INVARG, E_QUOTA';
if (typeof(result) == ERR)
  return result;
endif
this:remove_orphan(item);
item.name = tostr("Recyclable ", item);
move(item, $recycler);
return 1;
