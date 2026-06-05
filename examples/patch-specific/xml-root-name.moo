"title: xml-root-name";
"dialect: patch-specific";
"dialect_reason: Uses xml_parse_document from a public non-stock XML parser patch.";
"source: original";
"license: MIT";
"topic: patch-specific-builtins";
"callable: programmatic";
"args: STR xml";
"returns: STR|ERR";
"notes: Patch-specific XML parser example; not stock LambdaMOO or baseline ToastStunt.";

":xml_root_name(STR xml) => STR|ERR";
"Called by XML import helpers on cores that installed the XML parser patch.";
{xml} = args;
document = `xml_parse_document(xml) ! E_INVARG, E_TYPE => E_INVARG';
if (typeof(document) == ERR)
  return document;
endif
return document[1];
