"title: scatter-and-optional-args";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: LIST values";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

values = {"alpha", "beta", "gamma", "delta"};
{first, ?second = "fallback", @rest} = values;
return {first, second, rest};
