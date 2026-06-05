"title: utility-string-utils-english-list";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:english_list with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values, ?STR empty_text, ?STR conjunction, ?STR separator, ?STR final_separator";
"returns: STR";
"notes: Shows optional arguments and formatting a list as human-readable English.";

":english_list(LIST values, ?STR empty_text, ?STR conjunction, ?STR separator, ?STR final_separator) => STR";
"Render a list as text such as `one, two, and three`.";
{values, ?empty_text = "nothing", ?conjunction = " and ", ?separator = ", ", ?final_separator = ""} = args;
count = length(values);
if (count == 0)
  return empty_text;
elseif (count == 1)
  return tostr(values[1]);
elseif (count == 2)
  return tostr(values[1], conjunction, values[2]);
endif
result = "";
for index in [1..count - 1]
  $command_utils:suspend_if_needed(0);
  if (index == count - 1)
    separator = final_separator;
  endif
  result = tostr(result, values[index], separator);
endfor
return tostr(result, conjunction, values[count]);
