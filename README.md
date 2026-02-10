# Onboarding

Git training and protocol for the team: two-repo model (playground vs production), daily workflow, and scripts.

---

## Repo roles

| Repo | Role | Who pushes |
|------|------|------------|
| **actionit-dev** | Playground (daily work) | All engineers |
| **axnt-dev-workspace** | Production | CTO after validation |

---

## Contents

| Item | Description |
|------|-------------|
| **docs/GIT_AND_CICD_STRATEGY.md** | Full strategy: two repos, remotes, branch, overwrites, promotion to production |
| **docs/GIT_QUICK_REFERENCE.md** | One-page quick reference: setup, daily workflow, one rule, troubleshooting |
| **docs/TEAM_ONBOARDING_PRESENTATION.md** | Full presentation (with graphics/charts); use as the deck and script—no other media |
| **scripts/push-to-playground.sh** | Push to actionit-dev (origin dev-workspace); run from **actionit-dev** repo root |
| **scripts/pull-latest.sh** | Pull from actionit-dev (origin dev-workspace); use before work or when you get errors; run from **actionit-dev** repo root |

---

## Use with actionit-dev (playground)

This repo is **reference only**. Day-to-day work happens in **actionit-dev**. Copy the two scripts into that repo’s `scripts/` folder. From **actionit-dev** repo root:

- **Before work or when you get errors:** `./scripts/pull-latest.sh`
- **When you want to push:** `./scripts/push-to-playground.sh`

Assume you’re already authenticated (e.g. `gh auth login`) and using the actionit-dev repo.
