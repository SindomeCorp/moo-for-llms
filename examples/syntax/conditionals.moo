"title: conditionals";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: INT score";
"returns: STR";
"notes: Compile-tested against a live MOO scratch verb.";

score = 7;
if (score >= 10)
  label = "high";
elseif (score >= 5)
  label = "medium";
else
  label = "low";
endif
return label;
