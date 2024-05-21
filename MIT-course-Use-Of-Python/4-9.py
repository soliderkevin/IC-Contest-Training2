#object-orientated

#CLASS DEFINITION
#Creating and using your own types with classes.
#make a distinction between creating a class and using an instance of the class
#creating the class invloves. 1.defining the class name, 2. defininig class attributes
#Using the class involves, 1. creating new instances of objects. 2. doing operations ont he instances.
#Examples: coordinate object
#spec: define point in x,y point.
#class definition(class) + name/type(coordinate) + class parent(obejct)
class coordinate(object):
    #define attributes here
#What are attributes?
# data and procedures that "belong" to the class.
#Can be looked as the function and the function "that'll only work" on this particular object.
#Use special method called "__init__" the initi with double underscore to initialzie some data attributes
class coordinate(object):
    def _init__(self,x,y):
        self.x = x
        self.y = y
#self: parameter to refer to an instance of the class/
#Q. How to make sure x,y int or float?
#A.We can put the certain statement inside the definition of unit to force it to be int.
#self."x" = "x" don't have to be same name!

c = coordinate(3,4)
origin = coordinate(0,0)
print(c.x) #will print 3
print(origin.x) # will print 0


#define a method for the coordinate class
class coordinate(object):
    def _init__(self,x,y):
        self.x = x
        self.y = y
    def distance(self,other):
        x_diff_sq = (self.x-other.x)**2
        y_diff_sq = (self.y-other.y)**2
        return (x_diff_sq + y_diff_sq)**0.5
    
   
#using the class conventional way
def distance(self,other):
    c= Coordinate(3,4)
    zero = Coordinate(0,0)
    print(c.distance(zero))

#equivalent to
c = Coordinate(3,4)
zero = Coordinate(0,0)
print(Coordinate.distance(c,zero))

#default argument
a =  Animal(3)
a.set_name()
print(a.get_name())
a = Animal(3)
a.set_name("fluffy")
print(a.get_name)

class cat(animal):
    def speak(self):
        print("meow")
    def __str__(self):
        return "cat:"+str(self.name)+":"+str(self.age)



#/// CLASSES AND INHERITANCE
#grouping same objects according to attributes:

#define a class:
class Animal(object):
    def _init__(self,age):
        self.age = age
        self.name = None
    


#class : getter and setter methods
#Purpose of Getter and setter is to "Prevent bugs"
#getters and setters should be used outside of class to access data attributes
class Animal(object):   
        def _init__(self, age):
            self.age = age
            self.name = None
        def get_age(self):
            return self.age
        def get_name(self):
            return self.name
        def set_age(self,newage):
            self.age = newage
        def set_name(self, newname=""):
            self.name = newname
        def __str__(self):
            return "animal:"+str(self.name)+":"+str(self.age)
    
    
#an instance and dot notation recap
a= Animal(3)
a.age #not recommended to use this type, use the below "a.get_age()" one is better.
a.get_age() # and we can access the object through variable "a".


#Not good styles in PYTHON languages(Not protected)
#First to access attribute outside the data of class
print(a.age)
#Second allows you to "write to data from outside class definition"
a.age = 'infinite'
#Third allows you to create data attributes for an instances from outside class definition
a.size = 'tiny'

#Default arguments
def set_name(self, newname=""):
     self.name = newname
#default argument used here
a = Animal(3)
a.set_name()
print(a.get_name())#because newname is default argument, so it doesn't need to be anyhting unless we want to rename it.
#argument passed is used here
a = Animal(3)
a.set_name("fluffy")
print(a.get_name())



#inheritance: parent class
class Animal(object):
    def __init__(self,age):
        self.age = age
        self.name = None
    def get_age(self):
        return self.age
    def get_name(self):
        return self.name
    def set_age(self,newage):
        self.age = newage
    def set_name(self,newname = ""):
        self.name = newname
    def __str__(self):
        return "animal:"+str(self.name)+":"+str(self.age)
    
#inheritance : subclass, if subclass doesn't have, look in parent class

class Person(Animal):
    def __init__(self,name,age):
        Animal.__init__(self,age)
        self.set_name(name)
        self.friends =[]
    def get_friends(self):
        return self.friends
    def add_friend(self,fname):
        if fname not in self.friends:
            self.friends.append(fname)
    def speak(self):
        print("hello")
    def age_diff(self,other):
        diff = self.age - other.age
        print(abs(diff), "year differnece")
    def __str__(self):
        return "person:"+str(self.name)+":"+str(self.age)