"title: algorithm-scheduler-next-runtime";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:next_runtime with permission from Sindome (www.sindome.org); short refs, raw object example text, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST scheduled_task";
"returns: INT";
"notes: Shows calculating next runtime for fixed, daily-time, ranged-random, and callback repeat specs.";

":next_runtime(LIST scheduled_task) => INT";
"Called by scheduler loops to calculate the next runtime for a repeating task.";
{scheduled_task} = args;
{repeat, object, verb_name, runtime, owner, ?opargs = {}} = scheduled_task;
repeat_type = typeof(repeat);
if (!repeat)
  return 0;
elseif (repeat_type == INT)
  return time() + repeat;
elseif (repeat_type == STR)
  offset = $time_utils:seconds_until_time(repeat);
  return time() + (offset <= 0 ? offset + $time_utils.one_day | offset);
elseif (repeat_type == LIST)
  {first, second, ?more_args = {}} = repeat;
  if (typeof(first) == INT && typeof(second) == INT)
    return time() + first + random(second);
  else
    result = `first:(second)(object, verb_name, opargs, more_args) ! E_INVARG, E_PERM, E_VERBNF => 0';
    return result ? time() + result | 0;
  endif
endif
return 0;
