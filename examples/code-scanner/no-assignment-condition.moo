"title: no-assignment-condition";
"dialect: portable";
"source: original";
"license: MIT";
"topic: code-scanner";
"callable: programmatic";
"args: MIXED needle, LIST values";
"returns: INT";
"notes: Shows scanner-friendly separation of assignment from conditional checks.";

":find_position(MIXED needle, LIST values) => INT";
"Called by scanner examples to avoid assignment inside if or while conditions.";
{needle, values} = args;
position = needle in values;
if (position)
  return position;
endif
return 0;
