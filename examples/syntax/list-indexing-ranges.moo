"title: list-indexing-ranges";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

items = {"north", "south", "east", "west"};
first = items[1];
middle = items[2..3];
items[4] = "down";
return {first, middle, items};
