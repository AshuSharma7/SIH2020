from fastapi import FastAPI
from pysolar.solar import *
from pydantic import BaseModel

# Instance of FastAPI class
app = FastAPI()


class SunModel(BaseModel):
    latitude
    float
    longitude: float


@app.post("/")
async def root():
    return {"message": "dummy"}


@app.post("/sun")
async def sun():
    return {"message": "sun"}
