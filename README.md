# git-agent

**Agent-aware version control** — attach structured agent reasoning context to git commits.

No fork of git needed. Pure Python scripts that leverage `git-<cmd>` extension mechanism + `git notes`.

## The Problem

Traditional Git captures **what changed** but not **why it changed**. When agents make changes:

1. An agent explores multiple approaches, hits errors, weighs alternatives — only the final diff is committed
2. A second agent taking over the project reverse-engineers intent from raw diffs
3. Multiple agents in parallel have no shared "reasoning cache"

## The Solution

Three CLI tools that augment Git with structured **Agent Context Snapshots**:

### `git agent-commit`

```bash
# Agent mode (recommended)
git agent-commit --context context.json -m "feat: add online softmax to FlashAttention"

# Interactive mode (human)
git agent-commit -m "fix: resolve shared memory bank conflict"
```

The context JSON stores the agent's reasoning:

```json
{
  "task": "Add online softmax to FlashAttention kernel",
  "approach": "Warp-level reduce + shared memory tiling",
  "alternatives_considered": ["pure register", "global memory accumulate"],
  "rejected": "Register approach caused spilling on 1024-thread config",
  "diff_rationale": "block_N = 64 avoids 32-bank conflict",
  "relevant_sessions": ["2026-07-15-fa-optimization"]
}
```

This is stored as a **git note** under `refs/notes/agent-context` — no commit SHA changes, pushable/pullable.

### `git agent-log`

```bash
git agent-log                    # Recent commits with agent context inline
git agent-log --search "tiling"  # Keyword search across contexts
git agent-log --json             # Machine-readable output
git agent-log -v                 # With diff stats
git agent-log -n 20
```

### `git agent-index`

```bash
git agent-index                  # Build full index (.git/agent-context-index.json)
git agent-index --stats          # Show index statistics
git agent-index --query "flash"  # Semantic keyword search
git agent-index --commit HEAD    # Index a single new commit
```

## Install

```bash
git clone https://github.com/freezetheflame/git-agent
cd git-agent
chmod +x install.sh
./install.sh          # default: /usr/local/bin
# or: ./install.sh ~/.local/bin
```

Requires: **Python 3 + git**. No external dependencies.

## Share Agent Context with Team

```bash
# Push notes to remote
git push origin refs/notes/agent-context

# Pull notes from remote (clone-side)
git fetch origin refs/notes/agent-context:refs/notes/agent-context
```

## Multi-Agent Coordination

Context fields support cross-agent workflow:

```json
{
  "depends_on": "abc123def",
  "aware_of": ["def456abc"],
  "confidence": "experimental"
}
```

## Design

- **Storage**: `git notes` (separate git objects, no SHA changes, pushable)
- **Format**: JSON (machine-writeable, stdlib, unambiguous)
- **No fork**: `git-<cmd>` extension mechanism — zero C code changes
- **Index**: Opt-in flat-file index, built on demand

## Origin

Idea by [freezetheflame](https://github.com/freezetheflame), July 2026.
