# Team Onboarding: Git + axnt-dev-workspace

**Use this doc to run the meeting:** presentation outline, talking points, demo steps, and where to find the script and reference.

**Duration:** ~20–25 min (presentation + demo + Q&A)

---

## 1. Welcome and goal (2 min)

**Say:**
- "We're standardizing how we work in the dev repo so everyone can work effectively and independently."
- "By the end of this you'll know: where we work, how we push without overwriting each other, and you'll have a one-command way to push that still makes sense."

**Slides / bullets:**
- One dev repo: **axnt-dev-workspace**
- One branch we use: **dev-workspace**
- One rule: **pull before push**
- One script: **`./scripts/push-to-dev.sh`** when you want to push

---

## 2. Two-repo model (3 min)

**Say:**
- "We have two GitHub repos. You only work in one of them."
- "axnt-dev-workspace is our playground—everyone pushes here. The other repo is production; only [you / designated person] updates it after we validate things here."

**Slides / bullets:**

| Repo | What it is | Who pushes |
|------|------------|------------|
| **axnt-dev-workspace** | Dev playground | All of us |
| **Production repo** | Live site | [You] after validation |

- "Your day-to-day work: clone axnt-dev-workspace, work on branch `dev-workspace`, push to the **axnt-dev** remote. We never push to the production remote from normal dev work."

---

## 3. Remotes and branch (3 min)

**Say:**
- "If you already have this repo, it might have two remotes: **origin** (production) and **axnt-dev** (our dev repo). We only push to **axnt-dev**."
- "We use one branch: **dev-workspace**. All our work and all our pushes go to that branch."

**Slides / bullets:**
- **Remote `axnt-dev`** → axnt-dev-workspace (push here)
- **Remote `origin`** → production (do not push here from dev)
- **Branch:** `dev-workspace` only

**Demo (optional):**
```bash
git remote -v
git branch --show-current
```
Show axnt-dev points to axnt-dev-workspace; we're on dev-workspace.

---

## 4. Why we don't overwrite each other (5 min)

**Say:**
- "Git doesn't overwrite file-by-file. It merges commits. So if you and I edit different files and we both push, we don't wipe each other's work—as long as we pull before we push."
- "If you push and someone else already pushed, Git will reject your push and tell you to pull. You pull, Git merges their changes with yours, then you push again. Different files = merge is automatic. Same file, same lines = Git will ask you to resolve a conflict once."

**Slides / bullets:**
- Pull before push → you get others' latest commits.
- Push rejected? → Pull, then push again.
- Different files → no conflict; Git combines both.
- Same file, same lines → conflict; we fix it once and push.

**Reference:** "Details are in `docs/GIT_AND_CICD_STRATEGY.md` under 'How Git prevents overwrites'."

---

## 5. Daily workflow (3 min)

**Say:**
- "Start of day or before you start: pull so you have the latest."
- "You code, commit, then push. We have a script that does pull + optional commit + push and prints what it's doing so it's not a black box."

**Slides / bullets:**

1. **Before work:** `git pull axnt-dev dev-workspace` (or run the script once with no changes to just pull).
2. **Work** in your editor.
3. **When you want to push:** Run `./scripts/push-to-dev.sh` from the repo root.
   - Script will: switch to dev-workspace if needed, pull, show status, optionally add/commit (it will ask for a message), then push to axnt-dev.

**Demo:** Run the script live. Show the messages (branch check, pull, status, commit prompt if there are changes, push). Emphasize: "Same steps you'd do by hand; the script just runs them and explains each step."

---

## 6. The push script (5 min)

**Say:**
- "We have a script so pushing is one command, but it's not magic—it runs the same Git commands we just talked about and prints what it's doing."
- "You run it from the root of the repo: `./scripts/push-to-dev.sh`."

**Slides / bullets:**
- **Where:** `scripts/push-to-dev.sh`
- **What it does:**
  - Ensures we're on branch `dev-workspace` (switches if not).
  - Pulls from `axnt-dev dev-workspace`.
  - Shows `git status`.
  - If there are uncommitted changes: asks if you want to add/commit and asks for a commit message.
  - Pushes to `axnt-dev dev-workspace`.
- **Why it's safe:** No force-push, no pushing to origin; it only pushes to axnt-dev dev-workspace.

**Demo:** Run the script again; read the output lines and map them to the steps above.

---

## 7. Permissions and first-time setup (3 min)

**Say:**
- "You're being added as collaborators to axnt-dev-workspace, so you'll have permission to push via the CLI once you're set up."
- "First time: clone the repo, install GitHub CLI if you want to use it, authenticate so Git can push. After that, the script and the workflow we just went over are all you need."

**Slides / bullets:**
- **Clone (first time):**  
  `git clone https://github.com/Cyborg-Hawk-AI/axnt-dev-workspace.git`  
  then `cd axnt-dev-workspace` and `git checkout dev-workspace`.
- **Auth:** Use GitHub CLI (`gh auth login`) or HTTPS with a personal access token so `git push` is allowed.
- **Push:** Use `./scripts/push-to-dev.sh` (or the same steps by hand).

**One-pager:** "After this meeting, use `docs/GIT_QUICK_REFERENCE.md` for the exact commands and the link to the full strategy doc."

---

## 8. Q&A and wrap (5 min)

**Suggestions:**
- "What if I get 'Updates were rejected'?" → Pull, then run the script again (or push again).
- "What if Git says there's a conflict?" → Open the file, fix the conflict markers (keep both sides or choose), save, then `git add` that file and run the script again (or commit and push).
- "Can I push without the script?" → Yes: pull, then `git add` / `git commit` / `git push axnt-dev dev-workspace`. Script is for convenience and consistency.

**Wrap:**
- "We only work in axnt-dev-workspace on dev-workspace; we only push to axnt-dev; we pull before push; and we have a script to dummy-proof the push. Full details and the 'why' are in `docs/GIT_AND_CICD_STRATEGY.md` and `docs/GIT_QUICK_REFERENCE.md`."

---

## Checklist for you (presenter)

- [ ] Add everyone as collaborators to **axnt-dev-workspace** before or right after the meeting.
- [ ] Share repo link: `https://github.com/Cyborg-Hawk-AI/axnt-dev-workspace`
- [ ] Point to script: `scripts/push-to-dev.sh` (run from repo root).
- [ ] Point to quick reference: `docs/GIT_QUICK_REFERENCE.md`
- [ ] Point to full strategy: `docs/GIT_AND_CICD_STRATEGY.md`
- [ ] Do a live demo of the script and, if possible, a quick pull → change → push so they see the flow once.
