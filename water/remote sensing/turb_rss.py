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
	
def mean(r):
    return np.mean(r)
	
def radiance(DN,alpha=1/4,S=100):
    L = DN/(S*alpha)
    return L
	
def reflectance(Ls,Lw,Lc):
    p = 3.14159265/0.18 
    Rrs= (Lw-(0.028*Ls))/(p*Lc)
    return Rrs
    
def turbidity(Rrs):
    turb = (22.57*Rrs)/(0.044 - Rrs)
    return turb
	

img_s = cv2.imread("sun.jpg")
img_s = crop_img(img_s)
b_s,g_s,r_s = cv2.split(img_s)

img_w = cv2.imread("water1.jpg")
img_w = crop_img(img_w)
b_w,g_w,r_w = cv2.split(img_w)

img_c = cv2.imread("gray.jpg")
img_c = crop_img(img_c)
b_c,g_c,r_c = cv2.split(img_c)


if DN_s is None:
    Rs = mean(r_s)
else:
    Rs = DN_s
if DN_w is None:
    Rw = mean(r_w)
else:
    Rw = DN_w
if DN_c is None:
    Rc = mean(r_c)
else:
    Rc = DN_c
	
if (alpha,S) is (None,None): 
    Ls = radiance(Rs)
    Lw = radiance(Rw)
    Lc = radiance(Rc)
else:
    Ls = radiance(Rs,alpha,S)
    Lw = radiance(Rw,alpha,S)
    Lc = radiance(Rc,alpha,S)

Rrs = reflectance(Ls,Lw,Lc)
turbidity = turbidity(Rrs)

print(turbidity)




