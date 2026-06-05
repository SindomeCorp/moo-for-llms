"title: utility-code-utils-is-verb-queued";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:is_verb_queued with permission from Sindome (www.sindome.org); VMS metadata removed and true/false utility constants replaced with portable integers.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ object, STR verb_name";
"returns: INT";
"notes: Shows scanning queued_tasks() for a queued verb and explains the suspended-call limitation.";

":is_verb_queued(OBJ object, STR verb_name) => INT";
"Return 1 if queued_tasks() currently shows object:verb_name as queued; forked/suspended callees may obscure the original verb.";
{object, verb_name} = args;
for task in (queued_tasks())
  if (task[9] == object && task[7] == verb_name)
    return 1;
  endif
endfor
return 0;
