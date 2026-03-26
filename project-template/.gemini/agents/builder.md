---
name: builder
description: "Code builder agent — generates source code from master plan tasks"
model: gemini-2.5-pro
tools:
  - shell_command
  - read_file
  - write_file
  - edit_file
  - list_directory
---

<!-- PLACEHOLDER: Migrate from agent-v5/claude-code-v5/.claude/agents/builder.md (303 lines) -->
<!-- Key changes: Add YAML frontmatter, Claude tools → Gemini CLI tools,
     Agent Teams coordination → file-based task protocol -->
