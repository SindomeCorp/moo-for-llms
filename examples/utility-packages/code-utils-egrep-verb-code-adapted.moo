"title: utility-code-utils-egrep-verb-code";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:_egrep_verb_code with permission from Sindome (www.sindome.org); source-control metadata removed and target changed from verb names to verb_code lines.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: STR pattern, OBJ object, STR verb_name, ?INT case_matters";
"returns: LIST|ERR";
"notes: Shows intentional caller-permission delegation before reading verb code and matching lines.";

":egrep_verb_code(STR pattern, OBJ object, STR verb_name, ?INT case_matters) => LIST|ERR";
"Return lines in object:verb_name whose source matches pattern.";
set_task_perms(caller_perms());
{pattern, object, verb_name, ?case_matters = 0} = args;
code = `verb_code(object, verb_name) ! E_VERBNF, E_PERM => E_PERM';
if (code == E_PERM)
  return E_PERM;
endif
matches = {};
for line in (code)
  try
    if (match(line, pattern, case_matters))
      matches = {@matches, line};
    endif
  except (E_INVARG)
    return E_INVARG;
  endtry
endfor
return matches;
