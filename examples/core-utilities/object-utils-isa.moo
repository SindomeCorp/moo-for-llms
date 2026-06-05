" title: object-utils-isa";
" dialect: portable";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" notes: uses a LambdaCore-style $object_utils helper rather than a server builtin";

":is_kind_of(OBJ object, OBJ parent) => INT";
"Called by matching helpers to test ancestry through a core utility verb.";
{object, parent} = args;
return $object_utils:isa(object, parent);
