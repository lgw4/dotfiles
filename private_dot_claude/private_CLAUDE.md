# Global Claude instructions

## Solution Approach

- Follow YAGNI. Prefer the simplest solution that solves the actual problem; don't add speculative abstraction.
- Before editing any file, read it first. Before modifying a function, grep for all callers. Research before you edit.

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
