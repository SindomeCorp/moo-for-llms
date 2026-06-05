"title: repair-api-player-tell-05";
"dialect: portable";
"source: original";
"license: MIT";
"topic: repairs";
"callable: programmatic";
"args: varies";
"returns: varies";
"notes: Contrastive repair example with bad pattern documented as string comments.";

"bad: programmatic helpers print routine errors to player.";
"fixed: return an error value to the caller.";
{target} = args;
if (!valid(target))
  return E_INVARG;
endif
return target:apply();
