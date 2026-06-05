"title: sampling-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: training-usage";
"callable: fragment";
"notes: Preserved guidance comments for training split construction.";

" Keep eval rows held out from training.";
" Downweight generated expansion examples when building a small supervised set.";
" Prefer curated live adaptations and original handwritten examples for high-signal codegen.";
return "Use quality tiers when sampling this corpus.";
