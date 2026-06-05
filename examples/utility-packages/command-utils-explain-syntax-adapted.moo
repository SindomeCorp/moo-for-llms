"title: utility-command-utils-explain-syntax";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:explain_syntax with permission from Sindome (www.sindome.org); player feedback and short refs replaced with returned suggestions.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ location, STR verb_name, LIST candidates";
"returns: LIST";
"notes: Shows command parser argspec inspection without printing player feedback.";

":explain_syntax(OBJ location, STR verb_name, LIST candidates) => LIST";
"Return syntax summaries for candidate objects that define verb_name.";
{location, verb_name, candidates} = args;
suggestions = {};
for object in ({location, @candidates})
  if (!valid(object))
    continue;
  endif
  found = $object_utils:has_verb(object, verb_name);
  if (found)
    argspec = verb_args(found[1], verb_name);
    suggestions = {@suggestions, tostr(verb_name, " ", argspec[1], " ", argspec[2], " ", argspec[3])};
  endif
endfor
return suggestions;
