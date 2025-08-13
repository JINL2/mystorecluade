# 🎯 SuperClaude Flutter + Supabase - 15 Essential Situations

*Complete guide with personas and flags for every coding situation*

---

## 🎨 **Command Categories - When to Use What**

### **Development Commands** (Creating new things):
- `/sc:implement` = When you need to ADD a new feature to existing code
- `/sc:build` = When you need to CREATE something from scratch
- `/sc:design` = When you need to PLAN before building

**📌 Use these when:** Starting new features, creating screens, adding functionality

### **Analysis Commands** (Understanding problems):
- `/sc:analyze` = When you need to UNDERSTAND how something works
- `/sc:troubleshoot` = When something is BROKEN and you need to find why
- `/sc:explain` = When you need SIMPLE EXPLANATION of complex code

**📌 Use these when:** Code isn't working, need to understand existing code, finding bugs

### **Quality Commands** (Making things better):
- `/sc:improve` = When code works but needs to be BETTER
- `/sc:test` = When you need to CHECK if everything works
- `/sc:cleanup` = When you need to REMOVE unused code

**📌 Use these when:** Optimizing performance, adding tests, organizing messy code

### **Other Useful Commands**:
- `/sc:document` = Create README or documentation
- `/sc:git` = Prepare code for GitHub
- `/sc:estimate` = Get time/effort estimates
- `/sc:task` = Break work into smaller tasks
- `/sc:index` = Create file structure overview
- `/sc:load` = Load and analyze existing code
- `/sc:spawn` = Generate multiple related files

**📌 Use these when:** Documentation, project management, code organization

---

## 💡 **Simple Rule for Non-Coders:**

**Building something new?** → Use `/sc:build` or `/sc:implement`
**Something broken?** → Use `/sc:troubleshoot` or `/sc:fix`
**Making it better?** → Use `/sc:improve` or `/sc:optimize`
**Don't understand?** → Use `/sc:explain` or `/sc:analyze`

---

## 📚 **Quick Flag Reference:**
- `--think` = Careful analysis (medium complexity)
- `--think-hard` = Deep analysis (complex problems)
- `--ultrathink` = Maximum analysis (critical issues)
- `--seq` = Step-by-step solution
- `--validate` = Check for errors and security
- `--verbose` = Detailed explanations

## 👥 **Personas - Your Expert Team:**
- `--persona-architect` = System design expert
- `--persona-frontend` = UI/UX specialist
- `--persona-backend` = Server & API expert
- `--persona-mobile` = Mobile app specialist
- `--persona-database` = Database optimization
- `--persona-security` = Security expert
- `--persona-performance` = Speed optimization
- `--persona-fullstack` = Complete app development

---

## 1️⃣ **"I need to plan my entire app"** 📋

```bash
/sc:design "finance app architecture with all features" --persona-architect --ultrathink --seq
```
*Uses DESIGN because you're planning before building*

```bash
/sc:estimate "time and effort for finance app MVP" --think --verbose
```
*Uses ESTIMATE to understand project scope*

```bash
/sc:task "break down finance app into development phases" --seq
```
*Uses TASK to create actionable steps*

**💡 Use:** `--persona-architect` for system design, `--ultrathink` for comprehensive planning

---

## 2️⃣ **"I need to design the database"** 🗄️

```bash
/sc:design "Supabase schema for finance app with users, transactions, categories" --persona-database --think --seq
```

```bash
/sc:model "database relationships and foreign keys" --persona-database --validate
```

```bash
/sc:plan "RLS policies for multi-user access" --persona-security --think
```

**💡 Use:** `--persona-database` for schema, `--persona-security` for RLS

---

## 3️⃣ **"I'm starting a new screen"** 📱

```bash
/sc:build "dashboard screen with charts and summary cards" --lang:dart --persona-mobile --think
```
*Uses BUILD because creating from scratch*

```bash
/sc:implement "add navigation to existing app" --lang:dart --persona-frontend --seq
```
*Uses IMPLEMENT because adding to existing code*

```bash
/sc:spawn "all screens for finance app" --lang:dart --validate
```
*Uses SPAWN to create multiple related files*

**💡 Use:** `--persona-mobile` for Flutter screens, `--seq` to see build steps

