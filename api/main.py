from datetime import datetime, timezone, timedelta

from fastapi import FastAPI

app = FastAPI(title="Azure Sandbox API")


@app.get("/")
async def root():
    return {
        "message": "Hello Azure Sandbox!!!",
        "datetime": datetime.now(timezone(timedelta(hours=9))).isoformat(),
    }


@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "datetime": datetime.now(timezone(timedelta(hours=9))).isoformat(),
    }
