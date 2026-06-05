"title: object-inherited-verb-scan-06";
"dialect: portable";
"source: original";
"license: MIT";
"topic: objects";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Object, property, or verb introspection example.";

":find_verb_owner_6(OBJ object, STR verb_name) => OBJ|INT";
"Called by code tools to find the first ancestor that defines a verb.";
{object, verb_name} = args;
while (valid(object))
  if (`verb_info(object, verb_name) ! E_VERBNF => 0')
    return object;
  endif
  object = parent(object);
endwhile
return 0;
