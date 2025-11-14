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
**Camino Maldito: La Cruz del Peregrino** - A 2D action arcade game in pixel-art style for iOS, set on the medieval Camino de Santiago (Way of St. James). The game combines action gameplay, Templar spirituality, and educational elements about real historical locations along the French Way pilgrimage route. Players journey through 4 life phases (childhood, adolescence, adulthood as a Templar knight, and old age) across 32 levels.

### Tech Stack
- **Game Engine:** Godot 4.3+ (open source, 2D optimized)
- **Language:** GDScript (primary) / C# (optional)
- **Platform:** iOS (portrait 1080×1920)
- **Art Style:** Pixel art 16-bit (placeholders initially)
- **Version Control:** Git
- **IDE:** Godot Editor + VS Code (optional)

### Development Strategy
- **Phase 1 (Current):** Development with placeholder graphics (geometric shapes, solid colors)
- **Phase 2 (Final):** Professional pixel art and audio integration after gameplay validation
- See `PLACEHOLDER_STRATEGY.md` for complete development approach

### Key Dependencies
- **Godot 4.3+** (game engine)
- **Xcode** (iOS export and testing)
- **Git** (version control)
- **Aseprite** (future pixel art integration, $20)
- **Audio:** Freesound.org, Incompetech (temporary audio, free)

---

## Project Structure

```
pilgrim/
├── .git/                    # Git repository metadata
├── CLAUDE.md               # This file - AI assistant guide
├── README.md               # Project overview
├── PROJECT_ROADMAP.md      # Complete development plan
├── AI_AGENTS_WORKSTREAM.md # AI agent task organization
├── MOTOR_DECISION.md       # Engine selection analysis
├── PLACEHOLDER_STRATEGY.md # Development with placeholders strategy
├── .gitignore             # Git ignore patterns (to be created)
├── project.godot          # Godot project file (to be created)
├── export_presets.cfg     # iOS export configuration (to be created)
│
├── assets/                # Game assets (to be created)
│   ├── sprites/          # Placeholder sprites, later pixel art
│   ├── audio/            # Temporary audio files
│   │   ├── music/
│   │   └── sfx/
│   ├── fonts/            # UI fonts
│   └── concepts/         # AI-generated concept art (not in game)
│
├── scenes/               # Godot scene files (.tscn)
│   ├── main/            # Main game scenes
│   ├── levels/          # 32 level scenes
│   ├── ui/              # UI/HUD scenes
│   ├── characters/      # Player and NPC scenes
│   └── enemies/         # Enemy scenes
│
├── scripts/             # GDScript files
│   ├── core/           # Core systems (GameManager, SceneManager)
│   ├── player/         # Player controller and states
│   ├── enemies/        # Enemy AI scripts
│   ├── ui/             # UI controllers
│   ├── systems/        # Game systems (Virtue, Combat, etc.)
│   └── data/           # Data structures and constants
│
├── levels/              # Level definitions (JSON)
│   ├── phase_1/        # Childhood levels 1-8
│   ├── phase_2/        # Adolescence levels 9-16
│   ├── phase_3/        # Adulthood levels 17-24
│   └── phase_4/        # Old age levels 25-32
│
├── tests/               # Unit tests (GDScript)
│   ├── unit/
│   └── integration/
│
└── docs/                # Additional documentation
    ├── ARCHITECTURE.md
    ├── GAMEPLAY.md
    └── LEVEL_DESIGN_GUIDE.md
```

### Directory Conventions (Godot-specific)

- **Source code:** `scripts/` directory for all GDScript files
- **Scenes:** `scenes/` directory for all .tscn scene files
- **Assets:** `assets/` directory with subdirectories by type
- **Tests:** `tests/` directory using GUT (Godot Unit Testing)
- **Documentation:** `docs/` directory for technical docs
- **Build output:** `builds/` directory (git-ignored)

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

### Language-Specific Conventions (GDScript)

**Naming Conventions:**
- **Classes:** PascalCase (e.g., `PlayerController`, `EnemyWolf`)
- **Variables:** snake_case (e.g., `player_velocity`, `max_health`)
- **Constants:** SCREAMING_SNAKE_CASE (e.g., `MAX_SPEED`, `JUMP_HEIGHT`)
- **Functions:** snake_case (e.g., `move_player()`, `calculate_damage()`)
- **Signals:** snake_case with past tense (e.g., `health_changed`, `enemy_died`)
- **Private vars:** Prefix with `_` (e.g., `_internal_state`)

**Code Style:**
```gdscript
# Good example
extends CharacterBody2D
class_name Player

# Constants at top
const MAX_SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0

# Signals after constants
signal health_changed(new_health: int)
signal died()

# Exports for Inspector
@export var max_health: int = 100
@export var attack_damage: int = 10

# Private variables
var _current_health: int
var _is_attacking: bool = false

func _ready() -> void:
    _current_health = max_health

func _physics_process(delta: float) -> void:
    _handle_movement(delta)
    move_and_slide()

func _handle_movement(delta: float) -> void:
    # Clear implementation with comments for complex logic
    pass
```

