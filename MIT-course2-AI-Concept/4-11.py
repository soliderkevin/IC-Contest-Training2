#1 Intoduction, Optimization Problems.
#Greedy algorithm problem: You'll stuck at local maximum value point, Not global maximum value point!

# #2. Optimzaiton Problems.
# Pros and Cons of greedy
# Pros: Really easy to implement and is really fast
# Cons: Not even the answer we want, might only be approximation

#Brute force algorithm
# 1.Enumerate all possible combinations of items.
# 2. Remove all of the combinations whose total units exceeds that allowed weight.
# 3.From the remaining combinations choose any one whose value is the largest.

#Search Tree
#Take, Don't take, Left-First, Depth-First enumeration
#body of maxVal(without comments)
def testmaxVal(toConsider,avail):
    """Assumes toConsider a list of items, avail a weight"""

    if toConsider == [] or avail ==0:
        result = (0,())
    elif toConsider[0].getUnits()>avail:
        result = testmaxVal(toConsider[1:],avail)
    else:
        nextItem = toConsider[0]
        withVal, WithToTake = maxVal(toCosnider[1:],avail-nextItem.getUnits())
        withVal += nextItem.getValue()
        withoutVal,WithoutTake = maxVal(toConsider[1:],avail)
        if withVal >withoutVal:
            resutl = (withVal,WithToTake+(nextItem,))
        else:
            result = (withoutVal,WithToTake)
    return result

#Search tree worked great


#Code to Try Larger examples:
import random #python library used a lot.
def buildLargeMenu(numItems,maxVal,maxCost):
    items = []
    for i in range(numItems):
        items.append(Food(str(i), random.randint(1,maxVal),random.randint(1,maxCost)))
        return items
for numItems in (5,10,15,20,25,30,35,40,45,50,55,60):
    items = buildLargeMenu(numItems,90,250)
    testMaxVal(items,750,False)

#Dyanmic programming?Didn't mean anything?
#Basic idea: Recursive Fibonacchi number
def fib(n):
    if n== 0 or n ==1:
        return 1
    else:
        return fib(n-1) + fib(n-2)
fib(120)
#Why is it taking so long for fibonacchi to compute these results?
#Inspect the "call tree for recursive fibonnaci"
"""We can see that some fib(4,5,6) are used over and over again in the whole tree"""

#Advanced idea: Fast Fibonnaci with dictionary.
def fastFib(n,memo = {}): #memo is dictionary
    if n == 0 or n == 1:
        return 1
    try:
        return memo[n]
    except KeyError:
        result = fastFib(n-1, memo) + fastFib(n-2,memo)
        memo[n] = result
        return result
#This time it'll run faster than the recursive one.

<search tree.