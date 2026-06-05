"title: utility-code-utils-verb-documentation";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:verb_documentation with permission from Sindome (www.sindome.org); VMS metadata removed and broad catch narrowed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: ?OBJ object, ?STR verb_name";
"returns: LIST|ERR";
"notes: Shows intentional delegation to caller_perms() before reading verb_code and extracting leading string comments.";

":verb_documentation(?OBJ object, ?STR verb_name) => LIST|ERR";
"Return leading string-literal documentation comments from a verb, defaulting to the calling verb.";
set_task_perms(caller_perms());
stack = callers();
caller_frame = stack[1];
{?object = caller_frame[4], ?verb_name = caller_frame[2]} = args;
code = `verb_code(object, verb_name) ! E_INVARG, E_PERM => E_PERM';
if (code == E_PERM)
  return E_PERM;
endif
documentation = {};
for line in (code)
  if (!match(line, "^\"%([^\"]%|\\.%)*\";$"))
    return documentation;
  endif
  documentation = {@documentation, line};
endfor
return documentation;
