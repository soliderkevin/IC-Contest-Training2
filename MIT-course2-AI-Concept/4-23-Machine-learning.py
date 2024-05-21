#======Lec 11 Machine Learning ======
#Classicification method
"""K-Nearest Neighbor and K-Means method"""
#Traditional Programming and Machine Learning difference
"""Data + Output -> Program, called Machine Learning
   Data + Program-> Output, Traditional Programming
   As we can see, we're able to make it a cycle, when (TL)Output feeding back to (ML)Input 
   """
#Q.How are things learned?
"""Accumation of individual facts.
。Memorization:(Declarative)
Limited by
1.Time to observe facts.
2.Memory to store facts.

。Generalization(Imperative)
Deduce new facts from old one,
1.Assume the past predicts future.
Eseentially a predictive activity.
"""
#The progress of machine learning

"""Observe(Trainning Data)->Infer->Use infer and make prediction(Test data) -> Variations on paradigm(1.Supervised,2.Unsupervised)"""
"""pg:animal feature sorting:reptile
Q.Difference between Fish and Snake?(both no legs)
A. So Fish is Pos Negative data, and snake is Pos Positive data.
"""

#Q.How do we value the importance of the difference?
"""A. Miukowski Metric: The Matric to value the difference data,(PP,NN,PN,NP)
To solve the problem such as:Q.Why should I think leg sort is more important than scaling sort on animal?
"""

#Classification Approach
"""
Q.How do we avoid overfitting to data?
Q.How to measure performance?
Q,How are we able to determine the best feature selection?"""

#Confusion matrice applicating on "simple line" and "complex line" on the plot to determine differences.
"""
Q.How do we determine which line(simple line 1,2...,complex line1,2....) is more accurate in certain plot?
A.By using the Confusion matrice, The "Diagonal Values of the matrics(PP,NN)".
pg:[PP NP; PN PP] = [1 2; 3 4], we only have to inspect 1,4 to determine which plot line is better model.

Diagnolizing data can determine which plot is more precisely or not, by using the formula of:
"Accurracy == (PP+NN)/(PP+NN+NP+PN)"ratio to see which one is higher.

"""


#==== Lec 13 Classification ===-
"""Supervised learning
1,Regression: Predict a real number associated with a feature vector.
2.Classification: Predict a "discrete value" associated with a feature vectore

。Using distance matrix for classification
"simplest approach" is probably "nearest neighbor method"
"Remember trainning data"
pg:Alligator closet to chicken " => classfiied alligator is not reptile, It's false(PN).
To avoid this situation, we use "k-nearest method".
"""
#K-nearest method
"""K-nearest method: Taking some numbers of nearest member not just a number.
   Advantage:Only have to consider values.
   Disadvantage: Memory intensive.
"""

#Other Metrics
"""
1.Sensitvity = (True Pos)/(True Pose + False Neg)
2.Specificity = (True Neg)/(True Neg + False Pos),   The oppoiste of Sensitivity
3.Positive Predictive value = (True Pos)/(True Pos+ False Pos)
4.Negative Predictive Value = (True Neg)/(True Neg + False Neg)
"""
#Q.How to build up classifier?
#A.Instead, we have to ask.
#Q.How to test classifier?
"""A.Two methods.
1.Leave one out class(For Small set of data):Take all of n examples and remove one of them. i.e:train n-1, test 1 and so on, do each element and average result.
2.Repeating random samples(For Large set of data):Take 80% of data to train on, then testing on the rest 20%
"""

#K nearest classify code
"""4 arguments:
1.Trainning
2.Test
3.The label
4.K
return
"""
#Sklearn library in Python
"""import "sklearn.linearmodel", sklearn is python library.
Also called "Logistic Regression".
Q.What three methods in classification?
A. 
1.fit(return object of logeistic regression)
2.coef(Return weight of feature)
3.predict_poba(feature vectore)(Return 3 probability of lables.)
"""

#Build models with sklearn_model
"""KNN result(left) vs Logisitc Regression(Right)"""


#====Lec 14- Classification and Stastical Sins ===
"""Logistic regression with ROC(Receiver Operation Charateristic)
Perfect classifer curve shape will be 
1.[Sensitivity(Y-Axis), Specificity(X-Axis)],  at(0,0): all negative, many Neg Positive; at(1,1):All positive, many Pos Negative.

Green line(y = ax+b):Random classifier
Blue line(y = ???): ROC(Reiever Operation Characteristic)
Image explains how much better ROC is with "AUROC".
"""
#Q.What point does AUROC become statistically significant?
"""A. In general, depending on application, many things be more than "0.7"is useful."""


#Q.How to lie with statistic - Darrel Huff
"""If you can't prove what you want to prove, demonstrate something else and pretend they are the same thing"""

#Anscombe's Quartet - Darrel Huff

#Statistic about the data is not the same as the data!

#Garbage in Garbage out
"""Correct statsitical analysis of incorrect data, input incorrect data will only gives out incorrect data"""

#Q.Is the data itself worth analyzing?
"""Survivor Bias tells us that sometimes, the data is missing."""


#======Lec 15======
#Moral:
"""Truncate the y-axis to eliminate preposterous values"""
"""p.g: Flue-time plot, when zoom out we can't see difference, but zoom in it'll change drastically."""

#Cherry picking
"""Only pick two consistent datasets and go into conlcusion,which is pretty inaccurate(LIE Proving)"""

#Moral:
"""Context Matters, percentage change alot, not some meaningless number"""


#p.g Cancer Clusters in different regions.
"""It's the Hypothetical example, the cherry picking hypothetis when agent pointing out the data of two different data sets peak!"""