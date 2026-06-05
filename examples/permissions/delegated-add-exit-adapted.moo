"title: delegated-add-exit-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $root_room_class:add_exit with permission from Sindome (www.sindome.org); trailing version metadata removed.";
"license: used-with-permission";
"topic: permissions";
"callable: programmatic";
"args: OBJ exit";
"returns: INT";
"notes: Shows intentional delegation with set_task_perms(caller_perms()) before a property mutation.";

":add_exit(OBJ exit) => INT";
"Called by exit setup helpers to add an exit using the caller's effective permissions.";
{exit} = args;
set_task_perms(caller_perms());
return `this.exits = setadd(this.exits, exit) ! E_PERM' != E_PERM;
