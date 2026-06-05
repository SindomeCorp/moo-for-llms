"title: patch-specific-xml-17";
"dialect: patch-specific";
"dialect_reason: Uses XML parsing builtins from a public patch, not stock LambdaMOO or ToastStunt.";
"source: original";
"license: MIT";
"topic: patch-specific-builtins";
"callable: programmatic";
"args: STR xml";
"returns: LIST";

":xml_extract_17(STR xml) => LIST";
"Called by patch-specific examples to parse XML with optional patch builtins.";
{xml} = args;
doc = xml_parse_document(xml);
return doc;
