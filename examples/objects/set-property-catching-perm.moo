" title: set-property-catching-perm";
" dialect: portable";
" source: original";
" license: MIT";
" topic: objects";
" callable: programmatic";

":set_named_property(OBJ target, STR prop, ANY value) => INT|ERR";
"Called by setup code to set an existing property while preserving E_PERM and E_PROPNF failures.";
{target, prop, value} = args;
if (!valid(target))
  return E_INVARG;
endif

result = `target.(prop) = value ! E_PERM, E_PROPNF, E_INVARG';
return typeof(result) == ERR ? result | 1;
