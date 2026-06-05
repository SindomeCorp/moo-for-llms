" title: command-args-words";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
" setup: @verb object:tag any any any";
" callable: command";

if (!args)
  player:tell("Usage: tag <word> [word...]");
  return;
endif

for word in (args)
  player:tell("Tag: " + word);
endfor
