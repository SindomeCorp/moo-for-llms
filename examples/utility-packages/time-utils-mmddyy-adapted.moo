"title: utility-time-utils-mmddyy";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $time_utils:mmddyy with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT|STR date, ?STR separator";
"returns: STR|ERR";
"notes: Shows optional scatter assignment, type normalization, and date formatting.";

":mmddyy(INT|STR date, ?STR separator) => STR|ERR";
"Return a ctime-style date in MM/DD/YY form using an optional separator.";
{date, ?separator = "/"} = args;
if (typeof(date) == INT)
  date = ctime(date);
elseif (typeof(date) != STR)
  return E_TYPE;
endif
parts = $string_utils:explode(date);
if (length(parts) < 5)
  return E_INVARG;
endif
day = toint(parts[3]);
month = parts[2] in $time_utils.monthabbrs;
year = tostr(parts[5]);
day_text = day < 10 ? "0" + tostr(day) | tostr(day);
month_text = month < 10 ? "0" + tostr(month) | tostr(month);
return tostr(month_text, separator, day_text, separator, year[3..4]);
