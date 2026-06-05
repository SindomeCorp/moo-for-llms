" title: caller-perms-controls";
" dialect: portable";
" source: original";
" license: MIT";
" topic: permissions";
" provenance: modeled after $root_class:set_name and protected builtin wrappers on $sysobj";
" callable: programmatic";

":set_label(STR label) => ERR|LIST";
"Called by object setup code to change this.name and aliases; returns E_PERM when caller permissions do not control this.";
{label} = args;
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif

return {typeof(e = `this.name = label ! ANY') != ERR || e, typeof(a = `this:set_aliases({label}) ! ANY') != ERR || a};
