"title: object-match-feedback-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:object_match_failed with permission from Sindome (www.sindome.org); raw-object special cases, stats hooks, and VMS history removed.";
"license: used-with-permission";
"topic: command-parser";
"callable: command";
"args: OBJ|INT match_result, STR text";
"returns: INT";
"notes: Shows a command helper that centralizes common object-match failure messages.";

":object_match_failed(MIXED match_result, STR text) => INT";
"Called by command verbs after player:my_match_object(text) to report common match failures.";
{match_result, text} = args;
if (match_result == $nothing)
  player:tell("You must give the name of some object.");
elseif (match_result == $failed_match)
  player:tell("I see no \"", text, "\" here.");
elseif (match_result == $ambiguous_match)
  player:tell("I don't know which \"", text, "\" you mean.");
elseif (!valid(match_result))
  player:tell(match_result, " does not exist.");
else
  return 0;
endif
return 1;
