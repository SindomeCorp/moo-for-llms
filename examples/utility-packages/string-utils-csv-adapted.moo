"title: utility-string-utils-csv";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:csv with permission from Sindome (www.sindome.org); VMS metadata removed and short utility refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST|MIXED value";
"returns: STR";
"notes: Shows building a comma-separated line while quoting string fields that contain commas.";

":csv(LIST|MIXED value) => STR";
"Return a comma-separated string for value or for each item in value when value is a list.";
{value} = args;
fields = typeof(value) == LIST ? value | {value};
line = "";
for index in [1..length(fields)]
  field = fields[index];
  if (typeof(field) == STR && match(field, ",") && !(field[1] == "\"" && field[$] == "\""))
    field = "\"" + field + "\"";
  endif
  line = tostr(line, field, index < length(fields) ? "," | "");
endfor
return line;
