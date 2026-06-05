"title: scheduling-guidance";
"dialect: portable";
"source: original";
"license: MIT";
"topic: tasks-and-scheduling";
"callable: fragment";
"notes: Preserved guidance comments for training data about fork, suspend, and scheduler helpers.";

" fork creates a later task, so capture needed values before the fork.";
" suspend yields execution, so revalidate objects before mutation afterward.";
" Scheduler utilities can be clearer than ad hoc fork chains for recurring work.";
return "Capture, yield carefully, then revalidate.";
