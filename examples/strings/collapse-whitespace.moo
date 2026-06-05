"title: collapse-whitespace";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: STR text";
"returns: STR";
"notes: Normalizes whitespace by splitting and rejoining words.";

":collapse_whitespace(STR text) => STR";
"Called by display helpers before comparing or storing user-entered text.";
{text} = args;
words = $string_utils:explode(text);
return $string_utils:from_list(words, " ");
