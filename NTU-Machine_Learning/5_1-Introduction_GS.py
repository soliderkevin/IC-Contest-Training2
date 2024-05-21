#Regression The function outputs a scalar.

def Regression(temperature, Concentration, PM):
    Predict = temperature + Concentration + PM
    return Predict


#Classification:Given options(classes), the function outputs the correct one.


#Alpha go is a classification problem. such as the chess with 19*19 option.

#Strctured Learning: create something with structure(image,document)

#Q.How to find a function?
#A.With 3 steps, function with unknown -> define loss from training data -> Optimization
#1.Function with unknown Parameters.
#The prediction formula called "Model"
""" w:weight
    b:bias
"""
def Prediction_result(b, w, x_1):
    Prediction_result = b + w*x_1
    return Prediction_result

#2.Define Loss from training Data
"""
Loss is a function of parameters. L(b,w)
Loss:how good a set of values is.
Q.How to define how good it is?
e_1 = |y - y_bar|: The error constant.
e_2 = |y- y_bar| and so on...
Loss defined as "(1/n)Sigma(e_n)".
MAE: e = |y- y_bar|
MSE: e = (y-y_bar)^2
*If y and y_bar are both "Probability Distribution", we called it "Cross-Entrophy"*
"""
def loss_function_MAE(y,y_bar,case):
    if case == 'Probability_Distribution':
        return 'Cross_Entrophy'
    elif case == 'MAE':
        e = abs(y- y_bar)
        return e
    elif case == 'MSE':
        e = abs(y-y_bar)^2
        return e
    else:
        case == 'Unknown types'
        print(case)

from sympy import symbols #Have to reinstall library when starting up
#3 Optimization
#Goal: Find a set of w* and b* making minimum L
#Q.How to do it?
#A. Gradient Descent.
"""Gradient Descent
***Terminal: python -m venv: (directory)***
(   INDEX_Gradient_Descent:
    from sympy import symbols, diff
    L_f: Loss function
    w_s, b_s: randomly picked value on L_f.
    n: Learning rate.
    S1-Randomly Pick an initial value w^0.
    S2- Calculate partial derivative of Loss function(L_f).
    S3- Find w_s and b_s when L_f = 0
    Q.But problem is that we might only find "local minima" not "global minima"?
    A.It's the "Fake issue", The real issue in gradient descent not "local-global" problem!
    
    )
"""
#Have to import partial libary!
def partial(L_f):
    b_s = int(input('Enter the random point b'))
    w_s = int(input('Enter the random point w'))
    if b_s == 0:
        w_s = L_f.diff(w_s)
        return w_s
    elif w_s == 0:
        b_s = L_f.diff(b_s)
        return b_s
    else:
        w_s = L_f.diff(w_s)
        b_s = L_f.diff(b_s)
        return w_s,b_s
#Finding minimum L_f(Linear model)
def Opt_GS(L_f,w_s,b_s,n):
    while(L_f != 0):
        if L_f > 0:
            w_s = w_s-n*partial(w_s)
        elif L_f <0:
            b_s = b_s-n*partial(b_s)
        else:
            return w_s,b_s,n
    print('Optimization point w='+w_s+'b='+b_s+'n=',n)
# y = sigma_n(w*x)
def sigma_n(w,x,n):
    total = n*w*x
    return total
def training_model(b,w,x):
    y = b+ sigma_n(w,x)
    return y

import math
#Lec 2-
#How to represent this function:
"""
Red curve = constant + sum of a set of hard sigmoids(looks like steep function).
Red curve = constnat + c*sigmoid(b+w*x_1) 
sigmoid: The S-Shape type of function.
We can use sigmoids to approximate Hard sigmoids.
Therefore,we adapt w,x_1,c to approximate sigmoids.
"""
def red_curve(c,b,w,x_1):
    y = b + c*(1/(1+math.exp(-(b+w*x_1))))
    return y

#Add in different sigmoids inside 
#w_i_j:weight for x_j for i-th sigmoids.


#Data calculation(Using Vector calculation)
#r = b+W*x
#a = sigmoid(r)
# y = b + c_transpos  e * a
#==> y = b+ c_tranpose*sigmoid(b+W*x)
#
### 
