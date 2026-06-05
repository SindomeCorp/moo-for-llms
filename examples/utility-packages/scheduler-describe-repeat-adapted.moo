"title: utility-scheduler-describe-repeat";
"dialect: core-specific";
"dialect_reason: Adapted from Sindome-specific $scheduler package API, though the demonstrated repeat-value shape is generic MOO.";
"source: approved-generic-sindome";
"provenance: Adapted from $scheduler:describe_repeat with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT|LIST|STR repeat";
"returns: STR";
"notes: Shows formatting mixed repeat specifications for scheduler-style utility APIs.";

":describe_repeat(INT|LIST|STR repeat) => STR";
"Return a readable description of a scheduler repeat value.";
{repeat} = args;
if (!repeat)
  return "";
elseif (typeof(repeat) == INT)
  return $string_utils:from_seconds(repeat);
elseif (typeof(repeat) == STR)
  return repeat;
elseif (typeof(repeat) != LIST || length(repeat) < 2)
  return "bad args";
endif
if (typeof(repeat[1]) == INT)
  return tostr(repeat[1], " to ", repeat[1] + repeat[2], " seconds");
endif
return tostr(repeat[1], ":", repeat[2]);
