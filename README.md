NM370 Android Application
===============

# Approach of Water Turbidity
Like till now we have used two Approaches which are as Follows:

* Deep Learning Approach
* Remote Sensing Reflectance Approach

## Deeplearning Approach
In this approach we have used a Dataset of 1000 images(approx.) of Water. The user upload the image of Water and using RestFul Api the Image is go to Server where our Deep Learning Model is Deployed so that image is compared with the images present in our Dataset and after processing the Api will return the level of turbidity(like, Low, High, Medium) and it's precentage that how much our values is accurate.

## Remote Sensing Reflectance Approach
The three images required to calculate the remote sensing reflectance are: 
* An image of the water surface.
* An image of the sky.
* An image of a photographers gray card.

The user takes both the sky and water images 135° from the azimuth angle of the sun. Which is already provided in our App and the Values are coming from Restful Api and we are sending the Latitude and Longitude of User and the Api return us Azimuth Angle.

### RestFul Api's:
```objective-c
 - http://ec2-52-71-253-148.compute-1.amazonaws.com/sun
 - http://ec2-52-71-253-148.compute-1.amazonaws.com/water
 -http://ec2-52-71-253-148.compute-1.amazonaws.com/turbidity

```



