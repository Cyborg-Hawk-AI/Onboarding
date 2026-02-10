# Git quick reference — actionit-dev (playground)

**One branch, one remote for daily work. Pull before push.**

---

## Where we work

| What | Value |
|------|--------|
| **Playground repo** | actionit-dev |
| **Production repo** | axnt-dev-workspace (do not push here from daily work) |
| **Remote for daily work** | `origin` (actionit-dev) |
| **Branch** | `dev-workspace` |

---

## First-time setup

```bash
git clone https://github.com/Cyborg-Hawk-AI/actionit-dev.git
cd actionit-dev
git checkout dev-workspace
gh auth login   # or use HTTPS token so you can push
```

---

## Daily workflow

### Before you start work
```bash
git pull origin dev-workspace
```
Or: `./scripts/pull-latest.sh`

### When you want to push
From repo root: `./scripts/push-to-playground.sh`

Or by hand:
```bash
git pull origin dev-workspace
git add -A
git commit -m "Short description"
git push origin dev-workspace
```

### When you get errors (rejected push, etc.)
Run: `./scripts/pull-latest.sh`  
Then fix any conflicts if Git reports them, and run `./scripts/push-to-playground.sh` again.

---

## One rule

**Pull before you push.** If push is rejected, run `./scripts/pull-latest.sh` (or `git pull origin dev-workspace`), then push again.

---

## If something goes wrong

| Message | What to do |
|--------|------------|
| "Updates were rejected" | Run `./scripts/pull-latest.sh`, then push again (or run `./scripts/push-to-playground.sh`). |
| "Merge conflict" | Open the file(s) Git names, fix conflict markers, save, `git add <file>`, then run the push script again. |
| "Permission denied" | Check you're a collaborator on actionit-dev and logged in (`gh auth status`). |

---

## Docs

- **Full strategy:** `docs/GIT_AND_CICD_STRATEGY.md`
- **Presentation:** `docs/TEAM_ONBOARDING_PRESENTATION.md`
- **Setup, tools, doc-as-you-build:** `docs/TEAM_SETUP_AND_TOOLS.md` (presentation-style; dev docs go under `backend/docs`)
