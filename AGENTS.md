# Agent Instructions

This repository uses the [superpowers](https://github.com/jchook/superpowers) skill system for all AI-assisted development. Every agent session working in this repo MUST follow these workflows.

## Required Skills

All agents MUST load and follow these skills (via the `Skill` tool or equivalent) before taking any action:

| Skill | When |
|---|---|
| `using-superpowers` | Start of every session |
| `brainstorming` | Before any creative/feature work |
| `writing-plans` | Before any multi-step implementation |
| `executing-plans` | When implementing from a plan in a separate session |
| `subagent-driven-development` | When implementing from a plan in the current session |
| `test-driven-development` | Before writing implementation code |
| `systematic-debugging` | Before proposing fixes for bugs |
| `verification-before-completion` | Before claiming work is done |
| `finishing-a-development-branch` | After all tasks pass, before merge/PR |
| `requesting-code-review` | After completing major features |
| `receiving-code-review` | When processing review feedback |
| `using-git-worktrees` | When starting isolated feature work |

## Planning Workflow

All non-trivial work follows this sequence:

1. **Brainstorm** -- Understand the problem, explore requirements
2. **Write a plan** -- Save to `docs/plans/YYYY-MM-DD-<feature-name>.md`
3. **Execute the plan** -- Task by task, with review checkpoints
4. **Verify** -- Run builds/tests, confirm success with evidence
5. **Finish** -- PR or merge via the finishing skill

Plans are the source of truth for what was decided and why. They include corrections discovered during implementation. Future agents should read existing plans in `docs/plans/` for context on past decisions.

## Repository-Specific Context

### Build System

This is a [BuildStream 2](https://buildstream.build/) project that builds a GNOME OS derivative (Bluefin). Key facts agents need:

- **Build target:** `oci/bluefin.bst` -- produces a bootc-compatible OCI image
- **Build container:** GNOME's `bst2` Docker image (pinned SHA in workflow)
- **Upstream caches:** `gbm.gnome.org:11003` (read-only, GNOME's shared CAS)
- **Project cache:** Cloudflare R2 via `bazel-remote` sidecar (read-write)
- **Output registry:** `ghcr.io/projectbluefin/egg` (GHCR)
- **Local dev:** Use `just build` (see `Justfile`)

### CI/CD

- GitHub Actions workflow: `.github/workflows/build-egg.yml`
- Runs on `ubuntu-24.04` with disk space reclamation
- BuildStream runs inside a podman container, NOT directly on the runner
- The `bazel-remote` cache proxy runs on the host, bst2 container reaches it via `--network=host`

### File Layout

```
.github/workflows/    # CI/CD pipelines
docs/plans/           # Implementation plans (read these for context)
elements/             # BuildStream element definitions
  bluefin/            # Bluefin-specific packages
  core/               # Core system overrides
  oci/                # OCI image assembly (build targets here)
  plugins/            # BuildStream plugin junctions
files/                # Static files overlaid into the image
include/              # Shared YAML includes (aliases, etc.)
patches/              # Patches applied to upstream junctions
```

### Key Decisions Log

Agents should read `docs/plans/` for full context. Summary of major decisions:

- **bst2 container via podman** (not pip install, not Homebrew) -- consistent with GNOME upstream CI
- **CLI flags for CI-only cache config** (not project.conf) -- avoids affecting local dev builds
- **`on-error: continue`** in CI -- find all failures, don't stop at first
- **R2 cache push only on main** -- PRs don't write to shared cache
- **`bazel-remote` as CAS bridge** -- BuildStream needs gRPC CAS, R2 speaks S3; bazel-remote bridges them

## Conventions

- Plans go in `docs/plans/YYYY-MM-DD-<feature-name>.md`
- Commit messages follow conventional commits (`feat:`, `fix:`, `ci:`, `docs:`, `chore:`)
- The `.opencode/` directory is local agent state and is gitignored
- YAML files use 2-space indentation
- Shell scripts in workflows use `${VAR}` notation and double-quote all expansions
