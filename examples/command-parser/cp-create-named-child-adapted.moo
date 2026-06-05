"title: cp-create-named-child-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $builder:@create with permission from Sindome (www.sindome.org); quota, broadcast, raw object, and VMS details removed.";
"license: used-with-permission";
"topic: command-parser";
"setup: @verb object:@create any any any";
"callable: command";
"args: command parser variables";
"returns: none";
"notes: Shows a real command pattern for parsing '@create <parent> named <name>' or '@create <parent> called <name>'.";

":@create() => none";
"Called by builders as '@create <parent> named <name>' or '@create <parent> called <name>'.";
nargs = length(args);
pos = "named" in args;
if (pos <= 1 || pos == nargs)
  pos = "called" in args;
endif
if (pos <= 1 || pos == nargs)
  player:tell("Usage: @create <parent> named <name>");
  return;
endif

parent_text = $string_utils:from_list(args[1..pos - 1], " ");
name_text = $string_utils:from_list(args[pos + 1..$], " ");
parent_object = player:my_match_object(parent_text);
if ($command_utils:object_match_failed(parent_object, parent_text))
  return;
endif

object = `create(parent_object, player) ! E_PERM, E_QUOTA, E_INVARG';
if (typeof(object) == ERR)
  player:tell("Unable to create object: ", object);
  return;
endif
if (name_text != "realname")
  object.name = name_text;
  `object:set_aliases({name_text}) ! E_VERBNF, E_PERM, E_INVARG';
endif
`move(object, player) ! E_NACC, E_PERM, E_RECMOVE';
player:tell("Created ", object.name, ".");
