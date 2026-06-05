"title: computed-verb-call-guarded";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR name, LIST call_args";
"returns: ANY|ERR";
"notes: Shows guarded computed verb dispatch with argument splicing.";

":call_named(OBJ object, STR name, LIST call_args) => ANY|ERR";
"Called by wrapper APIs that dispatch to a caller-selected helper verb.";
{object, name, call_args} = args;
if (!valid(object) || typeof(name) != STR || typeof(call_args) != LIST)
  return E_INVARG;
endif
return `object:(name)(@call_args) ! E_VERBNF, E_PERM, E_INVARG => E_INVARG';
