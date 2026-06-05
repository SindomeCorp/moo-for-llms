"title: structured-result-return";
"dialect: portable";
"source: original";
"license: MIT";
"topic: errors";
"callable: programmatic";
"args: OBJ target";
"returns: LIST";
"notes: Programmatic helper with consistent structured success and failure results.";

":target_name(OBJ target) => LIST";
"Called by API consumers that expect {success, value_or_error}.";
{target} = args;
if (!valid(target))
  return {0, E_INVARG};
endif
return {1, target.name};
