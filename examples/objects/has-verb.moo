" title: has-verb";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: objects";
"callable: programmatic";
" provenance: adapted from $object_utils:has_verb";

":has_verb(OBJ object, STR verbname)";
"Find out if an object has a verb matching the given verbname.";
"Returns {location} if so, 0 if not, where location is the object or the ancestor on which the verb is actually defined.";
{object, verbname} = args;
while (E_VERBNF == (vi = `verb_info(object, verbname) ! E_VERBNF, E_INVARG'))
  object = parent(object);
endwhile
return vi ? {object} | 0;
