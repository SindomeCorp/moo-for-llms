"title: private-dispatcher-helper";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"callable: programmatic";
"args: OBJ who, STR message";
"returns: INT|ERR";
"notes: Shows a private helper callable only by this object or this.dispatcher.";

":queue_notice(OBJ who, STR message) => INT|ERR";
"Called by this object and this.dispatcher to queue delayed notices.";
{who, message} = args;
if (caller != this && caller != this.dispatcher)
  raise(E_PERM);
endif
if (!valid(who))
  return E_INVARG;
endif
this.notice_queue = {@this.notice_queue, {who, message}};
return 1;
