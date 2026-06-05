"title: utility-scheduler-check-repeat-args";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $scheduler package API, including scheduler repeat argument conventions.";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:check_repeat_args with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT|LIST|STR repeat";
"returns: INT|ERR";
"notes: Shows explicit validation of union-shaped scheduler arguments.";

":check_repeat_args(INT|LIST|STR repeat) => INT|ERR";
"Validate a scheduler repeat argument and raise E_INVARG for invalid shapes.";
{repeat} = args;
repeat_type = typeof(repeat);
if (repeat_type == INT)
  return 1;
elseif (repeat_type == STR)
  $time_utils:seconds_until_time(repeat);
  return 1;
elseif (repeat_type != LIST || length(repeat) < 2)
  raise(E_INVARG, "repeat arg bad value", repeat);
endif
first_type = typeof(repeat[1]);
second_type = typeof(repeat[2]);
if (first_type == OBJ && second_type == STR && $object_utils:has_callable_verb(repeat[1], repeat[2]))
  return 1;
elseif (first_type == INT && second_type == INT)
  return 1;
endif
raise(E_INVARG, "repeat arg invalid", repeat);
