"title: match-inherited-verb-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:match_verb with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: verbs";
"callable: programmatic";
"args: OBJ object, STR verbname";
"returns: LIST|INT";
"notes: Shows inherited verb lookup and returning the defining object plus normalized verb name.";

":match_inherited_verb(OBJ object, STR verbname) => LIST|INT";
"Called by code tools that need the object where a verb is actually defined.";
{object, verbname} = args;
verbname = strsub(verbname, "*", "");
while (E_VERBNF == (info = `verb_info(object, verbname) ! E_VERBNF, E_INVARG'))
  object = parent(object);
endwhile
return info ? {object, verbname} | 0;
