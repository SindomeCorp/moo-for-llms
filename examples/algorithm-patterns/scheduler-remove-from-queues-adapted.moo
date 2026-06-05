"title: algorithm-scheduler-remove-from-queues";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:remove_scheduled with permission from Sindome (www.sindome.org); permission policy and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST tasks, LIST incoming_tasks, OBJ object, ?STR verb_name, ?LIST optional_args";
"returns: LIST";
"notes: Shows removing matching scheduled entries from both active and incoming queues.";

":remove_scheduled_entries(LIST tasks, LIST incoming_tasks, OBJ object, ?STR verb_name, ?LIST optional_args) => LIST";
"Called by scheduler cleanup helpers to remove matching work from both queues.";
{tasks, incoming_tasks, object, ?verb_name = "", ?optional_args = {}} = args;
removed = 0;
remaining_tasks = {};
for task in (tasks)
  $command_utils:suspend_if_needed(0);
  matches = task[2] == object && (verb_name == "" || task[3] == verb_name) && (!optional_args || task[6] == optional_args);
  if (matches)
    removed = removed + 1;
  else
    remaining_tasks = {@remaining_tasks, task};
  endif
endfor
remaining_incoming = {};
for task in (incoming_tasks)
  $command_utils:suspend_if_needed(0);
  matches = task[2] == object && (verb_name == "" || task[3] == verb_name) && (!optional_args || task[6] == optional_args);
  if (matches)
    removed = removed + 1;
  else
    remaining_incoming = {@remaining_incoming, task};
  endif
endfor
return {remaining_tasks, remaining_incoming, removed};
