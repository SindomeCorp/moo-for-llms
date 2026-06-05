"title: title-case-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:title_case with permission from Sindome (www.sindome.org); short refs and VMS history removed.";
"license: used-with-permission";
"topic: strings";
"callable: programmatic";
"args: STR title";
"returns: STR";
"notes: Shows list membership checks and utility calls while preserving small words in title case.";

":title_case(STR title) => STR";
"Called by display helpers to normalize a heading while keeping articles and small connector words lowercase.";
{title} = args;
small_words = {"a", "an", "the", "and", "but", "for", "from", "in", "of", "on", "to", "with"};
pieces = $string_utils:explode(title);
result = {};
for piece in (pieces)
  piece = $string_utils:lowercase(piece);
  if (piece in small_words)
    result = {@result, piece};
  else
    result = {@result, $string_utils:capitalize(piece)};
  endif
endfor
return $string_utils:from_list(result, " ");
