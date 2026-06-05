"title: utility-command-utils-task-info";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:task_info with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT task";
"returns: LIST|ERR";
"notes: Shows intentional delegation to caller_perms() before locating one queued task record by task id.";

":task_info(INT task) => LIST|ERR";
"Return the queued_tasks() row for task, or E_INVARG when it is not queued.";
{task} = args;
set_task_perms(caller_perms());
for queued in (queued_tasks())
  if (queued[1] == task)
    return queued;
  endif
endfor
return E_INVARG;
