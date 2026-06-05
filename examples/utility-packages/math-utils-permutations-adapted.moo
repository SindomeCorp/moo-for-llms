"title: utility-math-utils-permutations";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:permutations with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT n, INT r";
"returns: INT|ERR";
"notes: Shows a compact ordered-count helper with type checks.";

":permutations(INT n, INT r) => INT|ERR";
"Called by probability helpers to count ordered selections.";
{n, r} = args;
if (typeof(n) != INT || typeof(r) != INT)
  return E_TYPE;
endif
if (r < 1 || n - r < 0)
  return 0;
endif
count = 1;
for value in [n - r + 1..n]
  count = count * value;
endfor
return count;
