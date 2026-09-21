# AGENTS.md

## Project

This repository is a Zig playground for trying out whatever is worth trying: the language,
the standard library, third-party libraries, and tooling.
Keep it simple: no production-grade structure, no premature abstractions, no nitpicking.
Breaking changes are fine: nothing depends on this code. Rewrite or delete freely instead of
keeping backward compatibility.

Target the Zig version in `build.zig.zon` (`minimum_zig_version`) and base decisions on the
official documentation for that version.

## Core principles

- Document at the right layer: Code → How, Tests → What, Commits → Why, Comments → Why not
- Keep documentation up to date with code changes
