"title: error-expression";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: STR text";
"returns: INT";
"notes: Compile-tested against a live MOO scratch verb.";

text = "12";
value = `toint(text) ! E_INVARG, E_TYPE => 0';
return value;
