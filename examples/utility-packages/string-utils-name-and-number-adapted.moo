"title: utility-string-utils-name-and-number";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:name_and_number with permission from Sindome (www.sindome.org); VMS metadata, raw object literals, and short utility refs removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: OBJ|LIST objects, ?STR separator";
"returns: STR";
"notes: Shows formatting one object or a list of objects with recycler-aware validity.";

":name_and_number(OBJ|LIST objects, ?STR separator) => STR";
"Return names and object numbers for one object or a list of objects.";
{objects, ?separator = " "} = args;
if (typeof(objects) != LIST)
  objects = {objects};
endif
names = {};
for object in (objects)
  name = $recycler:valid(object) ? object.name | (valid(object) ? object.name | "<invalid>");
  names = {@names, tostr(name, separator, "(", object, ")")};
endfor
return $string_utils:english_list(names);
