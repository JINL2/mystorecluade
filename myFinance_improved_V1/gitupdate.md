# Git Copy Paste Guide

## First Time Only
```bash
git checkout -b [yourname] && git push -u origin [yourname]
```

---

## Morning
```bash
git add . && git commit -m "save" && git checkout main && git pull origin main && git checkout [yourname] && git merge main
```

## Before Going Home
```bash
git add . && git commit -m "work done" && git push
```

---

## If Error Happens (local changes would be overwritten)

### Option 1: Keep your changes
```bash
git add . && git commit -m "save my work" && git checkout main && git pull origin main && git checkout [yourname] && git merge main
```

### Option 2: Delete your changes
```bash
git checkout -- . && git checkout main && git pull origin main && git checkout [yourname] && git merge main
```

---

## Name Examples
- Nghia
- John  
- Sarah
- Mike

**Just replace [yourname] and copy paste**
