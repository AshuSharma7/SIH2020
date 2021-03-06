NM370 Android Application
===============


<img src="app.gif" width="230" height="408" />


Demo Video of Our Work till Now

## Problem Statement

Air/Water Turbidity estimation using mobile App

## Technology Stack

* Flutter
* Fast Api
* Deep Learning
* Image Processing
* Python

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

### Code for finding mean of RGB channel:
```objective-c
   Rs = np.mean(r_s) 

   Rw = np.mean(r_w)

   Rc = np.mean(r_c)
```



