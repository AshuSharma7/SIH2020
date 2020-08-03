#!/usr/bin/env python
# coding: utf-8

import matplotlib.pyplot as plt

def hist(image):
    _ = plt.hist(image[:, :, 0].ravel(), bins = 256, color = 'red', alpha = 0.5)
    _ = plt.hist(image[:, :, 1].ravel(), bins = 256, color = 'Green', alpha = 0.5)
    _ = plt.hist(image[:, :, 2].ravel(), bins = 256, color = 'Blue', alpha = 0.5)
    _ = plt.xlabel('Intensity Value')
    _ = plt.ylabel('Pixel Count')
    _ = plt.legend([ 'Red_Channel', 'Green_Channel', 'Blue_Channel'])

    plt.title("Histogram")
    plt.savefig('hist.png')
    
    
image = cv2.imread('sun.jpg')
hist(image)
image = cv2.imread('water.jpg')
hist(image)
image = cv2.imread('gray.jpg')
hist(image)

