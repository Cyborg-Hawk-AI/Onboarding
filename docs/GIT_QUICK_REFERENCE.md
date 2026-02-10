# Git quick reference — axnt-dev-workspace

**One branch, one remote for dev. Pull before push. Use the script to push.**

---

## Where we work

| What | Value |
|------|--------|
| **Repo** | axnt-dev-workspace |
| **Remote for dev** | `axnt-dev` |
| **Branch** | `dev-workspace` |
| **Production remote** | `origin` (do not push here from dev) |

---

## First-time setup

```bash
# Clone (if you don't have the repo yet)
git clone https://github.com/Cyborg-Hawk-AI/axnt-dev-workspace.git
cd axnt-dev-workspace

# Use the dev branch
git checkout dev-workspace

# Auth (so you can push): use GitHub CLI or HTTPS with a token
gh auth login
```

---

## Daily workflow

### Before you start work
```bash
git checkout dev-workspace
git pull axnt-dev dev-workspace
```

### When you want to push (easiest)
From repo root:
```bash
./scripts/push-to-dev.sh
```
The script will: switch to dev-workspace if needed, pull, show status, optionally add/commit (asks for message), then push to axnt-dev.

### Or do it by hand
```bash
git checkout dev-workspace
git pull axnt-dev dev-workspace
git add -A
git commit -m "Short description of what you did"
git push axnt-dev dev-workspace
```

---

## One rule

**Pull before you push.**  
If push is rejected, run `git pull axnt-dev dev-workspace`, fix any conflicts if Git says so, then push again (or run the script again).

---

## If something goes wrong

| Message | What to do |
|--------|------------|
| "Updates were rejected" | Run `git pull axnt-dev dev-workspace`, then push again (or run the script again). |
| "Merge conflict" | Open the file(s) Git names, fix the conflict markers, save, then `git add <file>` and run the script again (or commit and push). |
| "Permission denied" / "Authentication failed" | Check you're added as a collaborator and that you're logged in (`gh auth status` or your Git credentials). |

---

## Docs

- **Full strategy (two repos, overwrites, conflicts):** `docs/GIT_AND_CICD_STRATEGY.md`
- **Onboarding presentation outline:** `docs/TEAM_ONBOARDING_PRESENTATION.md`
