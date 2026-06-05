" title: echo-argstr";
" dialect: portable";
" source: original";
" license: MIT";
" topic: command-parser";
" setup: @verb object:echo any none none";
" callable: command";

if (!argstr)
  player:tell("Nothing to echo.");
  return;
endif

player:tell(argstr);
