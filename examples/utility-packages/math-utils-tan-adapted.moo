"title: utility-math-utils-tan";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $math_utils:tan with permission from Sindome (www.sindome.org); VMS metadata removed and direct ToastStunt tan() builtin call avoided.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: NUM theta";
"returns: NUM";
"notes: Shows composing a tangent helper from sine and cosine utility methods.";

":tan(NUM theta) => NUM";
"Return tangent using this:sin(theta) and this:cos(theta).";
{theta} = args;
sine = this:sin(theta);
cosine = this:cos(theta);
return (sine * 10000 + (cosine + 1) / 2) / cosine;
