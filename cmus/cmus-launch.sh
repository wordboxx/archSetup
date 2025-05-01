#!/bin/bash
echo "Starting Cmus"
cmus-remote -C clear
cmus-remote -C "add ~/Music"
cmus-remote -C "update-cache -f"
cmus
