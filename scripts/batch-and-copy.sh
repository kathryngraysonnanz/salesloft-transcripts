#!/bin/bash

# ─────────────────────────────────────────────
# run.sh
# Wrapper script for the SalesLoft transcript
# batch job. Handles environment setup before
# calling each step in the pipeline.
#
# Paths are resolved relative to this script's
# location, so it works on any machine.
# ─────────────────────────────────────────────

# Exit immediately if any command fails
set -e

# Resolve the directory this script lives in,
# regardless of where it's called from
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Log output with timestamps
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# ── Environment setup ──────────────────────────

# Add common node/npm locations to PATH so cron can find them
export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH

# Load .env from project root and export all variables
set -a
source "$PROJECT_ROOT/.env"
set +a

# Always run from the scripts folder regardless of
# where this script is called from
cd "$SCRIPT_DIR"

# ── Pipeline ───────────────────────────────────

log "Starting batch download..."
node ../cli/batch.js

log "Copying files to OneDrive..."
cp -Rv "$PROJECT_ROOT/recordings/" "$HOME/OneDrive/SalesLoft_Transcripts" || { log "cp failed with exit code $?"; exit 1; }

log "Cleaning up recordings folder..."
rm -rf "$PROJECT_ROOT/recordings/"*

log "Done!"