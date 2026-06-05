"title: property-access";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

prop = "name";
direct_name = this.name;
computed_name = this.(prop);
return {direct_name, computed_name};
