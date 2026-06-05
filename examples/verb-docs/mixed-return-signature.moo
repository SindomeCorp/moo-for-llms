" title: mixed-return-signature";
" dialect: portable";
" source: original";
" license: MIT";
" topic: verb-docs";
" callable: programmatic";

":find_named_object(STR name, LIST candidates, ?INT quiet) => MIXED";
"Called by matching helpers. Returns the matched object, 0 when quiet and no match is found, or a string error message.";
{name, candidates, ?quiet = 0} = args;
for candidate in (candidates)
  if (valid(candidate) && candidate.name == name)
    return candidate;
  endif
endfor

return quiet ? 0 | "No matching object.";
