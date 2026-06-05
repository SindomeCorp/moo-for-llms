"title: recycler-valid-guard";
"dialect: portable";
"source: original";
"license: MIT";
"topic: object-lifecycle";
"callable: programmatic";
"args: OBJ object";
"returns: OBJ|ERR";
"notes: Shows LambdaCore-style $recycler validity when garbage objects should not be accepted.";

":require_usable_object(OBJ object) => OBJ|ERR";
"Called by lifecycle helpers that must reject recycled garbage objects.";
{object} = args;
if (!$recycler:valid(object))
  return E_INVARG;
endif
return object;
