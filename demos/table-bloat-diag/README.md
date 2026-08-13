# Table bloat & vacuum diagnostics

Ansible playbook that runs the same PostgreSQL inspection queries you would use in `psql`,
then writes a markdown report with interpretation and next steps.

Built for cases like an oversized AAP Controller database where `main_host` shows a tiny live
row count, millions of dead tuples, and hundreds of GB of on-disk size mostly in indexes.

## What it runs

| Step | Source | Purpose |
|------|--------|---------|
| Database size | `pg_database_size(current_database())` | Overall DB footprint |
| Table breakdown | `pg_total_relation_size` / `pg_relation_size` on `pg_class` | Heap vs index+TOAST split |
| Vacuum stats | `pg_stat_user_tables` | Live/dead tuples, last vacuum/analyze |
| TOAST stats | `pg_class` + `pg_stat_all_tables` | TOAST size and vacuum history |

The TOAST query here uses `pg_stat_all_tables` instead of `pg_stat_user_tables`, because TOAST
relations sit in the `pg_toast` schema and are often missing from `pg_stat_user_tables` (which
is why a manual `psql` session can show **0 rows** even when index bloat is the real problem).

## Quick start

```bash
cd demos/table-bloat-diag
ansible-galaxy collection install -r collections/requirements.yml
pip install -r requirements.txt   # psycopg2 for ansible-playbook's Python
cp vars/pg_connect.example.yml vars/pg_connect.yml   # edit host, user, password, db, table
ansible-playbook playbook.yml -e @vars/pg_connect.yml
```

Or pass libpq-style environment variables (`PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE`)
and override only the table name:

```bash
export PGHOST=controller-db.example.com PGUSER=ansibleauto PGDATABASE=ansibleauto PGPASSWORD='...'
ansible-playbook playbook.yml -e pg_target_table=main_host
```

## Requirements

- Ansible 2.14+
- `community.postgresql` collection (`collections/requirements.yml`)
- `psycopg2` or `psycopg2-binary` for the **same Python as `ansible-playbook`**
  (the playbook sets `ansible_python_interpreter` accordingly; a system `python3`
  without psycopg2 is not used)

## Variables

See [`vars/pg_connect.example.yml`](vars/pg_connect.example.yml). Important knobs:

| Variable | Default | Meaning |
|----------|---------|---------|
| `pg_target_table` | `main_host` | Table `relname` to inspect |
| `pg_dead_tuple_warn_pct` | `20` | Report WARNING at or above this dead-tuple % |
| `pg_dead_tuple_critical_pct` | `50` | Report CRITICAL at or above this dead-tuple % |
| `pg_index_dominance_warn_pct` | `80` | Flag when index+TOAST dominate on-disk size |
| `pg_report_path` | `./table-bloat-report.md` | Output file |

## Example interpretation

For a database reporting:

- **2237 GB** total database size
- **`main_host`**: 236 GB on disk, **1328 MB** heap, **234 GB** indexes+TOAST
- **14,752** live rows, **2,564,068** dead rows (**99.43%** dead)
- No `last_vacuum` / `last_autovacuum`

The playbook classifies this as **never-vacuumed index bloat**: dead tuple versions were never
reclaimed, so indexes still reference them and `pg_total_relation_size` explodes while
`n_live_tup` stays small. TOAST is usually not the driver when the TOAST query is empty and
index+TOAST dominate the footprint.

**Do not** run `VACUUM FULL` on production AAP inventory tables without a maintenance plan and
vendor guidance; start with plain `VACUUM (ANALYZE)` and reindex if needed.

## Files

```text
demos/table-bloat-diag/
├── playbook.yml
├── ansible.cfg
├── collections/requirements.yml
├── vars/pg_connect.example.yml
├── files/queries/          # SQL executed by the playbook
└── templates/report.md.j2  # Analysis report template
```
