"title: xml-result-shape";
"dialect: patch-specific";
"dialect_reason: Uses xml_parse_tree(), a public patch-specific builtin not available on stock LambdaMOO or ToastStunt.";
"source: original";
"license: MIT";
"topic: patch-specific-builtins";
"callable: programmatic";
"args: STR xml";
"returns: LIST|ERR";
"notes: Shows labeling XML parser usage as patch-specific rather than Sindome-specific.";

":parse_xml_fragment(STR xml) => LIST|ERR";
"Called by integrations on cores that have the XML parsing patch installed.";
{xml} = args;
tree = `xml_parse_tree(xml) ! E_INVARG, E_TYPE';
return typeof(tree) == ERR ? tree | tree;
