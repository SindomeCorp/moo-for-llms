"title: utility-math-utils-average";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:average with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST values | NUM ...";
"returns: INT|FLOAT";
"notes: Shows accepting either a list argument or variadic numeric args.";

":average(LIST values | NUM ...) => INT|FLOAT";
"Return the average of a list of numbers or all provided numeric arguments.";
if (length(args) == 1 && typeof(args[1]) == LIST)
  values = args[1];
else
  values = args;
endif
total = $math_utils:sum(values);
count = length(values);
return total / (typeof(total) == FLOAT ? tofloat(count) | count);
