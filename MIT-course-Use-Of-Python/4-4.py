#Mit courses: Python review, list_test1,Tuples.
#Indicates the list_test1 of appending and extending.
print("List testing 1-append,extend")
list_test1 = [2,1,3,6]
print("Original list_test1 = ",list_test1)
list_test1.append(3)
list_test1.extend([7,0])
print("append 3,extend [7,0] list_test1 = ",list_test1)


#List testing - 2
print("List testing 2-remove,add")
list_test1 = [2,1,3,6,3,7,0]
list_test1.remove(2)
print(list_test1)
list_test1.remove(3)
print(list_test1)
del(list_test1[1])
print(list_test1)
list_test1.pop()
print(list_test1)

#Mutate: Change the original variable

print("##Mutated/Immutated testing - List(value)##")
L = [9,6,0,3]
print(L)
L2= sorted(L) #Non mutated
print(L2)
L.sort #MUTATED
L.reverse #Un-MUTATING
print(L)

#string mutate testing
print("##Mutated/Immutated testing - List(string)##")
L_string = ["Red","Blue","Green"]
Non_mutated = L_string #It'll be synchronizing with L_string list.
Not_mutated2 = L_string[:] #It'll not be synchronizing with L_string list but copy.
print(L_string)
L_string.append("White")
print(L_string)
L_string.extend("Yellow")
print(L_string)  
print(Non_mutated)
print(Not_mutated2)

#Iteration warning:
print("##Iteration Testing - Mutating problem##")
L1 = [1,2,3,4]
L2 = [1,2,5,6]

def loop(L1,L2):
    for e in L1:
        if e in L2:
            L1.remove(e)


loop(L1,L2)
print(L1)
print("Why L1 not only 3,4 but 2,3,4?")
#Why L1 not only 3,4 but 2,3,4? because the iteration counter use the "internal counter" and mutated command had changed the length!


#Tuples List
#difference between "tuples", "dictionary", "class", "list"
print("##Tuple testing##")
y =1
x=2 
print("Original value of y =",y)
print("Original value of x =",x)
(x,y) = (y,x)
print("Tuple y = ",y)
print("Tuple x = ",x)

print("original (x,y) = (",+x,",",+y,")")
def tuple_cal(x,y):
    q = x/y
    r = x%y
    return(q,r)
print("(x,y) = ",tuple_cal(x,y))

#Towers game
def printMove(fr,to):
    print('move from'+str(fr) +'to'+str(to))
def Towers(n,fr,to,spare):
    if n==1:
        printMove(fr,to)
    else:
        Towers(n-1,fr,spare,to)
        Towers(1,fr,to,spare)
        Towers(n-1,spare,to,fr)
#Fibonacchi series
def fib(x):
    if x == 0 or x == 1:
        return 1
    else:
        return fib(x-1) + fib(x-2)

#object orientated


#Iteration vs recursion of 
def factorial_iter(n):
    prod = 1
    for i in range(1,n+1):
        prod += 1
    return prod

def factorial(n):
    if n == 1:
        return 1
    else:
        return n*factorial(n-1)












