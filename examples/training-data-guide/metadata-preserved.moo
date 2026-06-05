"title: metadata-preserved";
"dialect: portable";
"source: original";
"license: MIT";
"topic: training-data-guide";
"callable: fragment";
"notes: Demonstrates preserving metadata as training signal before exporting or filtering examples.";

" Keep dialect, source, license, topic, callable, and provenance metadata with code examples.";
" Do not train on repair-example bad snippets as target code unless the label and fixed version are included.";
" Hold eval rows out of training when they are meant to measure generalization.";
return "metadata preserved";
