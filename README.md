# Stop letting Claude Code rawdog your data. 

Put it in a container sandbox, with its own persistent home and tmp folders.

## Build the containers

Separated to allow quicker rebuilds / updates.

```bash
# Fedora base:
apptainer build fedora.sif fedora.def

# Install Claude code
apptainer build fedora-claude.sif fedora-claude.def
# MCP configs are installed into /opt/claude-mcp-templates/

# Install your dev and productivity tools
apptainer build fedora-claude-pkgs.sif fedora-claude-pkgs.def
```

## Configure

Modify top of `run.sh` to set container path, and enable/disable MCP servers.

## Run

Go into folder with work, run `path/to/claude-code-container/run.sh`

Claude Code can only see this folder.

```
$ cd ~/Tmp
 
$ ~/Claude/run.sh            
sending incremental file list

sent 123 bytes  received 13 bytes  272.00 bytes/sec
total size is 193  speedup is 1.42
Initializing project MCP config with servers: memory
Apptainer> ls ~/
Tmp

Apptainer> claude
                                                                                                        
╭─── Claude Code v2.1.19 ──────────────────────────────────────────────────────────────────────────────╮
...
```

## Aftermath

Persistence means Claude has memory.

```
$ ls ./.claude/
settings.local.json

$ ls -a ./.claude-workdir    
home  tmp  var_tmp

$ ls -a ./.claude-workdir/home                  
.bash_history  .cache  .claude  .claude.json  .claude.json.backup  Documents  .npm  .ssh

$ ls -a ./.claude-workdir/tmp    
node-compile-cache
```
