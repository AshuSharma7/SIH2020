# SERVER & REST API
Server built using Python and FastAPI to handle API requests and return requested calculated values to user


## DEPLOYMENT

> uvicorn main:app --host 0.0.0.0 --port 80


## ENDPOINTS

### **{url}/water**

> POST body
```
{
    imageurl: String #url of image
}
```

> response body
```
{
    "message": "turbidity"
}
```
