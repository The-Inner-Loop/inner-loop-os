# PRD

## Problem Statement
I waste time context-switching to GUI task apps. I need task management that lives in the terminal where I already work.

## Target User / Operator
Developers and terminal-native users who want fast, local task tracking.

## Core Functionality
- `task add "description"` — Add a new task
- `task list` — Show all tasks (pending first, then completed)
- `task complete <id>` — Mark a task as done
- `task delete <id>` — Remove a task entirely
- `task clear` — Remove all completed tasks

## Non-Goals
- No due dates (scope creep)
- No priorities (keep it flat)
- No tags or categories (YAGNI)
- No cloud sync (local-first forever)
- No GUI (terminal only)

## Constraints
- Python 3.8+ (no external dependencies)
- Single file implementation
- Data stored in ~/.tasks.json
- Must work on macOS, Linux, Windows
