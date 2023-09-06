import numpy as np 
import matplotlib.pyplot as plt

def general1qgate(a,b,c):
    u2 = np.matrix([[             np.cos(a/2), -np.exp(1j*c)    *np.sin(a/2)],
                    [np.exp(1j*b)*np.sin(a/2),  np.exp(1j*(b+c))*np.cos(a/2)]])
    return u2

I = general1qgate(0,0,0)
H = general1qgate(np.pi/2,0,np.pi)
Z = general1qgate(0,0,np.pi)
print(I)

players = 3
av_re = 10
perf = 10 * av_re / (players // 2)
print((perf))