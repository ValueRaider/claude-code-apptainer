#!/bin/bash


CONTAINER="$HOME/Claude/fedora-claude-pkgs.sif"


# Select MCP servers present in container.
# Space-delimited string
# Options: filesystem memory sequential-thinking playwright
MCP_SERVERS="memory"  # essential
# MCP_SERVERS=playwright  # optional


_PWD=`pwd`
MCP_CONFIG="$_PWD/.mcp.json"

# Create container home directory
# All state (.claude, .config, .cache, etc.) will live here naturally
WORKDIR="$_PWD/.claude-workdir"
mkdir -p "$WORKDIR"
mkdir -p "$WORKDIR/home/.claude"


# CLAUDE.md tells LLM it is in a container
cp "$HOME/Claude/CLAUDE.md" "$WORKDIR/home/.claude/"


# settings.json is allow list
cp "$HOME/Claude/settings.json" "$WORKDIR/home/.claude/"


# Copy over global skills:
mkdir -p "$WORKDIR/home/.claude/skills"
rsync -av "$HOME"/Claude/Skills/ "$WORKDIR/home/.claude/skills/"


# Set memory file path for MCP server
MEMDIR="$WORKDIR/home/.claude/memory"
mkdir -p "$MEMDIR"
MEMORY_FILE_PATH="$MEMDIR/knowledge-graph.json"


# Enable your MCP tools, by concatenating
# files already in /opt/claude-mcp-templates/ in container
if [ "$MCP_SERVERS" != "" ]; then
    echo "Initializing project MCP config with servers: $MCP_SERVERS"

    MCP_SERVERS_CSV=`echo "\"$MCP_SERVERS\"" | sed "s/ /\",\"/g"`

    # Build .mcp.json from selected MCP servers
    echo '{' > "$MCP_CONFIG"
    echo '  "mcpServers": {' >> "$MCP_CONFIG"

    # Add selected servers by reading templates from container
    first=true
    for server in $MCP_SERVERS; do
        template="/opt/claude-mcp-templates/$server.json"
        template_j2="/opt/claude-mcp-templates/$server.json.j2"

        # Check for .j2 template first, then regular .json
        if apptainer exec "$CONTAINER" test -f "$template_j2" 2>/dev/null; then
            if [ "$first" = false ]; then
                echo ',' >> "$MCP_CONFIG"
            fi
            # Read template and substitute placeholders
            apptainer exec "$CONTAINER" cat "$template_j2" | \
                sed "s|{{MEMORY_FILE_PATH}}|$MEMORY_FILE_PATH|g" >> "$MCP_CONFIG"
            first=false
        elif apptainer exec "$CONTAINER" test -f "$template" 2>/dev/null; then
            if [ "$first" = false ]; then
                echo ',' >> "$MCP_CONFIG"
            fi
            apptainer exec "$CONTAINER" cat "$template" >> "$MCP_CONFIG"
            first=false
        else
            echo "Warning: MCP server template '$server' not found in container" >&2
        fi
    done

    # Close JSON with minimal required fields
    echo '' >> "$MCP_CONFIG"
    echo '  },' >> "$MCP_CONFIG"
    echo "  \"enabledMcpjsonServers\": [$MCP_SERVERS_CSV]," >> "$MCP_CONFIG"
    echo '  "disabledMcpjsonServers": []' >> "$MCP_CONFIG"
    echo '}' >> "$MCP_CONFIG"
else
    rm -f "$MCP_CONFIG"
fi


# Setup container jail and launch
BINDS=""
# - current directory (project workspace)
BINDS+=" --bind $_PWD:$_PWD"

apptainer shell --shell /bin/bash --contain \
  --pwd "$_PWD" \
  $BINDS \
  --writable-tmpfs \
  --workdir "$WORKDIR" \
  "$CONTAINER"
