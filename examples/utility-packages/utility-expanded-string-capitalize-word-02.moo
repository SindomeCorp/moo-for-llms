"title: utility-expanded-string-capitalize-word-02";
"dialect: portable";
"source: original";
"license: MIT";
"topic: utility-packages";
"callable: programmatic";
"args: STR text";
"returns: STR";
"notes: Original generated utility-style coverage example; not copied from a live utility verb.";

":capitalize_word_2(STR text) => STR";
"Called by utility package examples to demonstrate a focused helper pattern.";
{text} = args;
if (!text)
  return text;
endif
return $string_utils:uppercase(text[1]) + text[2..$];
