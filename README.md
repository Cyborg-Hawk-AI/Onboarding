# Welcome to Action.IT — Start here

**This is the first thing you should read.** This repo is your instructional guide to how we work at Action.IT: Git, tools, EC2 dev studios, and communication so you can get up to speed quickly and stay unblocked.

---

## Why this exists

The processes and docs here are in place so you can:

- **Streamline efficiency** — One clear playground repo, one branch, simple push/pull scripts, and no guesswork about where to push or how to avoid overwriting each other.
- **Build and ship as quickly as possible** — You spend time building, not fighting Git or hunting for credentials. EC2 + Cursor keeps your laptop light; scripts and docs keep the workflow predictable.
- **Work independently but together** — You have your own space (your user on the EC2, your work in the repo) while staying in sync via pull-before-push, Google Chat, shared Drive, and Jira. Documentation-as-you-build under `backend/docs` means the next person (or you later) can fix and extend without reinventing the wheel.
- **Stay aligned** — Same Git posture, same tools (Google Workspace, Jira, shared Drive), and one place for setup and troubleshooting so we can move fast as a team.

Read this README first, then use the docs and scripts in this repo as your reference. If something’s missing or unclear, say so in Chat so we can keep improving.

---

## What’s in this repo

| Document or script | Use it for |
|--------------------|------------|
| **docs/TEAM_SETUP_AND_TOOLS.md** | Google Workspace, Jira, EC2/Cursor, RDP from Mac (Windows app), MFA prep, and “documentation as you build” — **read this early.** |
| **docs/TEAM_ONBOARDING_PRESENTATION.md** | Full onboarding presentation (slides, diagrams). Use as the deck and script for the live session. |
| **docs/GIT_AND_CICD_STRATEGY.md** | Two-repo model (playground vs production), how Git prevents overwrites, promotion. |
| **docs/GIT_QUICK_REFERENCE.md** | One-page Git: setup, daily workflow, one rule, troubleshooting. |
| **scripts/push-to-playground.sh** | Push your work to the playground (actionit-dev). Run from **actionit-dev** repo root. |
| **scripts/pull-latest.sh** | Pull latest before work or when you get errors. Run from **actionit-dev** repo root. |

---

## Repo roles (where you work vs production)

| Repo | Role | Who pushes |
|------|------|------------|
| **actionit-dev** | Playground (daily work) | All engineers |
| **axnt-dev-workspace** | Production | CTO after validation |

You do all day-to-day work in **actionit-dev**; production is updated only when the CTO promotes validated code.

---

## Your first steps

1. **Read this README** (you’re here).
2. **Read docs/TEAM_SETUP_AND_TOOLS.md** — EC2 assignment, Windows app + RDP, Google Chat/Drive, credentials and RDP file in the right group chat, MFA prep, and doc-as-you-build under `backend/docs`.
3. **Attend (or watch) the onboarding session** — **docs/TEAM_ONBOARDING_PRESENTATION.md** is the deck; we’ll go through Git, push/pull, and how we avoid overwriting each other.
4. **Clone actionit-dev** and copy the two scripts into its `scripts/` folder. Use **pull-latest.sh** before work and when you get errors; use **push-to-playground.sh** when you want to push. Keep **docs/GIT_QUICK_REFERENCE.md** handy.
5. **Document as you build** — When you add a feature or service, create (or ask Cursor to create) dev docs under `backend/docs`: what you built, how to build/run it, how to fix or troubleshoot. Keep docs presentation-style (tables, diagrams) where it helps.

Welcome to the team. These processes are here to help you ship quickly and work well together—use them, and help us improve them.
