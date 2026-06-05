" title: long-verb-extract-helper";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: programmatic";
" notes: bad snippet is shown in comments; executable body is the extracted helper pattern";

" bad:";
" A command verb parses input, validates permissions, mutates state, formats output, and sends notifications in one long body.";
" fixed:";
":format_status_line(OBJ who, LIST stats) => STR";
"Called by larger commands after parsing and validation have already happened.";
{who, stats} = args;
return tostr(who.name, ": ", toliteral(stats));
