"title: utility-code-utils-verb-or-property";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:verb_or_property with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR name, MIXED ...";
"returns: MIXED";
"notes: Shows intentional delegation to caller_perms() before trying a dynamic verb call and then a property read.";

":verb_or_property(OBJ object, STR name, MIXED ...) => MIXED";
"Call object:name(@rest) if name is a verb; otherwise return object.(name) if it is a readable property.";
set_task_perms(caller_perms());
{object, name, @rest} = args;
return `object:(name)(@rest) ! E_VERBNF, E_INVIND => `object.(name) ! ANY'';
