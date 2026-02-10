# Git + CI/CD Strategy: Two-Repo Model

**Last updated:** 2026-01-27  
**Purpose:** Define how your team uses GitHub and Cursor as your CI/CD pipeline—playground vs production, and how 4 engineers work together responsibly.

---

## What "help me" means here

1. **Two repos, clear roles:**  
   - **actionit-dev** = **developer playground** (everyone works here).  
   - **axnt-dev-workspace** = **production**; only updated when playground is validated.

2. **One place for collaboration:**  
   - All 4 engineers work in **actionit-dev** only.  
   - No one pushes to **axnt-dev-workspace** from day-to-day work.

3. **Simple Git usage:**  
   - Minimal branching and commands.  
   - Clear rules: where to push (origin = actionit-dev), what branch (`dev-workspace`), how code gets promoted to production (axnt-dev-workspace).

4. **CI/CD:**  
   - Pushes to **actionit-dev** (playground) → Vercel preview/staging.  
   - Promoted code to **axnt-dev-workspace** → Vercel production.

---

## The two-repo model

| Repo | Role | Who pushes | What it triggers |
|------|------|------------|------------------|
| **actionit-dev** | Playground (dev) | All 4 engineers | Vercel preview/staging |
| **axnt-dev-workspace** | Production | CTO / designated person after validation | Vercel production |

Rule of thumb:

- **Daily work:** Only in **actionit-dev**. Push to **origin** (actionit-dev), branch **dev-workspace**.
- **Production:** Only update **axnt-dev-workspace** when you **promote** from actionit-dev after everything is validated.

---

## Remotes in this workspace

When you clone **actionit-dev** (playground):

- **origin** = **actionit-dev** (playground).  
  - **All day-to-day pushes go here:** `git push origin dev-workspace`.

If you also have the production repo as a remote (for promotion only):

- **axnt-dev** = **axnt-dev-workspace** (production).  
  - **Do not push here** from normal dev work. Only used when promoting to production.

```bash
# Check remotes (in your playground clone)
git remote -v
# origin → actionit-dev (push here for daily work)
# axnt-dev → axnt-dev-workspace (promotion only; do not push from dev workflow)
```

---

## Branch strategy in actionit-dev (playground)

- **One branch** everyone uses: **`dev-workspace`**.
- Everyone: pull `dev-workspace` from `origin`, make changes, commit, push to `origin dev-workspace`.
- **Rules:** Pull before you start and before you push. If two people edit the same file, the second to push pulls, fixes conflicts, then pushes.

---

## How Git prevents overwrites (and when it doesn't)

Git works by **commits** and **history**, not file-by-file overwrites.

- **Different files:** When you pull, Git merges others' commits with yours. No overwrite.
- **Push rejected?** Run `git pull origin dev-workspace`, fix any conflicts, then push again.
- **Never force-push** on the shared branch.

You get a **merge conflict** only when two people changed the **same file** and the **same lines**. Then Git asks you to resolve; open the file, fix the conflict markers, save, `git add <file>`, commit, push.

**Rule:** Pull before you push. If push is rejected, pull again, then push.

---

## How each engineer uses Git (simple workflow)

### 1. One-time setup

```bash
git clone https://github.com/Cyborg-Hawk-AI/actionit-dev.git
cd actionit-dev
git checkout dev-workspace
git branch --set-upstream-to=origin/dev-workspace dev-workspace
```

### 2. Before starting work

```bash
git checkout dev-workspace
git pull origin dev-workspace
```

Or run: `./scripts/pull-latest.sh`

### 3. When you want to push

Run from repo root: `./scripts/push-to-playground.sh`

Or by hand:

```bash
git status
git add -A
git commit -m "Short description"
git push origin dev-workspace
```

### 4. If push is rejected

```bash
git pull origin dev-workspace
# Fix any conflicts if Git says so, then:
git push origin dev-workspace
```

Or run: `./scripts/pull-latest.sh` then `./scripts/push-to-playground.sh`

---

## CI/CD: How Vercel fits

- **actionit-dev** (playground): branch `dev-workspace` → Vercel preview/staging.
- **axnt-dev-workspace** (production): branch used for prod → Vercel production.

Promotion: When playground is validated, code is promoted from actionit-dev to axnt-dev-workspace; that push triggers production deploy.

---

## Promoting from playground (actionit-dev) to production (axnt-dev-workspace)

When you've confirmed everything works in the playground:

1. In your **actionit-dev** clone: ensure `dev-workspace` is up to date and pushed to `origin`.
2. In another clone (or same clone with both remotes), clone or fetch **axnt-dev-workspace** (remote `axnt-dev`).
3. Merge or copy the validated code from actionit-dev into axnt-dev-workspace, then push to `axnt-dev` (production). Vercel deploys production.

---

## Summary

- **Playground** = **actionit-dev** (remote **origin**). Everyone pushes to **origin dev-workspace**. Pull before push.
- **Production** = **axnt-dev-workspace** (remote **axnt-dev**). Only CTO/designated person pushes there after promotion.
- Use **scripts/push-to-playground.sh** to push and **scripts/pull-latest.sh** when you get errors or before work.
