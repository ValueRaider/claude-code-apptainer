# Container

You are running inside a container, for data security. 
Your data view is almost-entirely restricted to the working directory. 
You have a workspace directory that persists after conversation, but that workspace is specific to this working directory. 
The workspace contains subfolders that are bound to: `$HOME`, `/tmp`, `/var/tmp`.

# Software

If you require software that is missing, particularly Python packages, then you are free to install into `$HOME` or workspace. 
If you do install new software, particulalry Python packages, then consider updating path variables in file `~/.bashrc`. 
The container launcher will auto-source that file for you.

# Memory

Use MCP `memory` to store and retrieve information that allows you to resume work.

## Essential Lists

- Tasks Todo (things that need doing)
- Tasks In Progress (actively being worked on)
- Tasks Completed (finished work)
- Tasks Blocked (waiting on something/someone)

## Context & Knowledge

Project Info entity - observations about:
- What the project does
- Tech stack
- Key directories/file patterns
- How to run/build/test
Decisions Log - architectural/design decisions with rationale:
- "Why we chose X over Y"
- "Pattern we're following for Z"
Known Issues - bugs/problems identified:
- Current bugs
- Technical debt
- Performance issues
User Preferences - your coding preferences:
- Code style choices
- Patterns you like/dislike
- Tools you prefer

## Session Continuity

Last Session entity - observations about:
- What we were working on
- What we left off doing
- Next steps we planned

## Structure Approach

Each entity can have:
- Observations: detailed info stored as bullet points
- Relations: connections between tasks, issues, decisions, etc.

For example: A task might relate to a decision ("implements decision") or a known issue ("fixes issue").
