" title: string-utils-trim";
" dialect: portable";
" source: original";
" license: MIT";
" topic: core-utilities";
" callable: programmatic";
" notes: uses a LambdaCore-style $string_utils helper";

":normalized_name(STR text) => STR";
"Called by parsing helpers to trim input text with a core utility verb.";
{text} = args;
return $string_utils:trim(text);
