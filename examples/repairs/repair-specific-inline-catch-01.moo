"title: repair-specific-inline-catch-01";
"dialect: portable";
"source: original";
"license: MIT";
"topic: repairs";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Contrastive repair example with bad pattern documented as string comments.";

"bad: value = `toint(text) ! ANY => 0';";
"fixed: catch the expected conversion errors only.";
{text} = args;
value = `toint(text) ! E_INVARG, E_TYPE => 0';
return value;
