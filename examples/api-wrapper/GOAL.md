# GOAL

## Desired Outcome
A Python library that wraps the OpenWeather API with clean, typed interfaces and sensible defaults.

## Why This Matters
Raw API calls require boilerplate: auth handling, error parsing, response mapping. A wrapper eliminates repeated work across projects.

## Success Criteria
- Single import to start using
- Type hints for all public methods
- Handles rate limiting gracefully
- Returns dataclasses, not raw dicts
- Works with free tier API key
- Published to PyPI
