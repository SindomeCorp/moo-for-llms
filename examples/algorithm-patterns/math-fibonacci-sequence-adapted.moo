"title: algorithm-math-fibonacci-sequence";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:fibonacci with permission from Sindome (www.sindome.org); argument-order issue corrected and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: INT number";
"returns: LIST|ERR";
"notes: Shows iterative sequence generation using the last two list elements.";

":fibonacci_sequence(INT number) => LIST|ERR";
"Called by math helpers to return Fibonacci values through the requested term.";
{number} = args;
if (typeof(number) != INT)
  return E_TYPE;
elseif (number < 0)
  return E_INVARG;
elseif (number == 0)
  return {0};
endif
values = {0, 1};
if (number > 1)
  for index in [2..number]
    values = {@values, values[$ - 1] + values[$]};
  endfor
endif
return values;
