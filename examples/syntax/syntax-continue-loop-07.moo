"title: syntax-continue-loop-07";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":continue_loop_7(@MIXED values) => MIXED";
"called by syntax tests to demonstrate continue.";
{items} = args;
result = {};
for item in (items)
  if (!item)
    continue;
  endif
  result = {@result, item};
endfor
return result;
