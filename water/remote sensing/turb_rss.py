#!/usr/bin/env python
# coding: utf-8


import cv2
import numpy as np

def crop_img(image):
#     image = cv2.resize(image,(400,400))
    y,x,s = image.shape
    cx = x//2
    cy = y//2
    image_cropped = image[cy-100:cy+100, cx-100:cx+100]
    return image_cropped

img_s = cv2.imread("sun.jpg")
img_s = crop_img(img_s)
b_s,g_s,r_s = cv2.split(img_s)

img_w = cv2.imread("water1.jpg")
img_w = crop_img(img_w)
b_w,g_w,r_w = cv2.split(img_w)

img_c = cv2.imread("gray.jpg")
img_c = crop_img(img_c)
b_c,g_c,r_c = cv2.split(img_c)


Rs = np.mean(r_s)
# G = np.mean(g)
# B = np.mean(b)
Rw = np.mean(r_w)
Rc = np.mean(r_c)

# radiance
S = 100
alpha = 1/4
AS = (S*alpha)

Ls = Rs/AS
Lw = Rw/AS
Lc =  Rc/AS

# remote sensing reflectance
p = 3.14159265/0.18

Rrs= (Lw-(0.028*Ls))/(p*Lc)

# turbidity

turbidity = (22.57*Rrs)/(0.044 - Rrs) 
print(turbidity)




