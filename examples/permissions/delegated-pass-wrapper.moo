"title: delegated-pass-wrapper";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"provenance: modeled after LambdaMOO and ToastStunt manual guidance for intentional set_task_perms delegation";
"callable: programmatic";
"args: MIXED ...";
"returns: MIXED";
"notes: Shows intentional delegation: the wrapper changes task permissions to caller_perms() before pass(@args).";

":set_name_delegated(@MIXED arguments) => MIXED";
"Called by wrapper verbs that should behave as though the caller invoked the inherited implementation directly.";
set_task_perms(caller_perms());
return pass(@args);
