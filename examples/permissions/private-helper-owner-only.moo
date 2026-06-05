"title: private-helper-owner-only";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: OBJ object, STR value";
"returns: INT|ERR";
"notes: Shows caller_perms() authorization inside a private helper.";

":private_set_label(OBJ object, STR value) => INT|ERR";
"Called only by same-object public wrappers after validating input shape.";
{object, value} = args;
if (!valid(object) || typeof(value) != STR)
  return E_INVARG;
endif
who = caller_perms();
if (!who.wizard && who != object.owner)
  return E_PERM;
endif
object.label = value;
return 1;
