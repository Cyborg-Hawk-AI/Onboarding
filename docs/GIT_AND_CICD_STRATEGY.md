# Git + CI/CD Strategy: Two-Repo Model

**Last updated:** 2026-01-27  
**Purpose:** Define how your team uses GitHub and Cursor as your CI/CD pipeline—dev playground vs production, and how 4 engineers work together responsibly.

---

## What "help me" means here

You need:

1. **Two repos, clear roles:**  
   - **axnt-dev-workspace** = developer playground (everyone works here).  
   - **Production repo** = where validated code is promoted; only updated when dev is confirmed working.

2. **One place for collaboration:**  
   - All 4 engineers work in **axnt-dev-workspace** only.  
   - No one pushes to the production repo from day-to-day work.

3. **Simple Git usage:**  
   - Minimal branching and commands so the team doesn't need to be Git experts.  
   - Clear rules: where to push, what branch to use, how to get code to "live" in dev and then to prod.

4. **CI/CD that matches:**  
   - Pushes to the right branch/repo trigger Vercel.  
   - Dev = preview/staging from axnt-dev-workspace; prod = from the production repo.

This doc is the strategy for all of that.

---

## The two-repo model

| Repo | Role | Who pushes | What it triggers |
|------|------|------------|------------------|
| **axnt-dev-workspace** | Dev playground | All 4 engineers | Vercel preview/staging (e.g. branch or "dev" deployment) |
| **Production repo** (e.g. actionit-dev or your "master prod" repo) | Live production | You (or a designated person) after validation | Vercel production deployment |

Rule of thumb:

- **Daily work:** Only in **axnt-dev-workspace**.  
- **Production:** Only update the production repo when you explicitly **promote** code from axnt-dev-workspace after you've confirmed everything works.

---

## Remotes in this workspace

Your local repo can point at both:

- **origin** = production repo (e.g. `actionit-dev`).  
  - **Do not push here** from normal dev work. Only use for promotion (see below).

- **axnt-dev** = **axnt-dev-workspace** (dev playground).  
  - **All day-to-day pushes go here.**

```bash
# Check remotes
git remote -v
# origin   → production repo (do not push from dev workflow)
# axnt-dev → axnt-dev-workspace (push here)
```

---

## Branch strategy in axnt-dev-workspace (dev playground)

Keep it simple so 4 people work without constant merge conflicts or confusion.

### Option A (simplest): Single integration branch

- **One branch** in axnt-dev-workspace that everyone uses: e.g. **`dev-workspace`** (or `main`).
- Everyone:
  - Pulls `dev-workspace` from `axnt-dev`.
  - Makes changes.
  - Commits.
  - Pushes to `axnt-dev dev-workspace`.

Rules:

- Always **pull before you start** and **before you push** to avoid overwriting each other.
- If two people edit the same file, the second to push will need to pull, fix conflicts, then push again.

Good for: Small team, same timezone, good communication ("I'm touching the dashboard").

---

## How Git prevents overwrites (and when it doesn't)

Git does **not** overwrite "by file." It works by **commits** and **history**. That's what lets multiple people push without wiping each other's work—as long as you follow one rule.

### Your scenario: Dev1 and Dev2, different files

- **Dev1:** Edits `FileA.tsx` and `FileB.tsx` (has old versions of `FileC.tsx`, `FileD.tsx`).
- **Dev2:** Edits `FileC.tsx` and `FileD.tsx` (has old versions of `FileA.tsx`, `FileB.tsx`).

If **Dev1 pushes first**, then **Dev2 pushes without pulling**:

- Git **rejects** Dev2's push: *"Updates were rejected because the remote contains work that you do not have locally."*
- Dev2 **must** pull. When Dev2 runs `git pull axnt-dev dev-workspace`, Git **merges**:
  - It brings in Dev1's commit (updated `FileA.tsx`, `FileB.tsx`).
  - It keeps Dev2's changes (updated `FileC.tsx`, `FileD.tsx`).
  - Because they touched **different files**, Git can merge automatically. No conflict.
- After the merge, Dev2 has **all four updated files**. Dev2 pushes. Remote now has **everyone's changes**. Nothing is overwritten.

So: **different files → no overwrite.** Git combines both commits. You only get a **conflict** when two people change the **same file** and the **same lines** (or overlapping regions). Then Git stops and asks someone to resolve it (choose both changes, or one, or edit by hand).

### Rule that prevents overwrites

