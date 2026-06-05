"title: utility-math-utils-is-prime";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:is_prime with permission from Sindome (www.sindome.org); VMS metadata removed and assignment-inside-condition avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: INT number";
"returns: INT|ERR";
"notes: Shows a bounded numeric loop that yields when task resources run low.";

":is_prime(INT number) => INT|ERR";
"Return 1 if number is prime, 0 if not prime, or E_TYPE for a non-integer argument.";
{number} = args;
if (typeof(number) != INT)
  return E_TYPE;
elseif (number == 2)
  return 1;
elseif (number < 2 || number % 2 == 0)
  return 0;
endif
candidate = 3;
while (candidate * candidate <= number)
  if (seconds_left() < 2 || ticks_left() < 25)
    suspend(0);
  endif
  if (number % candidate == 0)
    return 0;
  endif
  candidate = candidate + 2;
endwhile
return 1;
