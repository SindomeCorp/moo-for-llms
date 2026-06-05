"title: utility-scheduler-schedule-for";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $scheduler package API and task row convention.";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:schedule_for with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT delay, OBJ object, STR verb_name, ?LIST optional_args";
"returns: INT|ERR";
"notes: Shows converting relative delay into absolute scheduler runtime.";

":schedule_for(INT delay, OBJ object, STR verb_name, ?LIST optional_args) => INT|ERR";
"Add a one-shot scheduler task to run object:verb_name delay seconds from now.";
{delay, object, verb_name, ?optional_args = {}} = args;
if (!valid(object))
  return E_INVARG;
endif
runtime = time() + delay;
task = {0, object, verb_name, runtime, caller_perms(), optional_args};
this.scheduled_tasks = {@this.scheduled_tasks, task};
return 1;
