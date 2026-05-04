## bridge.py
## FastAPI REST bridge for PostgreSQL access from Godot.
## Exposes POST /query and GET /health endpoints.
## Uses psycopg2 cursor_factory=RealDictCursor for clean JSON.

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import psycopg2
from psycopg2.extras import RealDictCursor
from typing import List, Dict, Any

app = FastAPI()

# Setup CORS to allow connections from Godot (localhost)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # In dev, allow all. Godot might use various localhost ports.
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

# Database config — peer auth: user "rend", host="localhost", db="fracture_throne"
DATABASE = {
    "host": "localhost",
    "database": "fracture_throne",
    "user": "rend",
    "password": "" # peer auth
}

@app.get("/health")
def health() -> Dict[str, str]:
    try:
        conn = psycopg2.connect(**DATABASE)
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.close()
        conn.close()
        return {"status": "ok"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/query")
def query(request: Dict[str, Any]) -> Dict[str, Any]:
    """Accepts { "sql": "...", "params": [...] }"""
    sql: str = request.get("sql", "").strip()
    params: List = request.get("params", [])

    if sql == "":
        raise HTTPException(status_code=400, detail="SQL query required")

    try:
        conn = psycopg2.connect(**DATABASE)
        cursor = conn.cursor(cursor_factory=RealDictCursor)
        cursor.execute(sql, params)
        rows = cursor.fetchall()
        conn.close()
        return {"rows": rows, "count": len(rows)}
    except psycopg2.Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)