---

## 4️⃣ **"My UI looks unprofessional"** 🎨

```bash
/sc:improve "make UI modern with Material Design 3" --lang:dart --persona-frontend --think
```

```bash
/sc:enhance "add animations and micro-interactions" --lang:dart --persona-frontend --seq
```

```bash
/sc:style "implement dark mode and custom theme" --lang:dart --verbose
```

**💡 Use:** `--persona-frontend` for UI/UX improvements

---

## 5️⃣ **"This feature doesn't work"** 🔧

```bash
/sc:troubleshoot "button onPressed not triggering function" --lang:dart --think
```
*Uses TROUBLESHOOT to find the problem*

```bash
/sc:analyze "why state not updating after API call" --lang:dart --think-hard --seq
```
*Uses ANALYZE to understand the issue*

```bash
/sc:explain "how navigation stack works in my app" --lang:dart --verbose
```
*Uses EXPLAIN to understand before fixing*

**💡 Use:** `--think` for simple fixes, `--think-hard` for complex issues

---

## 6️⃣ **"I need to connect to Supabase"** 🔌

```bash
/sc:implement "Supabase connection with auth and database" --lang:dart --persona-backend --seq --validate
```

```bash
/sc:build "CRUD operations for transactions table" --lang:dart --persona-fullstack --think
```

```bash
/sc:create "real-time subscription for data updates" --lang:dart --persona-backend
```

**💡 Use:** `--persona-backend` for API work, `--validate` for security

---

## 7️⃣ **"My app crashes randomly"** 💥

```bash
/sc:debug "app crashes on specific user action" --lang:dart --ultrathink --seq --verbose
```

```bash
/sc:troubleshoot "memory leak causing app to freeze" --lang:dart --persona-performance --think-hard
```

```bash
/sc:analyze "crash logs and stack traces" --lang:dart --ultrathink
```

**💡 Use:** `--ultrathink` for mysterious crashes, `--verbose` for details

---

## 8️⃣ **"Data isn't showing correctly"** 📊

```bash
/sc:troubleshoot "ListView shows empty despite data in Supabase" --lang:dart --think --seq
```

```bash
/sc:fix "FutureBuilder stuck on loading" --lang:dart --persona-mobile --verbose
```

```bash
/sc:debug "StreamBuilder not updating with real-time data" --lang:dart --think-hard
```

**💡 Use:** `--seq` to trace data flow, `--think` for logic issues

---

## 9️⃣ **"I need user authentication"** 🔐

```bash
/sc:implement "complete auth flow with Supabase" --lang:dart --persona-security --seq --validate
```

```bash
/sc:build "social login with Google and Apple" --lang:dart --persona-security --think
```

```bash
/sc:create "password reset and email verification" --lang:dart --validate
```

**💡 Use:** `--persona-security` always for auth, `--validate` for safety

---

## 🔟 **"My code is messy"** 🧹

```bash
/sc:cleanup "remove all unused code and organize files" --lang:dart --persona-architect --seq
```
*Uses CLEANUP to remove unnecessary code*

```bash
/sc:improve "code structure with clean architecture" --lang:dart --validate
```
*Uses IMPROVE to make existing code better*

```bash
/sc:index "create overview of current file structure" --verbose
```
*Uses INDEX to understand current organization*

**💡 Use:** `--persona-architect` for structure, `--seq` for step-by-step refactoring

---

## 1️⃣1️⃣ **"I need to debug efficiently"** 🐛

```bash
/sc:debug "add comprehensive logging system" --lang:dart --seq --verbose
```

```bash
/sc:implement "error tracking with Sentry" --lang:dart --persona-fullstack --think
```

```bash
/sc:troubleshoot "[paste exact error message]" --lang:dart --ultrathink --seq
```

**💡 Use:** `--ultrathink` for complex bugs, `--seq` to see debugging steps

---

## 1️⃣2️⃣ **"My app is slow"** 🐌

```bash
/sc:optimize "improve app performance and reduce lag" --lang:dart --persona-performance --think-hard
```

```bash
/sc:improve "implement lazy loading and pagination" --lang:dart --persona-performance --seq
```

```bash
/sc:analyze "find performance bottlenecks" --lang:dart --persona-performance --verbose
```

