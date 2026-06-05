"title: utility-expanded-command-confirm-word-06";
"dialect: core-specific";
"dialect_reason: Uses or models the $command_utils package as a core-specific utility API in this corpus.";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: STR answer";
"returns: INT|ERR";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":confirm_word_6(STR answer) => INT|ERR";
"Called by utility package examples to demonstrate a focused helper pattern.";
{answer} = args;
answer = $string_utils:trim(answer);
if (index("yes", answer) == 1)
  return 1;
elseif (index("no", answer) == 1)
  return 0;
endif
return E_INVARG;
