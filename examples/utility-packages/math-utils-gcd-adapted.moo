"title: utility-math-utils-gcd";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:gcd with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT left, INT right";
"returns: INT";
"notes: Shows the Euclidean algorithm with a zero guard.";

":gcd(INT left, INT right) => INT";
"Called by numeric helpers to find the greatest common divisor.";
{left, right} = args;
left = abs(left);
right = abs(right);
if (!left)
  return right;
elseif (!right)
  return left;
endif
while (right)
  remainder = left % right;
  left = right;
  right = remainder;
endwhile
return left;
