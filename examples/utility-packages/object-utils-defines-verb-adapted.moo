"title: utility-object-utils-defines-verb";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $object_utils:defines_verb with permission from Sindome (www.sindome.org); VMS metadata and unreachable historical code removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: INT";
"notes: Shows using verb_info() to test whether a verb is directly defined on an object; broad ANY catch intentionally converts any invalid lookup into false.";

":defines_verb(OBJ object, STR verb_name) => INT";
"Return 1 when object directly defines verb_name; return 0 otherwise.";
{object, verb_name} = args;
return `verb_info(object, verb_name) ! ANY => 0' && 1;
