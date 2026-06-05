" title: sql-query";
" dialect: core-specific";
" source: original";
" license: MIT";
" topic: sindome-builtins";
"callable: programmatic";
" dialect_reason: uses Sindome-specific sql_query() builtin";

{connection, query, ?params = {}} = args;
if (typeof(query) != STR || !query)
  raise(E_INVARG, "query must be a non-empty string");
endif

return sql_query(connection, query, @params);
