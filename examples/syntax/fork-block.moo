"title: fork-block";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: INT";
"notes: Compile-tested against a live MOO scratch verb. Fork examples are syntax-only; prefer scheduler utilities for production task orchestration when a core provides them.";

result = 0;
fork (1)
  result = 1;
endfork
return 1;
