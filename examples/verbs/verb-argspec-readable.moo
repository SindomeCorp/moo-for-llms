"title: verb-argspec-readable";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR name";
"returns: STR|ERR";
"notes: Shows reading a verb argspec and formatting direct/preposition/indirect fields.";

":argspec_readable(OBJ object, STR name) => STR|ERR";
"Called by documentation generators to summarize a command verb argspec.";
{object, name} = args;
spec = `verb_args(object, name) ! E_VERBNF, E_PERM => E_VERBNF';
if (spec == E_VERBNF)
  return spec;
endif
return tostr(spec[1], " ", spec[2], " ", spec[3]);
