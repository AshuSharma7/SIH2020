import numpy as np 
import matplotlib.pyplot as plt 
import math
import cv2
from statistics import mean
from matplotlib import style
    
def get_intencity(image_no):
    #Path tto be changed
    path="C:/Users/om/Desktop/sih\\test"+str(image_no)+".jpg"
    print(path)
    image = cv2.imread(path)
    
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    (minVal, maxVal, minLoc, maxLoc) = cv2.minMaxLoc(gray)    
    return (image[maxLoc])
    # display the results of our newly improved method
    

def get_am(zenith):
    return (1/math.cos(zenith))


def get_od(xs,ys):
    m=(-1*(math.log(mean(ys))-math.log(255))/mean(xs))
    return m

def get_red_alpha(t,t_o,):
    l=630
    l_o=450
    a=math.log(t/t_o)/math.log(l/l_o)
    return a

def get_blue_alpha(t,t_o):
    l=450
    l_o=520
    a=math.log(t/t_o)/math.log(l/l_o)
    return a

def get_green_alpha(t,t_o):
    l=520
    l_o=450
    a=math.log(t/t_o)/math.log(l/l_o)
    return a
def get_log(a):
    return math.log(a)

def red_plot_graph(xs,ys,od):
    b=255
    func=np.vectorize(get_log)
    ys=func(ys)
    regression_line = [(math.log(b)-(od*x)) for x in xs]
    
    style.use('ggplot')
    plt.scatter(xs,ys,color='#FF0000')
    plt.plot(xs, regression_line)
    plt.xlabel("Air mass")
    plt.ylabel("Log(Intensity)")
    plt.title("For red channel langley plot")
    plt.savefig('red.png')
    plt.show()
    

def blue_plot_graph(xs,ys,od):
    b=255
    func=np.vectorize(get_log)
    ys=func(ys)
    regression_line = [(math.log(b)-(od*x)) for x in xs]
    
    style.use('ggplot')
    plt.scatter(xs,ys,color='#0000FF')
    plt.plot(xs, regression_line)
    plt.xlabel("Air mass")
    plt.ylabel("Log(Intensity)")
    plt.title("For blue channel langley plot")
    plt.savefig('blue.png')
    plt.show()
    
    
    
def green_plot_graph(xs,ys,od):
    b=255
    func=np.vectorize(get_log)
    ys=func(ys)
    regression_line = [(math.log(b)-(od*x)) for x in xs]
    
    style.use('ggplot')
    plt.scatter(xs,ys,color='#32CD32')
    plt.plot(xs, regression_line)
    plt.xlabel("Air mass")
    plt.ylabel("Log(Intensity)")
    plt.title("For green channel langley plot")
    plt.savefig('green.png')
    plt.show()
    
    

def main():
    x=[]
    #Zenith angle fetech from app
    zenith=[29.022,25.74,23.907]
    for i in zenith: 
        x.append(get_am(i))
    y=[]
    #do not change
    image=[1,2,3 ]
    for i in image:
        a=get_intencity(i)
        y.append(a)
        
    x=np.array(x)
    y=np.array(y)
    print(x)

    red=y[:,2]
    green=y[:,1]
    blue=y[:,0]
    print(red)
    print(y)
    od_red=get_od(x,red)
    od_green=get_od(x,green)
    od_blue=get_od(x,blue)
    print("optical depth red",od_red)
    print("optical depttth green",od_green)
    print("optical depth blue",od_blue)
    red_alpha=get_red_alpha(od_red,od_blue)
    green_alpha=get_green_alpha(od_green,od_blue)
    blue_alpha=get_blue_alpha(od_blue,od_green)
    print("Red Channel Alpha",red_alpha)
    print("Green Chaneel Alpha",green_alpha)
    print("Blue Channel Alpha",blue_alpha)
    red_plot_graph(x,red,od_red)
    green_plot_graph(x,red,od_green)
    blue_plot_graph(x,red,od_blue)

if __name__ == "__main__": 
	main() 
