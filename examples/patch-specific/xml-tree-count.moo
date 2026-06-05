"title: xml-tree-count";
"dialect: patch-specific";
"dialect_reason: Uses xml_parse_tree from a public non-stock XML parser patch.";
"source: original";
"license: MIT";
"topic: patch-specific-builtins";
"callable: programmatic";
"args: STR xml";
"returns: INT|ERR";
"notes: Patch-specific XML parser example that handles parse errors explicitly.";

":xml_tree_child_count(STR xml) => INT|ERR";
"Called by XML import helpers to count top-level child nodes.";
{xml} = args;
tree = `xml_parse_tree(xml) ! E_INVARG, E_TYPE => E_INVARG';
if (typeof(tree) == ERR)
  return tree;
endif
return length(tree);
