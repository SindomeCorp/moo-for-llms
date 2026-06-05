"title: narrow-property-catch";
"dialect: portable";
"source: original";
"license: MIT";
"topic: errors";
"callable: programmatic";
"args: OBJ object, STR property, MIXED fallback";
"returns: MIXED";
"notes: Shows a narrow expected property catch instead of broad ANY handling.";

":property_or_default(OBJ object, STR property, MIXED fallback) => MIXED";
"Called by display helpers that can tolerate a missing optional property.";
{object, property, fallback} = args;
try
  return object.(property);
except (E_PROPNF)
  return fallback;
endtry
