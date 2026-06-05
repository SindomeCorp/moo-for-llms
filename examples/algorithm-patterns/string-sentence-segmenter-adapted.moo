"title: algorithm-string-sentence-segmenter";
"dialect: portable";
"source: approved-generic-sindome";
"provenance: Adapted from $string_utils:sentences with permission from Sindome (www.sindome.org); short refs and VMS metadata removed.";
"license: used-with-permission";
"topic: algorithm-patterns";
"callable: programmatic";
"args: STR text";
"returns: LIST";
"notes: Shows collecting words into sentences based on terminal punctuation.";

":sentences_from_text(STR text) => LIST";
"Called by text processors to split a phrase into punctuation-terminated sentences.";
{text} = args;
sentences = {};
sentence = {};
for word in ($string_utils:explode(text))
  $command_utils:suspend_if_needed(0);
  sentence = {@sentence, word};
  if (match(word, "%(%?%|%.%|%!%)"))
    sentences = {@sentences, $string_utils:from_list(sentence, " ")};
    sentence = {};
  endif
endfor
return sentences;
