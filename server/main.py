from fastapi import FastAPI
from pysolar.solar import *
from pydantic import BaseModel
import pandas._libs.tslibs.np_datetime
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from tensorflow.keras.preprocessing.image import img_to_array
from tensorflow.keras.models import load_model
import numpy as np
import cv2
import os

# Instance of FastAPI class
app = FastAPI()

model = load_model('../water/model.h5')


class SunModel(BaseModel):
    latitude: float
    longitude: float


class WaterModel(BaseModel):
    imageurl: str


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
async def water(apiModel: WaterModel):
    if(not apiModel.imageurl):
        return {"message": "No Image url passed"}
    os.system("wget -O image.jpg " + apiModel.imageurl)
    imgpath = 'image.jpg'
    image = cv2.imread(imgpath)
    orig = image.copy()
    (h, w) = image.shape[:2]

    img = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    img = cv2.resize(img, (150, 150))
    img = img_to_array(img)
    img = preprocess_input(img)
    img = np.expand_dims(img, axis=0)

    (h, l, m) = model.predict(img)[0]

    val = max(h, l, m)
    if val == h:
        label = "HIGH"
    elif val == l:
        label = "LOW"
    else:
        label = "MEDIUM"
    color = (0, 0, 255)

    label = "{}: {:.2f}%".format(label, max(h, l, m) * 100)
    return {"message": label}
