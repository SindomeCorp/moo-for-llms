"title: toaststunt-bool-strict-return";
"dialect: toaststunt";
"dialect_reason: Uses ToastStunt true BOOL values instead of portable integer truthiness.";
"source: original";
"license: MIT";
"topic: toaststunt";
"callable: programmatic";
"args: OBJ object";
"returns: BOOL";
"notes: Shows returning true or false explicitly in ToastStunt-specific code.";

":is_configured(OBJ object) => BOOL";
"Called by ToastStunt-only APIs that expect a true BOOL result.";
{object} = args;
if (!valid(object))
  return false;
endif
configured = `object.configured ! E_PROPNF => false';
if (typeof(configured) == BOOL)
  return configured;
endif
return configured ? true | false;
