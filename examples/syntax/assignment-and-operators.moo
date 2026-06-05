"title: assignment-and-operators";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

count = 2;
count = count + 3;
double = count * 2;
remainder = double % 3;
is_large = double >= 10;
is_ready = is_large && !(remainder == 0);
return {count, double, remainder, is_ready};
