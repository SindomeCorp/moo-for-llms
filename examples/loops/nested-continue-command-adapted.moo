"title: nested-continue-command-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $root_class:examine_verbs with permission from Sindome (www.sindome.org); gameplay-specific filtering and VMS history removed.";
"license: used-with-permission";
"topic: loops";
"callable: command";
"args: parser variables";
"returns: LIST|ERR";
"notes: Shows nested loops that use continue to skip filtered verbs while building command-facing output.";

":visible_verb_lines(OBJ target) => LIST|ERR";
"Called by examine-style commands to build display lines for callable verbs on target and its ancestors.";
{target} = args;
if (!valid(target))
  return E_INVARG;
endif
results = {};
for object in ({target, @$object_utils:ancestors(target)})
  $command_utils:suspend_if_needed(0);
  verb_list = verbs(object);
  for index in [1..length(verb_list)]
    $command_utils:suspend_if_needed(0);
    info = verb_info(object, index);
    syntax = verb_args(object, index);
    if (!index(info[2], "x"))
      continue;
    elseif (`object.(tostr(info[3], "__help_msg")) ! E_PROPNF => ""')
      continue;
    endif
    {dobj, prep, iobj} = syntax;
    results = {@results, tostr(info[3], " ", dobj, " ", prep, " ", iobj)};
  endfor
endfor
return results;
