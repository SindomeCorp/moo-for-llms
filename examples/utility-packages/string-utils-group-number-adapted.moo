"title: utility-string-utils-group-number";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:group_number with permission from Sindome (www.sindome.org); source-control metadata removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT number, ?STR separator";
"returns: STR";
"notes: Shows optional argument destructuring and right-to-left string slicing.";

":group_number(INT number, ?STR separator) => STR";
"Called by formatting helpers to insert a separator every three digits.";
{number, ?separator = ","} = args;
result = "";
sign = number < 0 ? "-" | "";
digits = tostr(abs(number));
while (length(digits) > 3)
  result = separator + digits[$ - 2..$] + result;
  digits = digits[1..$ - 3];
endwhile
return sign + digits + result;
