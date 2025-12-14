# AGENTS.md

This file provides guidance to AI agents and agentic coding tools when working with code in this repository.

## Build Commands

```bash
# Build the project
zig build

# Run the executable
zig build run

# Run all tests
zig build test

# Run tests with fuzz testing
zig build test --fuzz
```

## Architecture

This is a standard Zig project with a dual-module structure:

- **Library module** (`src/root.zig`): Exposed as `zig_playground` module, contains reusable business logic
- **Executable module** (`src/main.zig`): CLI entry point that imports and uses the library module via `@import("zig_playground")`

The executable depends on the library module through the build system's imports mechanism defined in `build.zig`.

## Requirements

- Zig 0.15.2 or later
