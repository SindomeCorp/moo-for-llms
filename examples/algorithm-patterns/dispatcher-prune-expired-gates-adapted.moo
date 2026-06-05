"title: algorithm-dispatcher-prune-expired-gates";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $dispatcher:_auto_prune with permission from Sindome (www.sindome.org); property mutation and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST gates";
"returns: LIST";
"notes: Shows pruning expired temporary gate rows by timestamp.";

":prune_expired_gates(LIST gates) => LIST";
"Called by cleanup tasks to keep only temporary gates whose expiration is still in the future.";
{gates} = args;
valid_gates = {};
for gate in (gates)
  {gate_location, gate_group, gate_expires} = gate;
  if (time() < gate_expires)
    valid_gates = {@valid_gates, gate};
  endif
endfor
return valid_gates;
