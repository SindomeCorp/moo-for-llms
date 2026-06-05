" title: list-utils-slice";
" dialect: portable";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" notes: uses a LambdaCore-style $list_utils helper rather than a server builtin";

":middle_items(LIST items, INT first, INT last) => LIST";
"Called by list helpers to return a slice using a core utility verb.";
{items, first, last} = args;
return $list_utils:slice(items, first, last);
