from fastapi import FastAPI
from pysolar.solar import *
from pydantic import BaseModel
import datetime


# Instance of FastAPI class
app = FastAPI()


class SunModel(BaseModel):
    latitude: float
    longitude: float


@app.post("/")
async def root():
    return {"message": "dummy"}


@app.post("/sun")
async def sun(apiModel: SunModel):
    date = datetime.datetime.now(tz=datetime.timezone.utc)
    azimuth = get_azimuth(apiModel.latitude, apiModel.longitude, date)
    altitude = get_altitude(apiModel.latitude, apiModel.longitude, date)
    return {"azimuth": azimuth, "altitude": altitude, "zenith": 90 - altitude}


@app.post("/water")
async def water():
    return {"message": "dummy"}
