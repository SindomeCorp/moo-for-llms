"title: verb-info-flags-03";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Object, property, or verb introspection example.";

":verb_is_executable_3(OBJ object, STR verb_name) => INT";
"Called by introspection helpers to check whether a direct verb has the x flag.";
{object, verb_name} = args;
info = `verb_info(object, verb_name) ! E_VERBNF, E_PERM => 0';
if (!info)
  return 0;
endif
return index(info[2], "x") && 1;
