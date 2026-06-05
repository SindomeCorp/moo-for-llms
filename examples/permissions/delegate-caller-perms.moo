" title: delegate-caller-perms";
" dialect: portable";
" source: original";
" license: MIT";
" topic: permissions";
" provenance: modeled after $root_room_class:add_exit and other caller-permission delegation wrappers";
" callable: programmatic";

":add_member(OBJ member) => INT";
"Called by setup verbs to add an object to this.members using the caller's effective permissions.";
set_task_perms(caller_perms());
return `this.members = setadd(this.members, args[1]) ! E_PERM' != E_PERM;
