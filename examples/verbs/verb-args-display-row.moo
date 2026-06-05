"title: verb-args-display-row";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: STR|ERR";
"notes: Formats verb_args data for display without changing the verb.";

":verb_args_row(OBJ object, STR verb_name) => STR|ERR";
"Called by verb listing helpers to render direct/preposition/indirect args.";
{object, verb_name} = args;
argspec = `verb_args(object, verb_name) ! E_VERBNF, E_PERM => E_VERBNF';
if (typeof(argspec) == ERR)
  return argspec;
endif
return tostr(argspec[1], " ", argspec[2], " ", argspec[3]);
