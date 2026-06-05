"title: utility-command-utils-running-out-of-time";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $command_utils:running_out_of_time with permission from Sindome (www.sindome.org); VMS metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: none";
"returns: INT";
"notes: Shows task resource checks and a specific quota fallback.";

":running_out_of_time() => INT";
"Return true when the current task is low on ticks or seconds.";
try
  return ticks_left() < 4000 || seconds_left() < 2;
except (E_QUOTA)
  "If the quota check itself fails, treat the task as out of time.";
  return 1;
endtry
