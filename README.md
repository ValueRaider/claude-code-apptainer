# claude-code-apptainer
Stop letting Claude Code rawdog your data. Put it in a container.


## Step 1: build the containers

Separated to allow quicker rebuilds / updates.

### Build Fedora base
```bash
apptainer build fedora.sif fedora.def
```

### Install Claude code

MCP configs are installed into /opt

```bash
apptainer build fedora-claude.sif fedora-claude.def
```

### Install your dev and productivity tools

```bash
apptainer build fedora-claude-pkgs.sif fedora-claude-pkgs.def
```

## Step 2:

Modify top of `run.sh` if you want to enable different MCP servers.

## Step 3:

Go into folder with work, run `path/to/claude-code-container/run.sh`
