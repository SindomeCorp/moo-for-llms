"title: repair-deep-nesting-04";
"dialect: portable";
"source: original";
"license: MIT";
"topic: repairs";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Contrastive repair example with bad pattern documented as string comments.";

"bad: wrap every success path in another nested if.";
"fixed: use guard clauses to keep the main path shallow.";
{target} = args;
if (!valid(target))
  return E_INVARG;
endif
if (!target.enabled)
  return 0;
endif
return target:run_check();
