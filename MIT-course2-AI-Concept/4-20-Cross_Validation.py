"""First Generating Normally distributed Data with python"""



"""PDF for Normal Distribution"""


"""We need area first to talk about the reliability to the shape of the curve"""

#A Digression
"""SciPy library contains my useful mathematical functions used by scientists and engineers"""
"""scipy.integrate.quad has up to four arguments"""
"""1. a function or method to be integrated.
2. a number representing the lower limit of the integration.
3. a number representing hte upper limit of the integration
4. an optional tuple supplying values for all arugments, except the first, of the function to be integrated.
"""


"""Scipy.integrate.quad returns a tuple
.Approximation to reset
.Estimate of absolute error
"""

#use of "import scipy. integrate"
"""Checking the empircal Rule"""


#Central Limit Theorem
"""
1. The means of the samples in set of smaples will be approximately normally distributed.
2.The normal distribution will have a mean close to the mean of the population
3.The variance of the sample means will be close to the variance of the population divded by the sample size.
pg: Rolling dice 
roll 1 dice -> 2.49...., std = 1.44(standard deviation)
roll 50 dices -> 2.49, std(standard deviation) = 0.204
If we're trying to estimate the mean using samples are sufficiently large, the CLT will let us use imperical rule".
 

"""

#Sampling and standard error


#Probability Sampling
"""Each memeber of the population has a nonzero probability of being included in a sample
Simple random sampling: each member has an equal chance of being chosen"""
"""Drawing random samples.Try 1000 times with 1000 samples
new in code: pylab.axvline: draws a perfect red line
"""

#Error Bars, a digression
"""Graphical representation of the variability of data
way to visualize uncertainty
Sample size gets bigger, the error box gets smaller"""

#Recall Central Limite Therom(CLT)""
"""Standard Error of the Mean:
But we don't know standard deviation of population"
"""
"""Q.What's the best guess to the standard of population if we only have 1 sample to look at?
   A.Shockingly good,If sample size is small off by 14%, when larger the offset went to 2% only """
"""
Q.What good is this?
Q.Is it true of this example?
Q.Suppose we have a different distribution, Would that change the conclusion.
Looking at distributions. Sample SD vs Population SD Offset.
In conclusion, we can see that sample SD and Population SD offset will be smaller when the samples amount are getting bigger.
Q. Why exponential distribution SD vs Population offset is way higher than the other two?
A.It's have to do with a fundamental different in these distribution called "SKEW".
Skew: a measure of the asymmetry of probability distribution.
More skew you have, the more samples you need to get the approximation.
Q. Does size matter?
A. NO

Q. We always want to choose the small sample size and get accurate answer.

To estimate mean from a single sample:
1. Choose sample size based on estimate of skew in population
2. Choose a random sample from the population
3. Compute the mean and standard deviation of that sample
4. Use the standard deviation of that sample to estimate the SE.


Once we've done that we use the estimated standard error to generate "Confidence intervals" around the sample mean.
We choose independent samples, if we don't choose independent samples, it'll go wrong.
This lesson is mostly about "standard error and trying to get the Confidence interval".
"""



# Lec 9===Experimental Data===

#Lesat squares objective function as example

"""

LSOF diveded by number of hte observations = Vairance.
Variance taking square root = std(standard deviation).
It tells you sth about how badly things are dispersed, how much variation there is in this measurement
"""
"""
Linear regression gives a very easy way to find lowest point on that surface,
It's called linear regression because of how you do that solution.
In pylab there's a built-in function called 
"""
#Polyfit
"""
"pylab.polyfit(observedX,observedY,n)
n = 1 - bestline
n = 2 - best parabola
y = ax+b
y = ax^2 + bx + c
"""

#Comparing mean squared Error
"""
Testing Goodness of fits
 
"""



#Lec 10===Experimental Data=== Continue
#Modol and experimental.
"""pg. Find the best curve:
Using linear regression idea, When using First-Order Model to fit, realizing its not good enough, why not using Second-Order one?

Q.How do we get a tighter fit?
A. By using R^2(Coefficient of determination), giving us decent measure of the tightness of the models fit.
R^2 = 1- [sum of (yi-pi)^2]/[sum of (yi - u)^2]

yi = sample data
pi = predicted data
u = means of measured value
[sum of (yi-pi)^2] called "Error in estimates"
[sum of (yi - u)^2] called "Variability in measured data"
pg: Mystery data generating with pylab
"""
#Cross Validation/Validation
"""Method to see how well they work and how good aat predicting data from which I did the trainning.
    Cross Validate:Generate models using "one dataset, and test them on another dataset"
    After Cross Validate, try selecting model with lowest error rate.
pg: sometimes First-Order model is better than n-th model in test.
"""

#Leave-One-Out Cross Validation
"""
If data size is large, use method called "k-fold".
"""
#Repeating random sampling
"""
Trying to repeat sampling on finding lowest R-square value among all, letting us to select simplest model accounts of data.
Complexity can either be based on theory, or by doing cross-validation to describe which one is the simplest model.
"""