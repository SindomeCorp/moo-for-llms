"title: utility-object-utils-match-verb";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:match_verb with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: LIST|INT";
"notes: Shows resolving a callable verb name to the object that defines it.";

":match_verb(OBJ object, STR verb_name) => LIST|INT";
"Return {defining_object, normalized_verb_name} when object or an ancestor defines verb_name; return 0 otherwise.";
{object, verb_name} = args;
verb_name = strsub(verb_name, "*", "");
while (E_VERBNF == (info = `verb_info(object, verb_name) ! E_VERBNF, E_INVARG'))
  object = parent(object);
endwhile
return info ? {object, verb_name} | 0;
