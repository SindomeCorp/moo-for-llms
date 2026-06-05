"title: algorithm-math-factorial-iterative";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:factorial with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: INT number";
"returns: INT|ERR";
"notes: Shows iterative multiplication with input validation.";

":factorial_iterative(INT number) => INT|ERR";
"Called by math helpers to calculate a small non-negative factorial.";
{number} = args;
if (typeof(number) != INT)
  return E_TYPE;
elseif (number < 0)
  return E_INVARG;
endif
result = 1;
if (number > 1)
  for value in [2..number]
    result = result * value;
  endfor
endif
return result;
