"title: protected-recycle-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $sysobj:bf_recycle with permission from Sindome (www.sindome.org); wizard notification hooks and VMS history removed.";
"license: used-with-permission";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ target";
"returns: INT|ERR";
"notes: Shows protected recycle checks: validate the target, require caller control, and deny player recycling to non-wizards.";

":protected_recycle(OBJ target) => INT|ERR";
"Called by protected object-management wrappers before permanently recycling an object.";
{target} = args;
who = caller_perms();
if (typeof(target) != OBJ)
  return E_TYPE;
elseif (!valid(target))
  return E_INVARG;
elseif (!$perm_utils:controls(who, target))
  return E_PERM;
elseif (is_player(target) && !who.wizard)
  return E_PERM;
endif

result = `recycle(target) ! E_PERM, E_INVARG';
return typeof(result) == ERR ? result | 1;
