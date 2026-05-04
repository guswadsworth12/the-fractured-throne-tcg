#!/usr/bin/env bash
cd /home/rend/Projects/the-fractured-throne-tcg/db
./venv/bin/uvicorn bridge:app --host 127.0.0.1 --port 8000 --reload