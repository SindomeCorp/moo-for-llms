"title: private-helper-caller-verb";
"dialect: portable";
"source: original";
"license: MIT";
"topic: permissions";
"provenance: modeled after private helper guards that restrict calls to a specific coordinating object";
"callable: programmatic";
"args: OBJ who, STR message";
"returns: INT";
"notes: Shows a private helper that permits calls from this object or a configured dispatcher object.";

":queue_private_notice(OBJ who, STR message) => INT";
"Called only by this object or this.dispatcher to queue a deferred notice.";
if (caller != this && caller != this.dispatcher)
  raise(E_PERM);
endif
{who, message} = args;
this.notice_queue = {@this.notice_queue, {who, message}};
return 1;
