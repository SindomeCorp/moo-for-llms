"title: object-dynamic-property-02";
"dialect: portable";
"source: original";
"license: MIT";
"topic: objects";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Object, property, or verb introspection example.";

":read_named_property_2(OBJ object, STR prop, MIXED fallback) => MIXED";
"Called by generic display helpers to read a dynamic property with fallback.";
{object, prop, fallback} = args;
return `object.(prop) ! E_PROPNF, E_PERM => fallback';
