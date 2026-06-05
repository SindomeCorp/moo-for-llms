"title: algorithm-string-prefix-match";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:find_prefix with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: STR prefix, LIST choices, ?INT return_list";
"returns: INT|LIST|OBJ";
"notes: Shows prefix matching with both first/ambiguous result mode and list-of-matches mode.";

":find_prefix_match(STR prefix, LIST choices, ?INT return_list) => INT|LIST|OBJ";
"Called by command parsers to resolve abbreviated words.";
{prefix, choices, ?return_list = 0} = args;
if (return_list)
  matches = {};
  for choice in (choices)
    if (index(choice, prefix) == 1)
      matches = {@matches, choice};
    endif
  endfor
  return matches;
endif
answer = 0;
for index in [1..length(choices)]
  if (index(choices[index], prefix) == 1)
    if (answer == 0)
      answer = index;
    else
      answer = $ambiguous_match;
    endif
  endif
endfor
return answer;
