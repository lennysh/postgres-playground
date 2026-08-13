SELECT relname AS table_name,
       pg_size_pretty(pg_total_relation_size(oid)) AS total_size_on_disk,
       pg_size_pretty(pg_relation_size(oid)) AS heap_table_size,
       pg_size_pretty(pg_total_relation_size(oid) - pg_relation_size(oid)) AS index_and_toast_size,
       pg_total_relation_size(oid) AS total_bytes,
       pg_relation_size(oid) AS heap_bytes,
       pg_total_relation_size(oid) - pg_relation_size(oid) AS index_and_toast_bytes
  FROM pg_class
 WHERE relname = %(table_name)s;
