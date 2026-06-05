"title: utility-math-utils-random-between";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:random_between with permission from Sindome (www.sindome.org); short refs expanded.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT|FLOAT start, INT|FLOAT finish";
"returns: INT|FLOAT";
"notes: Shows preserving integer vs float output while normalizing a range.";

":random_between(INT|FLOAT start, INT|FLOAT finish) => INT|FLOAT";
"Called by randomized helpers to choose a value inside an inclusive range.";
{start, finish} = args;
if (start > finish)
  temporary = start;
  start = finish;
  finish = temporary;
endif
input_type = typeof(start);
start = tofloat(start);
finish = tofloat(finish);
result = tofloat(random(100)) / 100.0 * (finish - start) + start;
return input_type == INT ? toint(result) | result;
