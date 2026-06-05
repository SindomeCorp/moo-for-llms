"title: break-on-first-match";
"dialect: portable";
"source: original";
"license: MIT";
"topic: loops";
"callable: programmatic";
"args: LIST rows, MIXED key";
"returns: LIST";
"notes: Shows using break after the first successful match while preserving a default result.";

":first_matching_row(LIST rows, MIXED key) => LIST";
"Called by lookup helpers that only need the first row whose first column matches key.";
{rows, key} = args;
match = {};
for row in (rows)
  if (typeof(row) == LIST && length(row) && row[1] == key)
    match = row;
    break;
  endif
endfor
return match;
