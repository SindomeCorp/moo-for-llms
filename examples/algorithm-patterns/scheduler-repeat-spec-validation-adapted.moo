"title: algorithm-scheduler-repeat-spec-validation";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:check_repeat_args with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: MIXED repeat";
"returns: INT|ERR";
"notes: Shows validating multiple repeat-spec shapes before accepting scheduled work.";

":validate_repeat_spec(MIXED repeat) => INT|ERR";
"Called before adding a repeating task to reject malformed interval specs.";
{repeat} = args;
repeat_type = typeof(repeat);
if (repeat_type == LIST)
  if (!repeat || length(repeat) < 2)
    raise(E_INVARG, "repeat list must have at least two values", repeat);
  endif
  first_type = typeof(repeat[1]);
  second_type = typeof(repeat[2]);
  if (first_type == OBJ)
    if (second_type != STR)
      raise(E_INVARG, "repeat callback must be {object, verb_name}", repeat);
    elseif (!$object_utils:has_callable_verb(repeat[1], repeat[2]))
      raise(E_INVARG, "repeat callback verb is not callable", repeat);
    endif
  elseif (first_type == INT)
    if (second_type != INT)
      raise(E_INVARG, "repeat range must be {minimum, range}", repeat);
    endif
  else
    raise(E_INVARG, "repeat list shape is invalid", repeat);
  endif
elseif (repeat_type == STR)
  ` $time_utils:seconds_until_time(repeat) ! E_INVARG, E_TYPE => raise(E_INVARG, "repeat string must be hh:mm:ss", repeat)';
elseif (repeat_type != INT)
  raise(E_INVARG, "repeat type is invalid", repeat);
endif
return 1;
