# CLAUDE.md - AI Assistant Guide for Pilgrim

This document provides comprehensive guidance for AI assistants (like Claude) working on the Pilgrim codebase. It covers repository structure, development workflows, coding conventions, and best practices.

## Table of Contents

- [About This File](#about-this-file)
- [Repository Overview](#repository-overview)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Coding Conventions](#coding-conventions)
- [Testing Strategy](#testing-strategy)
- [Common Tasks](#common-tasks)
- [AI Assistant Guidelines](#ai-assistant-guidelines)
- [Troubleshooting](#troubleshooting)

---

## About This File

This CLAUDE.md file serves as a knowledge base for AI assistants working on this repository. It should be updated whenever:
- Project structure changes significantly
- New development workflows are established
- Coding conventions are adopted or modified
- New tools or frameworks are integrated

**Last Updated:** 2025-11-13

---

## Repository Overview

**Repository:** juanrafernandez/pilgrim

### Purpose
[To be filled in: Brief description of what this project does and its main goals]

### Tech Stack
[To be filled in as technologies are chosen]
- **Language:** TBD
- **Framework:** TBD
- **Build Tool:** TBD
- **Testing:** TBD
- **Package Manager:** TBD

### Key Dependencies
[To be filled in as dependencies are added]

---

## Project Structure

```
pilgrim/
├── .git/                    # Git repository metadata
├── CLAUDE.md               # This file - AI assistant guide
├── README.md               # Project documentation (to be created)
├── .gitignore             # Git ignore patterns (to be created)
└── [Additional structure to be defined]
```

### Directory Conventions
[To be defined as project structure emerges]

- **Source code:** TBD (e.g., `src/`, `lib/`, etc.)
- **Tests:** TBD (e.g., `tests/`, `__tests__/`, `spec/`, etc.)
- **Documentation:** TBD (e.g., `docs/`, inline in README)
- **Configuration:** TBD (root level or `config/`)
- **Build output:** TBD (e.g., `dist/`, `build/`, `target/`, etc.)

---

## Development Workflow

### Branching Strategy

The project uses the following branch naming conventions:

- **Feature branches:** `claude/claude-md-*` (for AI-driven development)
- **Main branch:** `main` or `master` (to be determined)
- **Development branch:** `develop` (if using git-flow)

### Git Workflow

1. **Starting Work:**
   ```bash
   git fetch origin
   git checkout -b claude/feature-name-<session-id>
   ```

2. **During Development:**
   ```bash
   git add <files>
   git commit -m "descriptive message"
   ```

3. **Pushing Changes:**
   ```bash
   git push -u origin claude/feature-name-<session-id>
   ```
   - Note: Branch names must start with `claude/` and end with session ID for AI-driven development
   - Retry up to 4 times with exponential backoff (2s, 4s, 8s, 16s) if network errors occur

4. **Creating Pull Requests:**
   - Use descriptive titles
   - Include summary of changes
   - Reference related issues
   - Provide test plan

### Commit Message Guidelines

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add user authentication flow

Implements login, logout, and session management
using JWT tokens.

Closes #123
```

```
fix(api): resolve null pointer exception in user endpoint

Added null check before accessing user properties.
```

---

## Coding Conventions

### General Principles

1. **Code Quality:**
   - Write clean, readable, self-documenting code
   - Follow DRY (Don't Repeat Yourself) principle
   - Keep functions small and focused (single responsibility)
   - Use meaningful variable and function names

2. **Comments:**
   - Write comments for complex logic
   - Document public APIs and functions
   - Keep comments up-to-date with code changes
   - Avoid redundant comments that state the obvious

3. **Error Handling:**
   - Always handle errors explicitly
   - Use appropriate error types
   - Provide meaningful error messages
   - Log errors appropriately

4. **Security:**
   - Never commit secrets, API keys, or credentials
   - Validate all user input
   - Follow OWASP top 10 security practices
   - Sanitize data before use
   - Use parameterized queries for database operations

### Language-Specific Conventions
[To be filled in based on chosen language]

### File Organization
[To be defined]

---

## Testing Strategy

### Test Types

1. **Unit Tests:**
   - Test individual functions/methods in isolation
   - Mock external dependencies
   - Aim for high code coverage

2. **Integration Tests:**
   - Test interaction between components
   - Verify database operations
   - Test API endpoints

3. **End-to-End Tests:**
   - Test complete user workflows
   - Verify critical paths

### Running Tests
[To be defined based on testing framework]

```bash
# Example commands (to be updated)
# Run all tests
npm test

# Run specific test file
npm test path/to/test

# Run with coverage
npm test -- --coverage
```

### Test Coverage Goals
- Aim for >80% code coverage
- 100% coverage for critical paths
- All public APIs must have tests

---

## Common Tasks

### Setting Up Development Environment

[To be defined - will include:]
1. Prerequisites (language runtime, tools, etc.)
2. Installation steps
3. Configuration requirements
4. Verification steps

### Adding a New Feature

1. Create a feature branch
2. Implement the feature with tests
3. Update documentation
4. Run full test suite
5. Create pull request
6. Address code review feedback

### Debugging

[To be defined based on tools and language]

### Building for Production

[To be defined based on build process]

---

## AI Assistant Guidelines

### Understanding the Codebase

When working on this codebase as an AI assistant:

1. **Always explore before coding:**
   - Use the Task tool with `subagent_type=Explore` for comprehensive code exploration
   - Read existing documentation (README, API docs, etc.)
   - Search for similar patterns in the codebase
   - Understand the context before making changes

2. **Use appropriate tools:**
   - `Grep` for searching code patterns
   - `Glob` for finding files by pattern
   - `Read` for reading specific files
   - `Edit` for making targeted changes to existing files
   - `Write` only for creating new files when absolutely necessary

3. **Prefer editing over creating:**
   - Always look for existing files to modify
   - Only create new files when genuinely needed
   - Maintain consistency with existing code structure

### Making Changes

1. **Plan before executing:**
   - Use TodoWrite to break down complex tasks
   - Mark tasks in_progress before starting
   - Complete tasks only when fully done

2. **Follow git workflow:**
   - Work on the designated branch
   - Commit with clear, descriptive messages
   - Push changes when complete

3. **Test your changes:**
   - Run existing tests after modifications
   - Add new tests for new functionality
   - Verify builds succeed

4. **Security considerations:**
   - Never introduce vulnerabilities (SQL injection, XSS, command injection, etc.)
   - Validate and sanitize all inputs
   - Review code for security issues before committing

### Code Review Self-Checklist

Before committing code, verify:

- [ ] Code follows project conventions
- [ ] Tests are included and passing
- [ ] Documentation is updated
- [ ] No security vulnerabilities introduced
- [ ] No secrets or credentials in code
- [ ] Error handling is appropriate
- [ ] Code is readable and maintainable
- [ ] Git commit message is descriptive
- [ ] Changes are on the correct branch

### Communication Style

When interacting with users:
- Be concise and direct
- Use markdown for formatting
- Avoid emojis unless requested
- Focus on technical accuracy
- Ask for clarification when requirements are ambiguous

---

## Troubleshooting

### Common Issues

[To be populated as common issues arise]

### Build Failures

[To be defined based on build system]

### Test Failures

[To be defined based on testing framework]

### Git Issues

**Problem:** Push fails with 403 error
**Solution:** Ensure branch name starts with `claude/` and ends with session ID

**Problem:** Network timeout during git operations
**Solution:** Retry with exponential backoff (2s, 4s, 8s, 16s)

**Problem:** Merge conflicts
**Solution:**
1. Fetch latest changes: `git fetch origin`
2. Rebase or merge as appropriate
3. Resolve conflicts manually
4. Test thoroughly after resolution

---

## Contributing

### For Project Contributors

When updating this CLAUDE.md file:
1. Keep information accurate and current
2. Use clear, concise language
3. Provide examples where helpful
4. Update the "Last Updated" date
5. Follow the existing structure

### For AI Assistants

- Consult this document before starting any task
- Suggest updates to this document when you discover missing or outdated information
- Follow all guidelines and conventions outlined here
- When in doubt, ask the user for clarification

---

## Additional Resources

[To be added as project grows]

- Project README: `README.md` (to be created)
- Contributing Guidelines: `CONTRIBUTING.md` (if needed)
- API Documentation: TBD
- Architecture Decisions: TBD

---

## Appendix

### Glossary
[To be populated with project-specific terms]

### Quick Reference Commands

```bash
# Git operations
git status
git fetch origin
git pull origin <branch>
git add <files>
git commit -m "message"
git push -u origin <branch>

# [Other commands to be added based on tech stack]
```

---

**Note to AI Assistants:** This document is your primary reference for working on this codebase. Always refer to it before making changes, and help keep it updated as the project evolves.
