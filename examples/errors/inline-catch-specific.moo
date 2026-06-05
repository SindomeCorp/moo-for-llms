" title: inline-catch-specific";
" dialect: portable";
" source: original";
" license: MIT";
" topic: errors";
" callable: programmatic";

":to_positive_int(STR text) => INT|ERR";
"Called by parsers to convert text; catches only conversion errors and preserves invalid positive values.";
{text} = args;
value = `toint(text) ! E_INVARG, E_TYPE => E_INVARG';
if (typeof(value) == ERR)
  return value;
elseif (value < 1)
  return E_INVARG;
endif

return value;
