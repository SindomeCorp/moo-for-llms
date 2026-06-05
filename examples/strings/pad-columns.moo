"title: pad-columns";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: LIST rows, INT width";
"returns: LIST";
"notes: Shows simple string formatting for fixed-width display rows.";

":pad_columns(LIST rows, INT width) => LIST";
"Called by display helpers to pad the first column in two-column rows.";
{rows, width} = args;
output = {};
for row in (rows)
  label = row[1];
  while (length(label) < width)
    label = label + " ";
  endwhile
  output = {@output, tostr(label, row[2])};
endfor
return output;
