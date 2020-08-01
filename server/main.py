from fastapi import FastAPI

# Instance of FastAPI class
app = FastAPI()


@app.post("/")
async def root():
    return {"message": "dummy"}


@app.post("/sun")
async def sun():
    return {"message": "sun"}
