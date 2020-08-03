from pysolar.solar import *
import math
import cv2
import numpy as np
from scipy.optimize import leastsq

img = cv2.imread("sun.jpg")
img = cv2.resize(img,(160,120))
when = datetime.datetime.now(tz=datetime.timezone.utc)

a  = -1 
b = -0.32
c = 10 
d = -3
e = 0.45

def Zenith_Sky(up,vp):
    return math.acos((vp*math.sin(Z_camera)+fc*math.cos(Z_camera))/(math.sqrt(fc**2+up**2+vp**2)))

def Azimuth_Sky(up,vp):
    return math.atan((fc*math.sin(A_camera)*math.sin(Z_camera)-up*math.cos(A_camera)-vp*math.sin(A_camera)*math.cos(Z_camera))/(fc*math.cos(A_camera)*math.sin(Z_camera)+up*math.sin(A_camera)-vp*math.cos(A_camera)*math.cos(Z_camera)))

def Angle_sun_sky(Z_sun,Z_sky,A_sky,A_sun):
    return math.acos((math.cos(Z_sun)*math.cos(Z_sky))+(math.sin(Z_sun)*math.sin(Z_sky)*math.cos(A_sky-A_sun)))
	
k = 0.5

A_sun = math.radians(get_azimuth(lat,lng,when))
Z_sun = math.radians(90 - get_altitude(lat,lng,when))

A_camera = 0
Z_camera = 1.57
fc = 25
Ip = []
L= []
Scaled = []
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        B,G,R = img[i,j]
        I = 0.2126*R+0.7152*G+0.0722*B
#         print(I)
        Ip.append(I)
        Z_sky = Zenith_Sky(i,j)
        A_sky = Azimuth_Sky(i,j)
        Angle = Angle_sun_sky(Z_sun,Z_sky,A_sky,A_sun)
        
        g = (1+a*math.exp(b/math.cos(Z_sky)))*(1+c*math.exp((d*math.cos(Angle))+e*(math.cos(Angle)**2)))
#         print(g)
        Scaled.append(k*g)
        L.append((I-k*g)**2)


Sca = np.array(Scaled)
IP = np.array(Ip)



def my_func(C, x, y):
    return IP - Sca

starting_guess = np.ones((2, 1))
data = (IP, Sca)


result = leastsq(my_func, starting_guess, args=data)
print(result)

solution = result[0]
print(solution[0])