"title: verb-find-direct-definition";
"dialect: portable";
"source: original";
"license: MIT";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR name";
"returns: OBJ|ERR";
"notes: Shows direct verb definition lookup without walking ancestors.";

":find_direct_definition(OBJ object, STR name) => OBJ|ERR";
"Called by code-inspection helpers to find whether object itself defines name.";
{object, name} = args;
if (!valid(object) || typeof(name) != STR)
  return E_INVARG;
endif
for verb_name in (verbs(object))
  if (verb_name == name)
    return object;
  endif
endfor
return E_VERBNF;
