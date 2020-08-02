# SERVER & REST API
Server built using Python and FastAPI to handle API requests and return requested calculated values to user


## DEPLOYMENT

> uvicorn main:app --host 0.0.0.0 --port 80


## ENDPOINTS

### **{url}/water**

> POST body
```
{
    imageurl: (base64 encoded image String)
}
```

> response body
```
{
    "message": "turbidity"
}
```
### **{url}/sun**

> POST body
```
{
    latitude: float
    longitude: float
}
```

> Rseponse body
```
{
    "azimuth": float,
    "zenith": float,
    "altitude": float
}
```

### **{url}/turbidity**

> POST body
```
{
    skyImge: String(base64)
    waterImage: String(base64)
    greyImage: String(base64)
}
```

> Rseponse body
```
{
    turbidity: float
}
```