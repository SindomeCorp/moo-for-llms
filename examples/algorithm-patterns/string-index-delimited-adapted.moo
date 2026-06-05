"title: algorithm-string-index-delimited";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:index_delimited with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: STR text, STR target, ?INT case_matters";
"returns: INT";
"notes: Shows matching a word only when it is delimited by non-word boundaries.";

":index_delimited_word(STR text, STR target, ?INT case_matters) => INT";
"Called by scanners to find a target token without matching inside a longer word.";
{text, target, ?case_matters = 0} = args;
pattern = "%(%W%|^%)" + $string_utils:regexp_quote(target) + "%(%W%|$%)";
match_info = match(text, pattern, case_matters);
return match_info ? match_info[3][1][2] + 1 | 0;
