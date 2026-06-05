" title: command-parser-vars";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: command";
" notes: bad snippets are shown in comments; executable body is the corrected version";

" bad:";
" player:tell(\"You use \" + direct_object.name);";
" player:tell(\"Preposition: \" + prep);";
" fixed:";
if (valid(dobj))
  player:tell("You use " + dobj.name + ".");
else
  player:tell("You use " + dobjstr + ".");
endif

player:tell("Preposition: " + prepstr);
