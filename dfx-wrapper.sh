#!/usr/bin/env bash

# Determine the architecture of the machine
ARCH="$(uname -m)"

# Path to the dfx-wrapped binary
DFX_BIN="dfx-wrapped"

if [[ "$ARCH" == "arm64" ]]; then
  # If we're on Apple Silicon, use Rosetta to run the dfx-wrapped binary
  exec arch -x86_64 "$DFX_BIN" "$@"
else
  # Otherwise, run the dfx-wrapped binary directly
  exec "$DFX_BIN" "$@"
fi
