"title: programmatic-contract";
"dialect: portable";
"source: original";
"license: MIT";
"topic: good-moo-code";
"callable: programmatic";
"args: STR status";
"returns: INT|ERR";
"notes: Shows a compact programmatic verb contract with caller_perms() authorization and documented return flow.";

":set_status(STR status) => INT|ERR";
"Called by setup helpers to update this.status; returns E_PERM if caller_perms() cannot control this object.";
{status} = args;
if (!$perm_utils:controls(caller_perms(), this))
  return E_PERM;
endif
this.status = status;
return 1;
