"title: utility-code-utils-task-owner";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:task_owner with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT task";
"returns: OBJ|ERR";
"notes: Shows retrieving the owner field from queued_tasks() with an E_INVARG fallback.";

":task_owner(INT task) => OBJ|ERR";
"Return the owner of a queued task, or E_INVARG when the task is not queued.";
{task} = args;
row = $list_utils:assoc(task, queued_tasks());
return row ? row[5] | E_INVARG;
