" title: xml-parse-document";
" dialect: patch-specific";
" source: original";
" license: MIT";
" topic: patch-specific-builtins";
"callable: programmatic";
" dialect_reason: uses xml_parse_document() from a non-stock public XML builtin patch";

{xml} = args;
if (typeof(xml) != STR || !xml)
  raise(E_INVARG, "xml must be a non-empty string");
endif

return xml_parse_document(xml);
