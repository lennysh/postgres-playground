SELECT t.relname AS main_table,
       toast.relname AS toast_table,
       pg_size_pretty(pg_relation_size(toast.oid)) AS toast_table_size,
       pg_relation_size(toast.oid) AS toast_table_bytes,
       s.n_live_tup AS toast_live_rows,
       s.n_dead_tup AS toast_dead_rows,
       s.last_autovacuum AS toast_last_autovacuum
  FROM pg_class t
  JOIN pg_class toast ON t.reltoastrelid = toast.oid
  LEFT JOIN pg_stat_all_tables s ON s.relid = toast.oid
 WHERE t.relname = %(table_name)s;