1. **Pull before you push.**  
   `git pull axnt-dev dev-workspace` then `git push axnt-dev dev-workspace`.
2. **If push is rejected,** pull again (Git will merge), fix any conflicts if Git reports them, then push.
3. **Never force-push** (`git push --force`) on the shared branch. Force-push can overwrite others' commits.

As long as everyone pulls before pushing and no one force-pushes, you only get "updated" files combined—not one person's old copy overwriting another's new copy.

### When Git *does* ask you to resolve something (conflicts)

You get a **merge conflict** only when:

- Two people changed the **same file**, and  
- Git can't merge the changes automatically (e.g. same lines or overlapping edits).

Then Git marks the file with conflict markers and asks you to resolve. You open the file, keep or edit the right parts from both sides, save, then:

```bash
git add <resolved-file>
git commit -m "Merge: resolve conflict in <file>"
git push axnt-dev dev-workspace
```

Resolving a conflict is the only time you "choose" what stays. For different files (or different parts of the same file), Git keeps both; no overwrite.

### Everyone pushes at the same time

If Dev1, Dev2, Dev3, Dev4 all push around the same time:

- **First push wins.** That commit is on the remote.
- **Everyone else gets rejected.** They see: "Updates were rejected... remote contains work that you do not have locally."
- **Each of them must:** `git pull axnt-dev dev-workspace`, then push again.
- On each pull, Git **merges** the remote commit into their branch. If they each edited different files (or different parts of files), the merges are automatic. After resolving any conflicts (only when same file + same lines), they push. The remote ends up with **all** of their changes combined.

