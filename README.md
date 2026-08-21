# PostgreSQL Playground

Lab and demo content for PostgreSQL operations: diagnostics, maintenance, and Ansible automation.

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

## Related repos

- [cheat-sheets](https://github.com/lennysh/cheat-sheets) — copy-paste notes (AAP, Automation Orchestrator, OpenShift, …)
- [ansible-playground](https://github.com/lennysh/ansible-playground) — playbooks and AAP Config-as-Code
