# AGENTS.md

## Project

- Keep code compatible with `minimum_zig_version` in `build.zig.zon` (currently Zig 0.15.2).
- `src/root.zig`: reusable library logic, exposed as `zig_playground`.
- `src/main.zig`: CLI entry point; imports the library with `@import("zig_playground")`.
- `build.zig`: defines commands and wires the executable's dependency on the library.

## Commands

Run from the repository root:

| Command | Purpose |
| --- | --- |
| `zig build` | Build the executable. |
| `zig build run` | Build and run the executable. |
| `zig build test` | Run the library and executable tests. |
| `zig build test --fuzz` | Run fuzz testing when requested or relevant to the change. |

## Verification

- For code changes, run `zig build test`; also run `zig build` when changing build configuration or executable behavior.
- For documentation-only changes, inspect accuracy and links and run `git diff --check`; application tests are unnecessary.
- Report the commands run and their results, including failures or checks that could not run. Repeat checks when subsequent changes or unresolved failures justify them.

## Explanations

- For ordinary changes, explain what changed, why it works, and the relevant verification.
- Use complete runnable examples and line-by-line walkthroughs when requested or useful for teaching; match examples to the project's Zig version.
- Consult version-matched official Zig documentation for language and standard-library decisions, and cite the pages used.
