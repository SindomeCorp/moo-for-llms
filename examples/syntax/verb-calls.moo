"title: verb-calls";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

name_text = this:name();
verb_name = "name";
computed_name = this:(verb_name)();
parts = {"prefix-", computed_name};
joined = tostr(@parts);
return {name_text, computed_name, joined};
