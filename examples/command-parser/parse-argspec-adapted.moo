"title: parse-argspec-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:parse_argspec with permission from Sindome (www.sindome.org); VMS history removed.";
"license: used-with-permission";
"topic: command-parser";
"callable: programmatic";
"args: STR ...";
"returns: LIST|STR";
"notes: Shows parsing direct object specifier, preposition text, indirect object specifier, and remaining words.";

":parse_argspec(@STR words) => LIST|STR";
"Called by code utilities that parse LambdaCore-style verb argspec text.";
count = length(args);
if (!count)
  return {{}, {}};
endif
direct = args[1];
if (!(direct in {"this", "any", "none"}))
  return tostr("\"", direct, "\" is not a valid direct object specifier.");
elseif (count < 2 || args[2] in {"none", "any"})
  verbargs = args[1..min(3, count)];
  rest = args[4..count];
else
  prep = $code_utils:get_prep(@args[2..count]);
  if (!prep[1])
    return tostr("\"", args[2], "\" is not a valid preposition.");
  endif
  verbargs = {direct, @prep[1..min(2, length(prep))]};
  rest = prep[3..length(prep)];
endif
if (length(verbargs) >= 3 && !(verbargs[3] in {"this", "any", "none"}))
  return tostr("\"", verbargs[3], "\" is not a valid indirect object specifier.");
endif
return {verbargs, rest};
