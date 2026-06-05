"title: utility-code-utils-get-verbs-json";
"dialect: core-specific";
"dialect_reason: Uses ToastStunt maps and JSON generation plus Sindome VMS/core helper conventions.";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:get_verbs_json with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object";
"returns: STR";
"notes: Shows code introspection, delegation with caller_perms(), map assembly, and JSON output.";

":get_verbs_json(OBJ object) => STR";
"Return JSON describing the verbs defined on object.";
{object} = args;
$critical(object);
set_task_perms(caller_perms());
data = ["object" -> object, "owner" -> object.owner, "name" -> object:name()];
verb_count = 1;
verbs = [];
while (typeof(info = `verb_info(object, verb_count) ! ANY') != ERR)
  verbs[verb_count] = ["owner" -> info[1], "permissions" -> info[2], "name" -> info[3], "args" -> verb_args(object, verb_count), "last updated" -> `$vms2:get_comments(verb_code(object, verb_count))[2] ! E_VERBNF => "UNKNOWN"'];
  verb_count = verb_count + 1;
  if (verb_count > 500)
    $critical("aborting verb count > 500");
    return;
  endif
endwhile
data["verbs"] = verbs;
return generate_json(data);
