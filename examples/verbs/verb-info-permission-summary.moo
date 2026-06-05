"title: verb-info-permission-summary";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR name";
"returns: LIST|ERR";
"notes: Shows extracting owner and permission flags from verb_info().";

":verb_permission_summary(OBJ object, STR name) => LIST|ERR";
"Called by audit tools to return {owner, flags} for a named verb.";
{object, name} = args;
info = `verb_info(object, name) ! E_VERBNF, E_PERM => E_VERBNF';
if (info == E_VERBNF)
  return info;
endif
return {info[1], info[2]};
