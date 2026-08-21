# Global Claude instructions

## Solution approach

- Follow YAGNI. Prefer the simplest solution that solves the actual problem; don't add speculative abstraction.
- Before editing any file, read it first. Before modifying a function, grep for all callers. Research before you edit.
- When writing any Python code, consult any matching `fluent-python:*` skills.

## Tidy First approach

- Separate all changes into two distinct types:
    1. Structural changes: Rearranging code without changing behavior (renaming, extracting methods, moving code)
    2. Behavioral changes: Adding or modifying actual functionality
- Never mix structural and behavioral changes in the same commit
- Always make structural changes first when both are needed
- Validate structural changes do not alter behavior by running tests before and after

## Commit discipline

- Only commit when:
    1. ALL tests are passing
    2. ALL compiler/linter warnings have been resolved
    3. The change represents a single logical unit of work
    4. Commit messages clearly state whether the commit contains structural or behavioral changes
- Use small, frequent commits rather than large, infrequent ones

## Subagents

- Spawn subagents automatically when a task calls for it; you do not need me to request one each time. The standing instruction overrides any session default that says otherwise.
- Always delegate git and GitHub operations to the `git-ops` agent.
- Workflows and deep research remain opt-in: ask before running one.

## Typography

- Do not use em-dashes unless no other punctuation will do
- Em-dashes are tight (no spaces): word—word, not word — word
- En-dashes are tight (no spaces): 2020–2025, not 2020 – 2025
- Hyphens are tight (no spaces): well-known, not well - known
- Slashes are tight (no spaces): and/or, not and / or

## Tooling

- Prefer `gh` CLI over any MCP for GitHub operations
- Prefer `rg` (ripgrep) for file search; fall back to `grep`/`find` if unavailable
- When writing shell scripts, always use pure Bourne shell (that is, `/usr/bin/env sh`)
