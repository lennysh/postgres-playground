# PostgreSQL Playground

Lab and demo content for PostgreSQL operations: diagnostics, maintenance, and Ansible automation.

Companion to [ansible-playground](https://github.com/lennysh/ansible-playground) (AAP job templates and broader automation demos).

## Demos

| Demo | Path | What it shows |
|------|------|----------------|
| AAP table bloat & vacuum diagnostics | [demos/aap-table-bloat-diag/](demos/aap-table-bloat-diag/) | AAP Controller DB size, per-table disk breakdown, dead-tuple / autovacuum stats, TOAST inspection, and a written analysis report (`main_host` and similar) |

## Quick start

```bash
cd demos/aap-table-bloat-diag
ansible-galaxy collection install -r collections/requirements.yml
pip install -r requirements.txt
cp vars/pg_connect.example.yml vars/pg_connect.yml   # edit credentials
ansible-playbook playbook.yml -e @vars/pg_connect.yml
```
