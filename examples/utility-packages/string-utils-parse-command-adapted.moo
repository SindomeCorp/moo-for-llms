"title: utility-string-utils-parse-command";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:parse_command with permission from Sindome (www.sindome.org); VMS metadata removed and parser simulation simplified.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR command_line";
"returns: LIST";
"notes: Shows splitting a command string into verb, word args, and raw arg text without relying on command parser variables.";

":parse_command(STR command_line) => LIST";
"Return {verb_name, words, arg_text} for a command-like string.";
{command_line} = args;
words = $string_utils:words(command_line);
if (!words)
  return {};
endif
verb_name = words[1];
arg_words = words[2..$];
arg_text = arg_words ? command_line[length(verb_name) + 2..$] | "";
return {verb_name, arg_words, arg_text};
