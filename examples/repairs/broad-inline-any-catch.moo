" title: broad-inline-any-catch";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" value = `toint(text) ! ANY => 0';";
" fixed:";
":parse_count(STR text) => INT|ERR";
"Called by other verbs; catches only expected conversion errors.";
{text} = args;
return `toint(text) ! E_INVARG, E_TYPE => E_INVARG';
