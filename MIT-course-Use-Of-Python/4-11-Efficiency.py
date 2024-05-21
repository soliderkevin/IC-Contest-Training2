# long comment is """ (text) """, line comment is #(text)


#LEC 10
#Algorithm, why care?
#It's the best effective one
#goal: to evalutate different algorithms.

#running time varies between algorithms, 
#NOT running BETWEEN implementations!
#NOT running time varies between computers.
#running time is not predictable based on small inputs


#Goal: to evaluate different algorithms
#count depends on algoirhtm
#Not count depends on implementations
#count independent of computers
#Not no clear definition of which operations to count
#count vavr
#counting operations:
#count varies for different inputs and can come up with a relationship between inputs and the count.

def c_to_f(c):
    return c*9.0/5+32

def mysum(x):
    for i in range(x+1):
        total += i
    return total
#Different inputs change how the program runs
#A function that searches for an element in a list
def search_for_emt(L,e):
    for i in L:
        if i == e:
            return True
    return False
#best case minimum running time over all possible inputs.
#average case average running time over all possible inputs of a given size, len(L)
#worst case maximum running time over all possible inputs of given size, len(L)

#Big O notation:
def fact_iter(n):
    ANSWER = 1
    while n>1:
        ANSWER *= n
        n-= 1
    return ANSWER
#worst case asymptotic complexity O(n):
#ignore additive constants.
#ignore multiplicative constants.

#simplification examples:
# n^2 + 2*n + 2 => O(n^2)
# n^2 + 10000*n + 3^1000 => O(n^2)
# log(n) + n + 4 =>O(n)
# 0.0001*n*log(n) +300*n => O(n*logn)
# 2*n^30 + 3^n => O(3^n)
#Exponential always much worse

#Analyzing programs and their complexitiy.
#Order Growth examples
# combine complexity classes
# Law of addition for O():
#  used with sequential statements
#     O(f(n)) + O(g(n)) is O(f(n)+g(n))
# for example
#     print('a')
#     for j in range(n*n):
#         print('b') 
#     is O(n) + O(n*n^2) = > O(n+n^2) => O(n^2)


#Linear search example, must look through all elements to decide:
def linear_search(L,e):
    found = False
    for i in range(len(L)):
        if e == L[i]:
            found = True
    return found


#Indirection
def search(L,e):
    for i in range(len(L)):
        if L[i]== e:
            return True 
        if L[i]> e:
            return False
    return False

def addDigits(s):
    val = 0
    for c in s:
        val += int(c)
    return val

def fact_iter(n):
    prod = 1
    for i in range(1,n+1):
        prod *= i
    return prod

#Quadratic complexity
#Each iteration will execute inner loop up to len(L2) times, with constant number of operations.
def isSubset(L1,L2):
    for e1 in L1:
        matched = False
        for e2 in L2:
            if e1 == e2:
                matched = True
                break
        if not matched:
            return False
    return True
#First nest loop takes len(L1)*len(L2) so its quadratic.
#Second loop takes at most len(L1) steps
#Determining if element in list might take len(L1) steps
#Quadratic behavior
def intersect(L1,L2):
    tmp = []
    for e1 in L1:
        for e2 in L2:
            if e1 == e2:
                tmp.append(e1)
    res = []
    for e in tmp:
        if not(e in res):
            res.append(e)
    return res



#LEC 11
"""
Recap ideas
。O(1) denotes constant running time
。O(logn) donates logratimic running time
。O(n) denots linear running time
。O(n^c)denotes polynomial running time(c is a constant)
。O(c^n)denotes exponential running time(c is a constant being raised to a power based on size of input)
"""
#Bisection search
""" 
1. pick an index, i, that divides list in half.
2. ask if L[i] == e
3. if not,ask if L[i] is larger or smaller than e
4. depending on answer, search left or right half of L for e
A new version of a divide-and-conquer algorithm
。break into smaller version of problem(smaller list), plus some simple operations.
。answer to smaller version is answer to original problem.
"""
#Bisection search
def bisect_search1(L,e):
    #constant O(1)
    if L == []:
        return False
    #constant O(1)
    elif len(L) == 1:
        return L[0] == e
    else:
        #constant O(1)
        half = len(L)//2
        if L[half]> e:
        #Not constant
            return bisect_search1(L[:half],e)
        else: 
            return bisect_search1(L[half:],e)
