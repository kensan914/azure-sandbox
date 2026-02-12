from fastapi import FastAPI

app = FastAPI(title="Azure Sandbox API")


@app.get("/")
async def root():
    return {"message": "Hello Azure Sandbox!!!"}


@app.get("/health")
async def health():
    return {"status": "healthy"}
