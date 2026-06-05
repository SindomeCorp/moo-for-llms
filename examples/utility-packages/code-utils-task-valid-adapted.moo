"title: utility-code-utils-task-valid";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:task_valid with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT task";
"returns: INT";
"notes: Shows probing task validity with a specific caught permission result.";

":task_valid(INT task) => INT";
"Return true iff task is the current task or appears to be a valid queued task.";
{task} = args;
set_task_perms($no_one);
return task == task_id() || E_PERM == `kill_task(task) ! ANY';
