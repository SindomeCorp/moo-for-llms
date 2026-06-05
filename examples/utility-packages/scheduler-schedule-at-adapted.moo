"title: utility-scheduler-schedule-at";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $scheduler package API and task row convention.";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:schedule_at with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT runtime, OBJ object, STR verb_name, ?LIST optional_args";
"returns: INT|ERR";
"notes: Shows scheduler task row construction for an absolute runtime.";

":schedule_at(INT runtime, OBJ object, STR verb_name, ?LIST optional_args) => INT|ERR";
"Add a one-shot scheduler task to run object:verb_name at runtime.";
{runtime, object, verb_name, ?optional_args = {}} = args;
if (!valid(object))
  return E_INVARG;
endif
task = {0, object, verb_name, runtime, caller_perms(), optional_args};
if (this.processing)
  this.incoming_tasks = {@this.incoming_tasks, task};
else
  this.scheduled_tasks = {@this.scheduled_tasks, task};
endif
return 1;
