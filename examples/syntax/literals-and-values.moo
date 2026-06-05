"title: literals-and-values";
"dialect: portable";
"source: original";
"license: MIT";
"topic: syntax";
"callable: programmatic";
"args: none";
"returns: LIST";
"notes: Compile-tested against a live MOO scratch verb.";

integer_value = 42;
float_value = 3.5;
string_value = "ready";
error_value = E_INVARG;
object_value = this;
list_value = {integer_value, float_value, string_value, error_value, object_value};
return list_value;
