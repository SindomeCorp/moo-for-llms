"title: utility-string-utils-side-by-side";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:side_by_side with permission from Sindome (www.sindome.org); ANSI-specific width handling and short refs removed.";
"license: used-with-permission";
"topic: utility-packages";
"callable: programmatic";
"args: ?INT space, LIST ...";
"returns: LIST";
"notes: Shows formatting multiple lists of display lines side by side.";

":side_by_side(?INT space, LIST ...) => LIST";
"Return display lines formed by placing paragraphs side by side with fixed spacing.";
{?space = 2, @paragraphs} = args;
widths = {};
max_lines = 0;
for paragraph in (paragraphs)
  width = 0;
  for line in (paragraph)
    width = max(width, length(line));
  endfor
  widths = {@widths, width};
  max_lines = max(max_lines, length(paragraph));
endfor
output = {};
for line_index in [1..max_lines]
  line = "";
  for paragraph_index in [1..length(paragraphs)]
    text = `paragraphs[paragraph_index][line_index] ! E_RANGE => ""';
    line = tostr(line, line ? $string_utils:space(space) | "", $string_utils:left(text, widths[paragraph_index]));
  endfor
  output = {@output, line};
endfor
return output;
