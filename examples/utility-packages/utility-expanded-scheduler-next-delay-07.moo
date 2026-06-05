"title: utility-expanded-scheduler-next-delay-07";
"dialect: core-specific";
"dialect_reason: Uses or models the $scheduler package as a core-specific utility API in this corpus.";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: INT when";
"returns: INT";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":next_delay_7(INT when) => INT";
"Called by utility package examples to demonstrate a focused helper pattern.";
{when} = args;
return max(0, when - time());
