" title: structured-result";
" dialect: portable";
" source: original";
" license: MIT";
" topic: errors";
" callable: programmatic";

":lookup_setting(STR key) => LIST";
"Called by other verbs; returns {1, value} on success or {0, error} on failure.";
{key} = args;
if (typeof(key) != STR || !key)
  return {0, E_INVARG};
endif

value = `this.settings[key] ! E_RANGE, E_TYPE => E_RANGE';
if (typeof(value) == ERR)
  return {0, value};
endif

return {1, value};
