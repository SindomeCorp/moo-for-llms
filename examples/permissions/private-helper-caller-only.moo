"title: private-helper-caller-only";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: MIXED value";
"returns: INT|ERR";
"notes: Private helper example where call path is the authority.";

":record_internal(MIXED value) => INT|ERR";
"Called only by other verbs on this object to append an internal value.";
{value} = args;
if (caller != this)
  return E_PERM;
endif
this.internal_values = {@this.internal_values, value};
return 1;
