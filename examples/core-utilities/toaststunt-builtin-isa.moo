" title: toaststunt-builtin-isa";
" dialect: toaststunt";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" dialect_reason: uses ToastStunt isa() server builtin instead of a core utility verb";

":is_kind_of_fast(OBJ object, OBJ parent) => INT";
"Called by ToastStunt-only helpers to test ancestry using the server builtin.";
{object, parent} = args;
return isa(object, parent);
