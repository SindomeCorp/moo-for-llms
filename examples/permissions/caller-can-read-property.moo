"title: caller-can-read-property";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: OBJ object, STR property";
"returns: INT";
"notes: Shows caller_perms()-based property readability checks for an API helper.";

":caller_can_read_property(OBJ object, STR property) => INT";
"Called by programmatic APIs before exposing a dynamic property value.";
{object, property} = args;
if (!valid(object) || typeof(property) != STR)
  return 0;
endif
info = `property_info(object, property) ! E_PROPNF, E_PERM => 0';
if (!info)
  return 0;
endif
who = caller_perms();
return info[2] in "r" || info[1] == who || who.wizard;
