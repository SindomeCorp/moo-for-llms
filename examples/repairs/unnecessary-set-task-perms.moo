" title: unnecessary-set-task-perms";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" set_task_perms(caller_perms());";
" if (!$perm_utils:controls(caller_perms(), this))";
"   return E_PERM;";
" endif";
" fixed:";
":visible_to(OBJ viewer) => INT";
"Called by display code to check whether viewer may see this object; no delegated mutation is needed.";
{viewer} = args;
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif

return viewer == this.owner || this.public;
