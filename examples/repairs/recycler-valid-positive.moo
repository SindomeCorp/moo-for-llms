" title: recycler-valid-positive";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" if ($recycler:valid(obj))";
"   return E_INVARG;";
" endif";
" fixed:";
":require_valid(OBJ obj) => OBJ|ERR";
"Called by helpers that need a valid object before continuing.";
{obj} = args;
if (!$recycler:valid(obj))
  return E_INVARG;
endif

return obj;
