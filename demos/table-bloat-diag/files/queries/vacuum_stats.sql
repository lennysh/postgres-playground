SELECT schemaname,
       relname,
       n_live_tup AS live_rows,
       n_dead_tup AS dead_rows,
       ROUND(n_dead_tup::numeric / GREATEST(n_live_tup + n_dead_tup, 1) * 100, 2) AS dead_tuple_ratio_pct,
       last_vacuum,
       last_autovacuum,
       last_analyze,
       last_autoanalyze
  FROM pg_stat_user_tables
 WHERE relname = %(table_name)s;
