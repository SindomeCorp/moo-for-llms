"title: utility-command-utils-read-selection";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:read_selection with permission from Sindome (www.sindome.org); VMS metadata removed, short utility refs expanded, and broad catch narrowed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: LIST items, ?STR prompt";
"returns: INT";
"notes: Shows reading a numeric selection and validating that it indexes a supplied list.";

":read_selection(LIST items, ?STR prompt) => INT";
"Read a numeric selection and return the selected index, or 0 if the input is invalid.";
{items, ?prompt = "a number"} = args;
selection = `toint($command_utils:read(prompt)) ! E_INVARG, E_TYPE => 0';
if (!selection || !`typeof(items[selection]) != ERR ! E_RANGE => 0')
  return 0;
endif
return selection;
