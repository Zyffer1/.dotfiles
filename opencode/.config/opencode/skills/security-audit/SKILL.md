---
name: security-audit
description: Use when auditing the security of the dotfiles setup — checking exposed ports, secret leakage, permission issues, unsafe shell scripts, and stow-related risks. The paranoid agent should load this skill.
---

# Security Audit Checklist

## What to check

### Secrets
- Hardcoded API keys, tokens, passwords
- Files containing `secret` in the name — verify they're gitignored
- Environment variables with sensitive values

### Permissions
- Agent permissions — least-privilege where possible
- Stow symlinks — can they be hijacked?
- Shell scripts — are they safe to run?

### Shell
- Unsafe `eval`, `source` of untrusted files
- Shell injection via filenames or arguments
- `rm -rf` without safety checks

### Config
- Exposed ports in configs
- Network services that shouldn't be public
- Debug modes left enabled

## Severity levels

- **Critical** — data loss, privilege escalation
- **High** — secret leakage, exposed attack surface
- **Medium** — unsafe defaults, missing safeguards
- **Low** — theoretical risks, hardening nits