def bisect_search2(L,e):
    def bisect_search_helper(L,e,low,high):
        if high == low:
            return L[low] == e
        mid = (low + high)//2
        if L[mid] == e:
            return True
        elif L[mid]>e:
            if low == mid:
                return False
            else:
                return bisect_search_helper(L,e,low,mid-1)
        else:
            return bisect_search_helper(L,e,mid+1,high)
    if len(L) == 0:
        return False
    else:
        return bisect_search_helper(L,e,0,len(L)-1)
#Logarithmic Complexity
def intToStr(i):
    digits = '0123456789'
    if i == 0:
        return '0'
    result = ''
    while i > 0:
        result = digits[i%10] + result
        i = i//10
    return result

def fact_iter(n):
    prod = 1
    for i in range (1,n+1):
        prod *= i
    return prod

def fact_recur(n):
    """assume n >= 0 """
    if n<= 1:
        return 1
    else:
        return n*fact_recur(n-1)

#Log-Linear Complexity.

#Polynomial Complexity.
"""most common polynomial are quad"""

"""Complexity of towers of Hanoi"""
"""tn = 2tn-1 + 1, so order growth to 2^n"""

#Exponential Complexity
"""Power Set-Concept"""
#Q.How big is this genSubsets complexity?
def genSubsets(L):#Constant<->
    res = []
    if len(L) == 0:
        return [[]]#Constant
    smaller = genSubsets(L[:-1])#Call itself n times
    extra = L[-1:]#Constant <->
    new =[]#Constant
    for small in smaller: #Depends on big and smaller is
        new.append(small+extra)
        return smaller+new
    
#relationship : t_n = t_(n-1) + 2^(n-1) + c => 1 + 2^n + n*c
#Thus computing power set is O(2^n)

#Complexit of iterative fibonacci
def fib_iter(n):
    if n == 0: #Constant O(1)<->
        return 0
    elif n==1:
        return 1 #Constant O(1)
    else:
        fib_i=0 #Constant O(1)<->
        fib_ii=1#Constant O(1)
        for i in range(n-1):#Constant O(n)<->
            tmp = fib_i
            fib_i = fib_ii
            fib_ii = tmp+fib_ii#Constant O(n)
        return fib_ii
#Best case of iterative fib is O(1); Worst case is O(1)+O(n)+O(1)-> O(n)
def fib_recur(n):
    """assumes n an int>= 0"""
    if n==0:
        return 0
    elif n == 1:
        return 1
    else:
        return fib_recur(n-1) + fib_recur(n-2)

#Complexity of common python functions
"""
。Lists:n is len(L)
。Dictionaries: n is len(d)
。worst case
。average case
"""
#Dictinary use clever indexing scheme called "hash", but worst case is gonna be linear
#For dictionary getting more power, more flexiability but comes as a cost.


#Lec 12 - Searching and sorting algorithms
#Searching algorithms:
"""
linear search:
。brute force search(aka british museum algorithm)
。list does not have to be sorted.
bisection search:
。list MUST be sorted b give correct answer.
。saw two different implementations of the algorithm.
"""

#Complexity of BOGO sort
def bogo_sort(L):
    while not is_sorted(L):
        random.shuffle(L)
#best case O(n) where n is len(l)
#worst case O(?) is unbounded

#Complexity of bubble sort
def bubble_sort(L):
    swap = False
    while not swap:
        swap = True
        for j in range(1,len(L)):
            if L[j-1]>L[j]:
                swap = False
                temp = L[j]
                L[j] = L[j-1]
                L[j-1] = temp
#inner for loop is for doing the comparisons
#outer while loop is for doing multiple passes until no more swaps.

#Selection sort 
#Take one and looking for the worst to move.
def selection_sort(L):
    suffixSt = 0
    while suffixSt != len(L):
        for i in range(suffixSt,len(L)):
            if L[i] < L[suffixSt]:
                L[suffixSt], L[i] = L[i], L[suffixSt]
        suffixSt += 1

#Merge sort
#First ask everyone split into group of 2.
#Second, Pick the highest right side.
#Third, Merging 2 groups together
#Fourth, Comparing 2 people in the group together
#Fifth, repeating step Fourth until all sorted
def merge(left,right):
    result = []
    i,j = 0,0
    while i< len(left) and j<len(right):
        if left[i]<right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j+=1
    while(i<len(left)):
        result.append(left[i])
        i+=1
    while(j<len(right)):
        result.append(right[j])
        j+=1
    return result

def merge_sort(L):
    if len(L) < 2:
        return L[:]
    else:
        middle = len(L)//2
        left = merge_sort(L[:middle])
        right = merge_sort(L[middle:])
        return merge(left,right)

    