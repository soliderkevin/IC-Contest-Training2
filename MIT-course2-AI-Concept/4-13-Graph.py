
"""3.Graph theoretic Models lecture, Introduction to graph efficiency. (BRIDGES OF KOINGSEBERG:possible to walk through seven bridges in one routine?,Ans:no)"""

""" The graph is about the shortest system->graph series about navigation"""
def childrenof(self,node):
    return self.edges[node]

def childrenof(self,node):
    return self.edges[node]
#question:Is there the way to walk through all of the bridges in one time?
#Answer:No

"""Assume only thing stored in now just a name:"""

class Node(object):
    def __init__(self,name):
        """assume name is a string"""
        self.name = name
    def getName(self):
        return self.name
    def __str__(self):
        return self.name  
class Edge(object):
    def __init__(self,src,dest):
        """Assumes src and dest are nodes"""
        self.src = src
        def getSource(self):
            return self.src
        def getDestination(self):
            return self.dest
        def __str__(self):
            return self.src.getName() + '->' +self.dest.getName()

"""row is all the sources, column is all the destination"""
# class Disgraph():
#      """first check its not in the dictionary"""
#      def __init__(self):
#          self.edges = {}

#     def addNode(self,node):
#         if node in self.edges
#         return nonlocal
#     raise NameError(name)

"""Class depth first search(DFS)"""
def DFS(graph,start,end,path,shortest,toPrint=False):
    path = path+[start]
    if toPrint:
        print('Current DFS path',printPath(path))
    if start == end:
        return path
    for node in graph.children0f(start):
        if node not in path:
            if shortest == None or len(path) <len(shortest):
                newPath = DFS(graph,node,end,path,shortest,toPrint)
                if newPath != None:
                    shortest = newPath
        elif toPrint:
            print('Already visited',node)
    return shortest

def shortestPath(graph,start,end,toPrint = False):
    return DFS(graph,start,end,[],None,toPrint)
            

"""Breadth-first Search"""
def BFS(graph,start,end,toPrint= False):
    initPath = [start]
    pathQueue = [initPath]
    while len(pathQueue) !=0:
        #get and remove oldest element in pathQUEUE
        tmpPath = pathQueue.pop(0)
        if toPrint:
            print('Current BFS path:',printPath(tmpPath))
        lastNode = tmpPath[-1]
        if lastNode == end:
            return tmpPath
        for nextNode in graph.children0f(lastNode):
            if nextNode not in tmpPath:
                newPath = tmpPath+[nextNode]
                pathQueue.append(newPath)
    return None

