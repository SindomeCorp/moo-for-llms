"title: normalize-command-text";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: STR text";
"returns: STR";
"notes: Shows whitespace normalization through core string utilities.";

":normalize_command_text(STR text) => STR";
"Called by command parsers before comparing user-entered text.";
{text} = args;
words = $string_utils:words(text);
return $string_utils:from_list(words, " ");
