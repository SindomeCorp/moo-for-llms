"title: try-except";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: STR";
"notes: Compile-tested against a live MOO scratch verb.";

try
  label = this.missing_property_for_syntax_example;
except (E_PROPNF)
  label = "missing";
endtry
return label;
