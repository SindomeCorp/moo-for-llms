"title: for-range-step";
"dialect: portable";
"source: original";
"license: MIT";
"topic: loops";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Shows a numeric range loop using indexes instead of iterating values directly.";

":numbered_lines(LIST values) => LIST";
"Called by display helpers to prefix each list item with its position.";
{values} = args;
output = {};
for i in [1..length(values)]
  output = {@output, tostr(i, ". ", values[i])};
endfor
return output;
