" title: starts-or-ends-with";
" dialect: portable";
" source: approved-generic-sindome";
" license: Used with permission from Sindome (https://www.sindome.org/)";
" topic: strings";
"callable: programmatic";
" provenance: adapted from $string_utils:starts_with / $string_utils:ends_with";

":starts_with(<phrase> STR, <string> STR, [<case-matters> INT]) => 1 or 0";
":ends_with(<phrase> STR, <string> STR, [<case-matters> INT])   => 1 or 0";
"";
"  Returns 1 if the <phrase> starts or ends with the <string>.";
"  Case only matters if <case-matters> is provided and a positive value.";
{phrase, pattern, ?casematters = 0} = args;
if (verb == "starts_with")
  cmd = "index";
  true = 1;
else
  cmd = "rindex";
  if (length(phrase) < length(pattern))
    return 0;
  endif
  true = length(phrase) + 1 - length(pattern);
endif
return call_function(cmd, phrase, pattern, casematters) == true;
