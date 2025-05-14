#!/bin/bash

# Update font cache
if command -v fc-cache &> /dev/null; then
  echo "Updating font cache..."
  fc-cache -fv
fi
