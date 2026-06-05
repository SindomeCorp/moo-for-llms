" title: words";
" dialect: portable";
" source: approved-generic-sindome";
"license: used-with-permission";
" topic: strings";
"callable: programmatic";
" provenance: adapted from $string_utils:words";

"This breaks up the argument string into words, the resulting list being obtained exactly the way the command line parser obtains `args' from `argstr'.";
{rest, ?quotes = 0, ?mark = "\"", ?patmark = mark} = args;
"...trim leading blanks...";
rest = $string_utils:triml(rest);
if (!rest)
  return {};
endif
quote = 0;
toklist = {};
token = "";
pattern = " +%|\\\\.?%|" + patmark;
while (m = match(rest, pattern))
  "... find the next occurence of a special character, either";
  "... a block of spaces, a quote or a backslash escape sequence...";
  char = rest[m[1]];
  token = token + rest[1..m[1] - 1];
  if (char == " ")
    toklist = {@toklist, token};
    token = "";
  elseif (char == mark)
    "... beginning or end of quoted string...";
    "... within a quoted string spaces aren't special...";
    if (quotes)
      token = token + mark;
    endif
    pattern = ((quote = !quote) ? "\\\\.?%|" | " +%|\\\\.?%|") + patmark;
  elseif (m[1] < m[2])
    "... char has to be a backslash...";
    "... include next char literally if there is one";
    token = token + rest[m[2]];
  endif
  rest[1..m[2]] = "";
endwhile
return rest || char != " " ? {@toklist, token + rest} | toklist;
