"title: syntax-scatter-rest-01";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: varies";
"returns: MIXED";
"notes: Compact syntax coverage example.";

":scatter_rest_1(@MIXED values) => MIXED";
"called by syntax tests to collect required and rest args.";
{first, @rest} = args;
return {first, rest};