So you don't "only get the updated files" by magic—you get them by **always pulling before (or when) push is rejected**, so your history includes everyone's commits. Then your push adds your commit on top. The result is one branch with everyone's updates; no one's changes are dropped unless someone force-pushes or resolves a conflict incorrectly (e.g. "take mine" for the whole file when the other person's changes should stay).

---

### Option B (slightly more structure): Short-lived feature branches

- **Integration branch:** `dev-workspace` (or `main`) on **axnt-dev-workspace**.
- For a feature or task, create a short-lived branch from `dev-workspace`, e.g. `feature/dashboard-fix` or `fix/login`.
- Work and commit on that branch, then either:
  - **Merge into `dev-workspace`** (locally or via GitHub PR), then push `dev-workspace` to `axnt-dev`, or  
  - **Open a Pull Request** in GitHub from `feature/...` → `dev-workspace`, review, merge on GitHub, then pull `dev-workspace` locally.

Vercel can be set so that:

- Pushes to `dev-workspace` (or `main`) on **axnt-dev-workspace** = staging/preview URL.  
- (Optional) Pushes to feature branches = per-branch preview URLs.

---

## How each engineer uses Git (simple workflow)

Assume we're using **one integration branch** `dev-workspace` in axnt-dev-workspace (Option A). Same idea applies if you use Option B for the integration branch.

### 1. One-time setup (each engineer)

```bash
# Clone axnt-dev-workspace (if not already)
git clone https://github.com/Cyborg-Hawk-AI/axnt-dev-workspace.git
cd axnt-dev-workspace

# If you already have this repo and added axnt-dev as remote:
git fetch axnt-dev
git checkout dev-workspace   # or main, whatever you use as integration branch
git branch --set-upstream-to=axnt-dev/dev-workspace dev-workspace
```

### 2. Start of day / before starting work

```bash
git checkout dev-workspace
git pull axnt-dev dev-workspace
```

### 3. Make changes

Edit code in Cursor (or IDE). Save.

### 4. Commit and push to dev (axnt-dev-workspace only)

```bash
git status
git add -A
git commit -m "Short description of what you did"
git push axnt-dev dev-workspace
```

**Critical:** Push to **axnt-dev**, not **origin**. That way you only update the dev playground; production stays untouched.

### 5. If someone else pushed first

If `git push axnt-dev dev-workspace` says "rejected, non-fast-forward":

```bash
git pull axnt-dev dev-workspace
# Fix any conflicts if Git says so, then:
git push axnt-dev dev-workspace
```

---

## What "push to git" means in your rules

In your Cursor/git rules you have:

- **"Push to git"** = get my changes to show as the current code in git for the branch we use for dev.

So for this workspace:

- **Branch:** `dev-workspace` (or whatever you chose as the single integration branch in axnt-dev-workspace).  
- **Remote:** **axnt-dev** (axnt-dev-workspace).  
- So: **push to git** = `git push axnt-dev dev-workspace` (after commit).  
- **Never** push to `origin` from this workflow; that's reserved for promotion to production.

---

## CI/CD: How Vercel fits

- **axnt-dev-workspace** is connected to Vercel.  
  - Configure so that the branch you use for integration (e.g. `dev-workspace` or `main`) triggers a **preview/staging** deployment.  
  - So: push to `axnt-dev dev-workspace` → Vercel builds and deploys → team sees "current dev" at that Vercel URL.

- **Production repo** (e.g. actionit-dev) is also connected to Vercel.  
  - Usually **one branch** (e.g. `main` or `master`) triggers **production** deployment.  
  - So: when you **promote** code into that repo and push that branch, Vercel deploys to production.

So:

- **Dev pipeline:** Work in axnt-dev-workspace → push to `axnt-dev` → Vercel deploys staging.  
- **Prod pipeline:** Promote from axnt-dev-workspace to production repo → push to prod branch → Vercel deploys production.

---

## Promoting from dev (axnt-dev-workspace) to production

When you've confirmed everything works in the dev playground (and on the Vercel staging URL), you **promote** that code to your "master prod" repo.

### Option 1: Manual copy (safest, no Git merge)

1. In axnt-dev-workspace, ensure `dev-workspace` (or your integration branch) is up to date and pushed to `axnt-dev`.
2. In another folder (or another clone), clone the **production repo**.
3. Copy the files you care about (e.g. whole project or only frontend) from the axnt-dev-workspace clone into the production clone, overwriting as needed.
4. In the production clone: `git add -A`, `git commit -m "Promote from axnt-dev-workspace (YYYY-MM-DD)"`, then push to the production repo's main branch (e.g. `origin main`).
5. Vercel sees the push and deploys production.

### Option 2: Same repo, two remotes (merge dev into prod branch)

You have both remotes in one clone (origin = prod, axnt-dev = dev). To promote:

```bash
# Make sure dev-workspace is up to date on axnt-dev
git fetch axnt-dev
git checkout dev-workspace
git pull axnt-dev dev-workspace

# Merge dev-workspace into your production branch (e.g. main) and push to origin
git checkout main
git pull origin main
git merge dev-workspace -m "Promote from axnt-dev-workspace"
git push origin main
```

Then switch back to dev for daily work:

```bash
git checkout dev-workspace
```

### Option 3: Scripted promotion

You can later add a small script that:  
- Fetches `axnt-dev dev-workspace`,  
- Merges into `main` (or your prod branch),  
- Pushes to `origin main`,  
so you run one command to "promote" after you've validated.

---

## Managing 4 people without chaos

1. **Single source of truth:** Everyone works in **axnt-dev-workspace**; one integration branch (`dev-workspace` or `main`).
2. **Pull before push:** Always `git pull axnt-dev dev-workspace` before `git push axnt-dev dev-workspace` to avoid overwriting and to resolve conflicts early.
3. **Small, frequent commits:** Reduces conflict size and makes "who did what" clearer.
4. **Optional: Pull Requests:** If you use Option B (feature branches), use GitHub PRs into `dev-workspace` so one person can review before merging.
5. **Optional: Branch protection:** On GitHub, you can protect `dev-workspace` so that only PRs (or only certain people) can push, to avoid accidental force-pushes.
6. **Document who does what:** A short list (e.g. in this doc or in README): "Frontend: A, B; Backend: C; Full-stack: D" so people know who to ask before touching the same area.

---

## Summary: What to do next

1. **Decide branch name** in axnt-dev-workspace: e.g. `dev-workspace` or `main`.  
2. **Tell the team:** "We only push to **axnt-dev** (axnt-dev-workspace), branch **dev-workspace**. Never push to **origin** from daily work."  
3. **Vercel:**  
   - axnt-dev-workspace, branch `dev-workspace` (or `main`) → staging/preview.  
   - Production repo, branch `main` (or `master`) → production.  
4. **Promotion:** When dev is validated, use one of the promotion options above to update the production repo and trigger production deploy.  
5. **Cursor rules:** Keep "push to git" = push to **axnt-dev** on **dev-workspace** (or your chosen integration branch), and never push to `origin` from the dev workflow.

That's the strategy: two repos, one dev playground, one prod, simple branch and push rules, and Vercel as your CI/CD for both.
