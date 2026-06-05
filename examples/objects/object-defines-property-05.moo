"title: object-defines-property-05";
"dialect: portable";
"source: original";
"license: MIT";
"topic: objects";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Object, property, or verb introspection example.";

":defines_property_5(OBJ object, STR prop) => INT";
"Called by object utilities to test for a directly visible property.";
{object, prop} = args;
return prop in properties(object);
