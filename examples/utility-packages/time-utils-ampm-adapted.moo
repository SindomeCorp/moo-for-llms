"title: utility-time-utils-ampm";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $time_utils:ampm with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT|STR timestamp, ?INT precision";
"returns: STR|ERR";
"notes: Shows accepting either ctime-style strings or integer timestamps.";

":ampm(INT|STR timestamp, ?INT precision) => STR|ERR";
"Called by display helpers to format a timestamp as a.m./p.m. time.";
{timestamp, ?precision = 2} = args;
if (typeof(timestamp) == INT)
  timestamp = ctime(timestamp);
elseif (typeof(timestamp) != STR)
  return E_TYPE;
endif
time_text = $string_utils:explode(timestamp)[4];
hour = toint(time_text[1..2]);
if (hour == 0)
  return "12" + time_text[3..precision * 3 - 1] + " a.m.";
elseif (hour == 12)
  return time_text[1..precision * 3 - 1] + " p.m.";
elseif (hour > 12)
  return tostr(hour - 12) + time_text[3..precision * 3 - 1] + " p.m.";
else
  return tostr(hour) + time_text[3..precision * 3 - 1] + " a.m.";
endif
