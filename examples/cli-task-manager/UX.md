# UX

## Desired Feeling
Fast. Invisible. Like `ls` or `cd` — tools that just work without thinking.

## Primary User Flow
1. User opens terminal (already there)
2. Types `task add "Review PR #42"`
3. Sees confirmation: `Added: Review PR #42 [id: 3]`
4. Later, types `task list`
5. Sees numbered list of tasks
6. Types `task complete 3`
7. Sees confirmation: `Completed: Review PR #42`

## Failure States
- Invalid command → Show usage help (not an error wall)
- Invalid ID → "Task not found: <id>" (clear message)
- Corrupted data file → Backup and start fresh (don't crash)
- No tasks → "No tasks. Add one with: task add 'description'"

## Accessibility / Cognitive Load
- No config files to create
- No setup wizard
- No accounts
- Commands are guessable (add, list, complete, delete)
- IDs are simple integers, not UUIDs
