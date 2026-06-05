"title: continue-filter-output";
"dialect: portable";
"source: original";
"license: MIT";
"topic: loops";
"callable: programmatic";
"args: LIST values, LIST ignored";
"returns: LIST";
"notes: Shows using continue for simple filter clauses before appending output.";

":filter_ignored(LIST values, LIST ignored) => LIST";
"Called by display helpers to remove ignored values while preserving order.";
{values, ignored} = args;
output = {};
for value in (values)
  if (value in ignored)
    continue;
  elseif (!value)
    continue;
  endif
  output = {@output, value};
endfor
return output;
