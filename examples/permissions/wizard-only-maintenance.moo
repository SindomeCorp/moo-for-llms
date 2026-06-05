"title: wizard-only-maintenance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: none";
"returns: INT|ERR";
"notes: Shows caller_perms().wizard for programmatic wizard-only maintenance.";

":rebuild_server_cache() => INT|ERR";
"Called by server maintenance code; only wizard-permission tasks may rebuild this cache.";
if (!caller_perms().wizard)
  raise(E_PERM);
endif
this.cache = this:build_cache();
this.cache_built_at = time();
return 1;
