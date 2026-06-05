" title: broad-except-any";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" try";
"   value = object.(prop);";
" except (ANY)";
"   value = 0;";
" endtry";
" fixed:";
":read_optional_property(OBJ object, STR prop, ANY fallback) => ANY";
"Called by other verbs; catches only missing-property errors and preserves other failures.";
{object, prop, fallback} = args;
try
  value = object.(prop);
except (E_PROPNF)
  value = fallback;
endtry

return value;
