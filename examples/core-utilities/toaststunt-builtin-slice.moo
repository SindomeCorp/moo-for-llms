" title: toaststunt-builtin-slice";
" dialect: toaststunt";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" dialect_reason: uses ToastStunt slice() server builtin instead of a core utility verb";

":middle_items_fast(LIST items, INT first, INT last) => LIST";
"Called by ToastStunt-only helpers to return a slice using the server builtin.";
{items, first, last} = args;
return slice(items, first, last);
