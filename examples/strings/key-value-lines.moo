"title: key-value-lines";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: LIST lines";
"returns: LIST";
"notes: Parses simple key:value text into portable association-list rows.";

":parse_key_value_lines(LIST lines) => LIST";
"Called by import helpers for small human-authored key/value blocks.";
{lines} = args;
rows = {};
for line in (lines)
  divider = index(line, ":");
  if (divider)
    key = $string_utils:trim(line[1..divider - 1]);
    value = $string_utils:trim(line[divider + 1..$]);
    rows = {@rows, {key, value}};
  endif
endfor
return rows;
