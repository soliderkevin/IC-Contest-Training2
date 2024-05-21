#Lec 6- Pytorch?
"""Pytorch is the most popular deep learning framework
write fast deep learning code in "Python"(able to run on a gpu or many gpus) 
able to access many pre-built deep learning machine models
whole stack preprocess data,model data, deploy model in your application/cloud
originally designed nad used in-house by facebook/meta source and used by many companies such as tesla, microsft and openAI

https://paperswithcode.com/ - algorithm website code

Colab,keras and TensorFlow - deeplearning machine list.

Pytorch use pg: tesla automatic vehicle, argiculture 


TPU:(Tensor Processing Unit) 
GPU: CUDA(computing platform and application programming interface that allows software to use certain types of graphics processing units)
an approach called GPU(General purpose computing - General Purpose Unit)
"""

"""
Q.What is a  tensor?
A.Any representation of numbers set

"""

"""https://colab.research.google.com/ - Google colab for faster coding
    shortcuts for cloab research.
    Switch to new line - shift+enter 
    Turning code cell into text -Ctrl+ M
    Delete the line - CTRL+M+D 
    you're able to change runtime options here.
"""

#Lec 8 -What's a tensor?
"""
A.Tensor is the multiple sets of Vectors

"""

#Tensor basic statement:
"""
#pg. Float 32 tensor, Tensor basic information
float_32_tensor = torch.tensor([3.0,6.0.9.0],
                dtype = None,   //Data type
                device = None,  //
                require_grad = False)
"""




#Looping in matrices multiplication is faster
"""
---
%%time
value = 0
for i in range(len(tensor)):
  value += tensor[i] * tensor[i]
print(value)
----
is slower than
----
%%time
torch.matmul(tensor,tensor) //"touch.matmul" also can be written as "touch@"
----
because torch.matmul is already implemented inside the command, so there's no need for extra steps implementation.

While loop would take up so much time compare to the new one.
"""


# Tensor shape error , One of the most common error in deep learning is "shape error"
"""Two rules to satisfy in matrix multiplication
1.The inner dimensions must match (a_n , n_b matrices) 

"""
 
"""To fix our tensor shape issues, we can manupluate the shape of our tensors using torch.transpose

A transpose switches the axes of dimension of a given tensor.
use command
"tensor_B """

