"title: caller-perms-set-name-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $root_class:set_name with permission from Sindome (www.sindome.org); historical metadata removed and short refs expanded.";
"license: used-with-permission";
"topic: permissions";
"callable: programmatic";
"args: STR new_name";
"returns: LIST|ERR";
"notes: Shows caller_perms() as programmatic authority for a mutation helper.";

":set_name(STR new_name) => LIST|ERR";
"Called by object-management helpers to rename this object and update aliases.";
{new_name} = args;
who = caller_perms();
if (!who.wizard && (is_player(this) || (who != this.owner && caller != this)))
  return E_PERM;
endif
name_result = `this.name = new_name ! E_PERM, E_INVARG';
alias_result = `this:set_aliases({@$string_utils:explode(new_name), new_name}) ! E_PERM, E_INVARG, E_VERBNF';
return {typeof(name_result) == ERR ? name_result | 1, typeof(alias_result) == ERR ? alias_result | 1};
