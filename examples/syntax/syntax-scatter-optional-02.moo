"title: syntax-scatter-optional-02";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":scatter_optional_2(@MIXED values) => MIXED";
"called by syntax tests to demonstrate optional scatter defaults.";
{value, ?fallback = 0} = args;
return value || fallback;
