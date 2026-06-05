"title: caller-perms-wizard-rebuild";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"provenance: modeled after LambdaMOO and ToastStunt manual guidance that builtin access checks use the current task permissions";
"callable: programmatic";
"args: none";
"returns: INT|ERR";
"notes: Shows a programmatic wizard-only guard using caller_perms().wizard instead of player.wizard.";

":rebuild_cache() => INT|ERR";
"Called by administrative maintenance verbs to rebuild this.cache; returns E_PERM unless the calling verb runs with wizard permissions.";
if (!caller_perms().wizard)
  return E_PERM;
endif
this.cache = this:build_cache();
return 1;
