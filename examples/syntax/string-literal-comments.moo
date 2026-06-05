"title: syntax-string-literal-comments";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: INT";
"notes: Compile-tested against a live MOO scratch verb.";

"String-literal comments are valid MOO statements and must end with semicolons.";
value = 1;
"They survive parsing in a way that parser-discarded comment syntax may not.";
return value;
