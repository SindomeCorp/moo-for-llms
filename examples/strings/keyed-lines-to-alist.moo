"title: keyed-lines-to-alist";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: LIST lines";
"returns: LIST";
"notes: Shows parsing key=value lines into portable alist rows.";

":keyed_lines_to_alist(LIST lines) => LIST";
"Called by import helpers to parse simple key=value text.";
{lines} = args;
rows = {};
for line in (lines)
  split = this:split_first(line, "=");
  if (length(split[1]))
    rows = {@rows, {split[1], split[2]}};
  endif
endfor
return rows;
