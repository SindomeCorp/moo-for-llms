"title: utility-command-utils-yes-or-no";
"dialect: core-specific";
"dialect_reason: Uses core command-task behavior and Sindome helper packages for NPC and permission handling.";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:yes_or_no with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: ?STR prompt, ?INT abort_mode";
"returns: INT|ERR";
"notes: Shows command-task input handling, caller-derived player lookup, and specific error returns.";

":yes_or_no(?STR prompt, ?INT abort_mode) => INT|ERR";
"Prompt the command player for a yes/no answer and return true for a prefix of yes.";
{?prompt = "", ?abort_mode = this.ABORT} = args;
stack = callers();
command_player = stack[$][5];
command_player:notify(tostr(prompt ? prompt + " " | "", "[Enter `yes' or `no']"));
try
  if ($npc_utils:is_npc(player))
    answer = this:read_npc(player);
  else
    controlled = caller == command_player || $perm_utils:controls(caller_perms(), command_player);
    answer = read(controlled ? {command_player} | {});
  endif
  answer = $string_utils:trim(answer);
  if (answer)
    if (abort_mode != this.NO_ABORT && answer == "@abort")
      command_player:notify(">> Command Aborted <<");
      kill_task(task_id());
    endif
    return index("yes", answer) == 1 || (index("no", answer) != 1 && E_INVARG);
  else
    return E_NONE;
  endif
except error (E_INVARG)
  kill_task(task_id());
except error (ANY)
  return error[1];
endtry
