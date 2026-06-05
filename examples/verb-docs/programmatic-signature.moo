" title: programmatic-signature";
" dialect: portable";
" source: original";
" license: MIT";
" topic: verb-docs";
" callable: programmatic";

":format_status(OBJ who, LIST stats, ?STR filter) => STR";
"Called by status display verbs to build one line of status text for `who`.";
{who, stats, ?filter = ""} = args;
if (filter)
  stats = $list_utils:assoc(filter, stats);
endif

return tostr(who.name, ": ", toliteral(stats));
