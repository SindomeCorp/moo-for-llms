"title: limit-nesting-guards";
"dialect: portable";
"source: original";
"license: MIT";
"topic: code-scanner";
"callable: programmatic";
"args: OBJ target";
"returns: INT|ERR";
"notes: Shows guard clauses to avoid avoidable deep nesting.";

":check_target(OBJ target) => INT|ERR";
"Called by scanner examples to keep validation flat and readable.";
{target} = args;
if (!valid(target))
  return E_INVARG;
endif
if (!target.enabled)
  return 0;
endif
return target:check();
