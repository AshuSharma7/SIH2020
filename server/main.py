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
from PIL import Image
import cv2
import base64
import io

# Instance of FastAPI class
app = FastAPI()

model = load_model('../water/model.h5')


class SunModel(BaseModel):
    latitude: float
    longitude: float


class WaterModel(BaseModel):
    image: str


class TurbidModel(BaseModel):
    skyImage: str
    waterImage: str
    greyImage: str


def crop_img(image):
    y, x, s = image.shape
    cx = x//2
    cy = y//2
    image_cropped = image[cy-100:cy+100, cx-100:cx+100]
    return image_cropped


def stringToRGB(base64_string):
    imgdata = base64.b64decode(str(base64_string))
    image = Image.open(io.BytesIO(imgdata))
    return cv2.cvtColor(np.array(image), cv2.COLOR_BGR2RGB)


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
    # if(not apiModel.imageurl):
    #     return {"message": "No Image url passed"}
    # os.system("wget -O image.jpg " + apiModel.imageurl)
    # imgpath = 'a.jpg'
    image = stringToRGB(apiModel.image)
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


@app.post("/turbidity")
async def turbid(turbidModel: TurbidModel):
    img_s = stringToRGB(turbidModel.skyImage)
    img_s = crop_img(img_s)
    b_s, g_s, r_s = cv2.split(img_s)

    img_w = stringToRGB(turbidModel.waterImage)
    img_w = crop_img(img_w)
    b_w, g_w, r_w = cv2.split(img_w)

    img_c = stringToRGB(turbidModel.greyImgage)
    img_c = crop_img(img_c)
    b_c, g_c, r_c = cv2.split(img_c)

    Rs = np.mean(r_s)
    # G = np.mean(g)
    # B = np.mean(b)
    Rw = np.mean(r_w)
    Rc = np.mean(r_c)

    S = 100
    alpha = 1/4
    AS = (S*alpha)

    Ls = Rs/AS
    Lw = Rw/AS
    Lc = Rc/AS

    p = 3.14159265/0.18

    Rrs = (Lw-(0.028*Ls))/(p*Lc)

    turbidity = (22.57*Rrs)/(0.044 - Rrs)
    return {"turbidity": turbidity}
