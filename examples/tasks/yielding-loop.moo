" title: yielding-loop";
" dialect: portable";
" source: original";
" license: MIT";
" topic: tasks";
"callable: programmatic";

for item in (this.pending_items)
  this:process_item(item);
  if (ticks_left() < 1000)
    suspend(0);
  endif
endfor
