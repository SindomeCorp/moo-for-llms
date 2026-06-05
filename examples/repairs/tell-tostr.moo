" title: tell-tostr";
" dialect: portable";
" source: original";
" license: MIT";
" topic: repairs";
" callable: command";
" notes: bad snippet is shown in comments; executable body is the corrected version";

" bad:";
" player:tell(tostr(\"Count: \", count));";
" fixed:";
":@count() => none";
"Called by a player command; passes separate arguments to :tell.";
count = length(this.contents);
player:tell("Count: ", count);
