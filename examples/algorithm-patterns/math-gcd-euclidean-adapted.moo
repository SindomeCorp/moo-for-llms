"title: algorithm-math-gcd-euclidean";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:gcd with permission from Sindome (www.sindome.org); ToastStunt min/max builtins, assignment-in-condition, and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: INT left, INT right";
"returns: INT|ERR";
"notes: Shows the Euclidean algorithm with explicit loop-state updates.";

":gcd_euclidean(INT left, INT right) => INT|ERR";
"Called by math helpers to compute the greatest common divisor.";
{left, right} = args;
if (typeof(left) != INT || typeof(right) != INT)
  return E_TYPE;
endif
if (left < 0)
  left = 0 - left;
endif
if (right < 0)
  right = 0 - right;
endif
if (left == 0)
  return right;
elseif (right == 0)
  return left;
endif
while (right != 0)
  remainder = left % right;
  left = right;
  right = remainder;
endwhile
return left;
