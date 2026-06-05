"title: utility-string-utils-unshorten-direction";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:unshorten_direction with permission from Sindome (www.sindome.org); VMS metadata removed and ToastStunt map literal replaced with a portable alist.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR direction";
"returns: STR";
"notes: Shows replacing a map lookup with portable alist lookup.";

":unshorten_direction(STR direction) => STR";
"Return the long form of a common direction abbreviation, or direction if it is not abbreviated.";
{direction} = args;
directions = {{"s", "south"}, {"n", "north"}, {"e", "east"}, {"w", "west"}, {"ne", "northeast"}, {"se", "southeast"}, {"sw", "southwest"}, {"nw", "northwest"}, {"u", "up"}, {"d", "down"}};
row = $list_utils:assoc(direction, directions);
return row ? row[2] | direction;
