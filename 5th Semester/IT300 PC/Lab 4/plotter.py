import matplotlib.pyplot as plt
import sys

def main():
    x_axis,y_axis = [],[]

    with open('output.txt','r') as f:
        lines = f.readlines()
        for line in lines:
            listx = line.split()
            x_axis.append(int(listx[0]))
            y_axis.append(float(listx[1]))
            pass

    plt.plot(x_axis,y_axis)
    plt.xlabel('No. of Processors')
    plt.ylabel('Speedup')
    # plt.ylim(bottom=1.0,top=1.3)
    plt.show()

if __name__ == '__main__':
    main()
