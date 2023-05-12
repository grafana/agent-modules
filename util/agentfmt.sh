#!/bin/bash
set -euo pipefail

#
# Recursively search a directory for .river files and format them.
#
# Prereq: Clone https://github.com/grafana/agent and follow the instructions
#         for executing `go run` commands
#
# Example Command: $AGENT_MODULES_REPO_DIR/util/agentfmt.sh $AGENT_REPO_DIR $AGENT_MODULES_REPO_DIR

AGENT_DIR=$1
TARGET_DIR=$2

echo "Building agent binary"
pushd "$AGENT_DIR"
    make agent
popd


find "$TARGET_DIR" -name "*.river" -print0 | while read -rd $'\0' file
do
    # This should probably be more clever than having to run the go project for every file but does the job for now...
    echo "Formatting $file"
    AGENT_MODE=flow "$AGENT_DIR/build/grafana-agent" fmt -w "$file"
done