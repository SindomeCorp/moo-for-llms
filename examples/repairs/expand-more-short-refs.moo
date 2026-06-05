" title: expand-more-short-refs";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
"callable: fragment";
" notes: bad snippets are shown in comments; executable body is the corrected version";

" bad:";
" text = $su:trim(text);";
" $cu:suspend_if_needed(0);";
" fixed:";
{text} = args;
text = $string_utils:trim(text);
$command_utils:suspend_if_needed(0);
return text;