**Best Practices:**
- Use static typing (`: Type`) whenever possible for performance
- One scene file per logical component
- Prefer composition over inheritance
- Use signals for communication between nodes
- Keep scripts under 300 lines; refactor if larger

### File Organization

**Scene Structure:**
```
PlayerScene
├── Sprite2D (visual representation)
├── CollisionShape2D (physics)
├── AnimationPlayer (animations)
├── AudioStreamPlayer (sounds)
└── [Script attached: player.gd]
```

**Script Template:**
```gdscript
extends [BaseClass]
class_name [ClassName]

# 1. Signals
# 2. Enums
# 3. Constants
# 4. Exported variables
# 5. Public variables
# 6. Private variables
# 7. Onready variables

# 8. Built-in virtual methods (_ready, _process, etc.)
# 9. Public methods
# 10. Private methods
```

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

Using **GUT (Godot Unit Test)** framework:

```bash
# Install GUT from Asset Library within Godot Editor
# Or add as git submodule

# Run all tests (from Godot Editor)
# Project → Tools → Run GUT Tests

# Run tests from command line (for CI/CD)
godot --path . -s addons/gut/gut_cmdln.gd

# Run specific test file
godot --path . -s addons/gut/gut_cmdln.gd -gtest=tests/unit/test_player.gd
```

**Test Example:**
```gdscript
extends GutTest

func test_player_takes_damage():
    var player = Player.new()
    player.max_health = 100
    player._ready()

    player.take_damage(30)

    assert_eq(player._current_health, 70, "Player should have 70 health")

func test_player_dies_at_zero_health():
    var player = Player.new()
    player.max_health = 100
    player._ready()

    watch_signals(player)
    player.take_damage(100)

    assert_signal_emitted(player, "died")
```

### Test Coverage Goals
- Aim for >70% code coverage (realistic for game dev)
- 100% coverage for critical systems (Virtue, Combat, Save/Load)
- All public APIs must have tests
- Physics and movement can be tested manually (harder to unit test)

---

## Common Tasks

### Setting Up Development Environment

**Prerequisites:**
1. **Mac with macOS 12.0+** (required for iOS development)
2. **Xcode 14.0+** with Command Line Tools
3. **Godot 4.3+** (download from godotengine.org)
4. **Git** (version control)

**Installation Steps:**

```bash
# 1. Install Xcode from App Store
# 2. Install Command Line Tools
xcode-select --install

# 3. Download Godot 4.3+ (standard version, not .NET)
# From: https://godotengine.org/download/macos/

# 4. Clone repository
git clone https://github.com/juanrafernandez/pilgrim.git
cd pilgrim

# 5. Open project in Godot
# File → Open Project → Select pilgrim folder

# 6. Configure iOS export
# Editor → Manage Export Templates → Download and Install
# Project → Export → Add → iOS
```

**iOS Export Configuration:**
1. Open Godot project
2. Project → Export → Add → iOS
3. Configure:
   - App Name: "Camino Maldito"
   - Bundle Identifier: com.yourname.caminomaldito
   - Orientation: Portrait
   - Display Resolution: 1080×1920
4. Set provisioning profile (requires Apple Developer account $99/year)

**Verification:**
```bash
# Test project opens in Godot
# Press F5 to run game in Godot (desktop version)
# Project → Export → iOS (will show any config issues)
```

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

# Godot operations
godot --path . --editor                    # Open project in editor
godot --path . -s scripts/main.gd          # Run specific script
godot --path . --export-debug iOS          # Export to iOS (debug)
godot --path . --export-release iOS        # Export to iOS (release)

# Testing
godot --path . -s addons/gut/gut_cmdln.gd  # Run all tests

# iOS building (after Godot export)
cd builds/ios
xcodebuild -project CaminoMaldito.xcodeproj -scheme CaminoMaldito -configuration Debug
```

### Godot-Specific Tips

**Performance:**
- Use `@onready var` for node references (faster than `get_node()` in `_ready()`)
- Avoid `get_node()` in `_process()` or `_physics_process()`
- Use object pooling for frequently spawned enemies
- Profile with Godot's built-in profiler (Debug → Profiler)

**iOS Specific:**
- Test on real device early and often
- Monitor memory usage (iOS is stricter than desktop)
- Texture compression: Enable ASTC for iOS
- Audio: Use Ogg Vorbis (not MP3) for better iOS performance
- Safe areas: Handle notch and home indicator properly

---

**Note to AI Assistants:** This document is your primary reference for working on this codebase. Always refer to it before making changes, and help keep it updated as the project evolves.
