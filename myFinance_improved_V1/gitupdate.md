# Git Simple Guide

## Step 1: First Time Setup (Once Only)
```bash
git checkout main
```
Then:
```bash
git checkout -b [yourname]
```
Then:
```bash
git push -u origin [yourname]
```

---

## Step 2: Daily Work

### Morning (Get Latest Code)
```bash
git checkout main
```
```bash
git pull origin main
```
```bash
git checkout [yourname]
```
```bash
git merge main
```

### Before Going Home (Save Your Work)
```bash
git add .
```
```bash
git commit -m "work done"
```
```bash
git push
```

---

## If You Get Errors

### Error: "Your local changes would be overwritten"
First do this:
```bash
git add .
```
```bash
git commit -m "save my work"
```
Then continue with morning steps.

### Error: "pathspec did not match"
You need to create your branch first. Go back to Step 1.

---

## Names to Use
- Nghia
- John
- Sarah
- Mike

**Replace [yourname] with your actual name**
