"title: runtime-values-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: language-guide";
"callable: fragment";
"notes: Preserved guidance comments for training data about common MOO runtime variables.";

" Common runtime variables include this, player, caller, args, argstr, verb, dobj, prepstr, and iobj.";
" args is always a LIST populated by the server unless the verb body reassigns it.";
" Command parser variables such as dobj and iobj depend on the verb argspec and user input.";
" Programmatic helpers should document their expected args shape at the top of the verb.";
return "Use runtime variables according to how the verb is called.";
