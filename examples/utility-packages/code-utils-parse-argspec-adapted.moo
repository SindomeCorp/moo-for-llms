"title: utility-code-utils-parse-argspec";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:parse_argspec with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR ...";
"returns: LIST|STR";
"notes: Shows parsing command argspec tokens, including direct object specifiers, prepositions, and indirect object specifiers.";

":parse_argspec(STR ...) => LIST|STR";
"Parse command argspec tokens and return {verb_args, remaining_args}, or an error string.";
token_count = length(args);
if (token_count < 1)
  return {{}, {}};
elseif ((direct = args[1]) == "tnt")
  return {{"this", "none", "this"}, listdelete(args, 1)};
elseif (!(direct in {"this", "any", "none"}))
  return tostr("\"", direct, "\" is not a valid direct object specifier.");
elseif (token_count < 2 || args[2] in {"none", "any"})
  verb_args = args[1..min(3, token_count)];
  rest = args[4..token_count];
elseif (!(prep_result = $code_utils:get_prep(@args[2..token_count]))[1])
  return tostr("\"", args[2], "\" is not a valid preposition.");
else
  prep_count = length(prep_result);
  verb_args = {direct, @prep_result[1..min(2, prep_count)]};
  rest = prep_result[3..prep_count];
endif
if (length(verb_args) >= 3 && !(verb_args[3] in {"this", "any", "none"}))
  return tostr("\"", verb_args[3], "\" is not a valid indirect object specifier.");
endif
return {verb_args, rest};
