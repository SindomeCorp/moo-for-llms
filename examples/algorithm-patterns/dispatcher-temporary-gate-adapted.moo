"title: algorithm-dispatcher-temporary-gate";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $dispatcher:passes_faction_aide_gate and $dispatcher:add_faction_aide_gate with permission from Sindome (www.sindome.org); faction/location policy and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: LIST gates, MIXED group, MIXED location, STR mode, ?INT ttl";
"returns: LIST|INT";
"notes: Shows temporary duplicate-suppression gates keyed by location and group.";

":temporary_gate(LIST gates, MIXED group, MIXED location, STR mode, ?INT ttl) => LIST|INT";
"Called by dispatcher-style helpers to test or add a temporary duplicate-suppression gate.";
{gates, group, location, mode, ?ttl = 300} = args;
if (mode == "check")
  for gate in (gates)
    {gate_location, gate_group, gate_expires} = gate;
    if (location == gate_location && group == gate_group && time() < gate_expires)
      return 0;
    endif
  endfor
  return 1;
elseif (mode == "add")
  return {@gates, {location, group, time() + ttl}};
endif
return E_INVARG;
