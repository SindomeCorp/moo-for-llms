"title: split-first-delimiter";
"dialect: portable";
"source: original";
"license: MIT";
"topic: strings";
"callable: programmatic";
"args: STR text, STR delimiter";
"returns: LIST";
"notes: Shows splitting only on the first delimiter without losing remaining text.";

":split_first(STR text, STR delimiter) => LIST";
"Called by parsers that need {left, right} around the first delimiter.";
{text, delimiter} = args;
position = index(text, delimiter);
if (!position)
  return {text, ""};
endif
return {text[1..position - 1], text[position + length(delimiter)..$]};
