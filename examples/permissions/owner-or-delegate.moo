"title: owner-or-delegate";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: OBJ object, OBJ delegate";
"returns: INT";
"notes: Shows a programmatic permission helper that accepts owner, wizard, or explicit delegate.";

":owner_or_delegate(OBJ object, OBJ delegate) => INT";
"Called by mutation APIs to decide whether caller_perms() may change object.";
{object, delegate} = args;
if (!valid(object))
  return 0;
endif
who = caller_perms();
return who.wizard || who == object.owner || (valid(delegate) && who == delegate);
