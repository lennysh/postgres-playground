# PostgreSQL Playground

Lab and demo content for PostgreSQL operations: diagnostics, maintenance, and Ansible automation.

Companion to [ansible-playground](https://github.com/lennysh/ansible-playground) (AAP job templates and broader automation demos).

## Demos

| Demo | Path | What it shows |
|------|------|----------------|
| Table bloat & vacuum diagnostics | [demos/table-bloat-diag/](demos/table-bloat-diag/) | Database size, per-table disk breakdown, dead-tuple / autovacuum stats, TOAST inspection, and a written analysis report |

## Quick start

```bash
cd demos/table-bloat-diag
ansible-galaxy collection install -r collections/requirements.yml
cp vars/pg_connect.example.yml vars/pg_connect.yml   # edit credentials
ansible-playbook playbook.yml -e @vars/pg_connect.yml
```