**💡 Use:** `--persona-performance` always for speed issues

---

## 1️⃣3️⃣ **"I need to add a complex feature"** 🚀

```bash
/sc:design "offline sync with conflict resolution" --persona-architect --ultrathink --seq
```

```bash
/sc:implement "export data to PDF with charts" --lang:dart --persona-fullstack --think-hard
```

```bash
/sc:build "multi-language support" --lang:dart --think --verbose
```

**💡 Use:** `--ultrathink` for complex features, `--persona-architect` for design

---

## 1️⃣4️⃣ **"I need to test my app"** 🧪

```bash
/sc:test "create unit tests for transaction functions" --lang:dart --persona-qa --seq
```
*Uses TEST to create test cases*

```bash
/sc:implement "add integration tests to existing code" --lang:dart --validate
```
*Uses IMPLEMENT to add tests to current project*

```bash
/sc:analyze "test coverage and missing tests" --lang:dart --verbose
```
*Uses ANALYZE to understand testing gaps*

**💡 Use:** `--persona-qa` for testing, `--validate` for test coverage

---

## 1️⃣5️⃣ **"Is my app production ready?"** 🎯

```bash
/sc:analyze "complete security and performance audit" --persona-security --ultrathink --validate
```
*Uses ANALYZE to check everything*

```bash
/sc:document "create README and API documentation" --verbose
```
*Uses DOCUMENT for production docs*

```bash
/sc:git "prepare repository for deployment" --validate
```
*Uses GIT to ready for version control*

**💡 Use:** Multiple personas for complete review, `--validate` essential

---

# 🎖️ **Master Commands - When & Why to Use Flags**

## **Planning & Architecture:**
```bash
Always use: --persona-architect --ultrathink --seq
Why: Need comprehensive system design with clear steps
```

## **UI/UX Development:**
```bash
Always use: --lang:dart --persona-frontend --think
Why: Flutter-specific code with good design practices
```

## **Backend & Database:**
```bash
Always use: --persona-backend --validate --seq
Why: Security is critical, need step-by-step implementation
```

## **Debugging Complex Issues:**
```bash
Always use: --ultrathink --seq --verbose
Why: Need maximum analysis with detailed steps
```

## **Performance Optimization:**
```bash
Always use: --persona-performance --think-hard
Why: Performance requires specialized knowledge
```

## **Security Features:**
```bash
Always use: --persona-security --validate --strict
Why: Security cannot be compromised
```

---

# 🔥 **Power Combinations by Situation**

## **Starting New Project:**
```bash
/sc:architect "app idea" --persona-architect --ultrathink --seq
Then: /sc:design "database" --persona-database --think
Then: /sc:build "UI" --lang:dart --persona-frontend
```

## **Fixing Major Bug:**
```bash
/sc:analyze "bug symptoms" --think
Then: /sc:debug "specific issue" --ultrathink --seq
Then: /sc:fix "root cause" --validate
```

## **Adding Complex Feature:**
```bash
/sc:design "feature architecture" --persona-architect --think-hard
Then: /sc:implement "backend" --persona-backend --seq
Then: /sc:build "frontend" --lang:dart --persona-mobile
```

---

# 📝 **Golden Rules:**

1. **Planning?** → Always `--persona-architect --ultrathink`
2. **UI Work?** → Always `--lang:dart --persona-frontend`
3. **Database?** → Always `--persona-database --validate`
4. **Bug Hunting?** → Always `--ultrathink --seq`
5. **Security?** → Always `--persona-security --validate`
6. **Performance?** → Always `--persona-performance`
7. **Complex Problem?** → Always `--think-hard` or `--ultrathink`
8. **Need Steps?** → Always `--seq`
9. **Critical Feature?** → Always `--validate`
10. **Need Details?** → Always `--verbose`

---

# 🚀 **Quick Copy Template:**

```bash
/sc:[action] "[what you want]" --lang:dart --persona-[expert] --[thinking-level] --seq --validate
```

**Fill in:**
- action: build/fix/implement/optimize
- what you want: your specific need
- expert: frontend/backend/mobile/security
- thinking-level: think/think-hard/ultrathink

---

*Master these 15 situations and you can build anything with Flutter + Supabase!* 🎯