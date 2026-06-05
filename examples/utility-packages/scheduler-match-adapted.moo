"title: utility-scheduler-match";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $scheduler package API and task row convention.";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:match with permission from Sindome (www.sindome.org); gameplay-specific matching helpers removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR name";
"returns: OBJ|INT";
"notes: Shows matching a scheduled task target by object name from scheduler task rows.";

":match(STR name) => OBJ|INT";
"Return the first scheduled task object whose name matches name, or 0.";
{name} = args;
for task in (this.scheduled_tasks)
  object = task[2];
  if (valid(object) && object.name == name)
    return object;
  endif
endfor
return 0;
