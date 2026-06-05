"title: utility-math-utils-round";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:round with permission from Sindome (www.sindome.org); VMS metadata and historical comment code removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: FLOAT number, ?INT mode";
"returns: FLOAT";
"notes: Shows optional mode-based numeric rounding without ToastStunt trunc().";

":round(FLOAT number, ?INT mode) => FLOAT";
"Round number according to mode: 1 rounds 5-9 up, 2 rounds 6-9 up, 3 rounds odd first decimals up.";
{number, ?mode = 1} = args;
rounded = tofloat(toint(number));
decimal = toint((number - rounded) * 10.0);
if (mode == 1)
  rounded = decimal > 4 ? rounded + 1.0 | rounded;
elseif (mode == 2)
  rounded = decimal > 5 ? rounded + 1.0 | rounded;
elseif (mode == 3)
  rounded = decimal % 2 ? rounded + 1.0 | rounded;
endif
return rounded;
