#!/bin/bash
## Startup script for the PostgreSQL REST bridge.
cd /home/rend/Projects/the-fractured-throne-tcg/db

# Use the existing venv
./venv/bin/pip install -r requirements.txt
./venv/bin/uvicorn bridge:app --host 127.0.0.1 --port 8000 --reload