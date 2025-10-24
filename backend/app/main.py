import time
from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
import os
import databases
import sqlalchemy
from sqlalchemy.exc import OperationalError
from fastapi.middleware.cors import CORSMiddleware

# Database URL from environment
DATABASE_URL = os.getenv(
    "DATABASE_URL",
    "postgresql+psycopg2://postgres:postgres@db:5432/idea_board"
)

# Retry connecting to the database until it's ready
for attempt in range(10):
    try:
        engine = sqlalchemy.create_engine(DATABASE_URL)
        conn = engine.connect()
        conn.close()
        print("✅ Connected to the database!")
        break
    except OperationalError:
        print(f"⏳ Database not ready, retrying ({attempt + 1}/10)...")
        time.sleep(3)
else:
    raise Exception("❌ Could not connect to the database after 10 attempts.")

# Initialize async database connection
database = databases.Database(DATABASE_URL)
metadata = sqlalchemy.MetaData()

# Define ideas table
ideas = sqlalchemy.Table(
    "ideas",
    metadata,
    sqlalchemy.Column("id", sqlalchemy.Integer, primary_key=True),
    sqlalchemy.Column("content", sqlalchemy.String),
    sqlalchemy.Column("created_at", sqlalchemy.DateTime),
)

# Create table if it doesn't exist
metadata.create_all(engine)

# Initialize FastAPI
app = FastAPI(title="Idea Board API")

# Add CORS middleware for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # For development; restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic model for incoming ideas
class IdeaCreate(BaseModel):
    content: str

# Connect/disconnect events
@app.on_event("startup")
async def startup():
    await database.connect()

@app.on_event("shutdown")
async def shutdown():
    await database.disconnect()

# Get all ideas
@app.get("/api/ideas")
async def get_ideas():
    query = ideas.select().order_by(ideas.c.created_at.desc())
    rows = await database.fetch_all(query)
    return [
        {"id": r["id"], "content": r["content"], "created_at": r["created_at"].isoformat()}
        for r in rows
    ]

# Create a new idea
@app.post("/api/ideas")
async def create_idea(idea: IdeaCreate):
    query = ideas.insert().values(content=idea.content, created_at=datetime.utcnow())
    last_record_id = await database.execute(query)
    return {"id": last_record_id, "content": idea.content}
