"title: utility-string-utils-capitalize";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:capitalize with permission from Sindome (www.sindome.org); ANSI-specific branches and source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR phrase, ?INT all_words";
"returns: STR";
"notes: Shows optional scatter assignment and simple first-letter capitalization without core-specific ANSI helpers.";

":capitalize(STR phrase, ?INT all_words) => STR";
"Capitalize the first letter of phrase, or each non-common word when all_words is true.";
{phrase, ?all_words = 0} = args;
if (!phrase)
  return phrase;
elseif (!all_words)
  first = index("abcdefghijklmnopqrstuvwxyz", phrase[1], 1);
  if (first)
    phrase[1] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"[first];
  endif
  return phrase;
endif
words = $string_utils:words(phrase);
result = {};
for word in (words)
  common = word in {"a", "an", "and", "of", "the"};
  result = {@result, common ? word | this:capitalize(word)};
endfor
return $string_utils:from_list(result, " ");
