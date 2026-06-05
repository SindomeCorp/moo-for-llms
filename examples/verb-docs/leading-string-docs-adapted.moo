"title: leading-string-docs-adapted";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $code_utils:verb_documentation with permission from Sindome (www.sindome.org); broad catch, eval, and VMS history removed.";
"license: used-with-permission";
"topic: verb-docs";
"callable: programmatic";
"args: ?OBJ object, ?STR verbname";
"returns: LIST|ERR";
"notes: Shows extracting preserved top string-literal comments from verb_code().";

":verb_documentation(?OBJ object, ?STR verbname) => LIST|ERR";
"Called by documentation tools to return leading string-literal comment lines from a verb.";
frame = callers()[1];
{?object = frame[4], ?verbname = frame[2]} = args;
code = `verb_code(object, verbname) ! E_PERM, E_VERBNF';
if (typeof(code) == ERR)
  return code;
endif
docs = {};
for line in (code)
  if (line && line[1] == "\"" && line[$] == ";")
    docs = {@docs, line};
  else
    return docs;
  endif
endfor
return docs;
