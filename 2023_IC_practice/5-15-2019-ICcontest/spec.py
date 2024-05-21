import random

#// 2019 IC Design Contest Preliminary(107)
# Image Convolution Circuit

#Structure Requirement:
"""
There's 3 different layers in the spec
Convolutional(L0)->
Max-pooling(L1)->
Flatten(L2)

"""
#Input processing
"""
#L0 - zero-padding/Convolutional/ReLU
Input 64*64 Pixels image ->
zero-padding processing ->
2 Convolutional Filters(called Kernal0 ,Kernal1 ,with 3x3)->
Relu processing->
Output 2 64*64 Pixels image.

#L1 - Max pooling
Inputs 2 64*64 Pixels image->
max-pooling processing(2x2,stride = 2) ->
output 2 32*32 Pixels image

#L2 - Flatten
Inputs 2 32*32 Pixel images ->
Output 1 32*32*2 Pixel image
"""


#Structure required:
## test fixture
"""
L0_MEM 0/1 , L1_MEM 0/1 , L2_MEM
input [12:0] ladd
input busy
input [3:0] csel
input crd
input caddr_d
input cwr
input cdata_wr
input caddr_w

output cdata_rd
output [20:0] idata
output clk
output rst
"""
## CONV.block
"""
L0 - zero-padding/Convolutional/ReLU
L1 - Max- pooling
L2 - Flatten
output [12:0] ladd
output busy
output [3:0] csel
output crd
output caddr_d
output cwr
output cdata_wr
output caddr_w

input cdata_rd
input [20:0] idata
input clk
input rst
"""

#I/O signals.
"""
input [1:0]      clk        // posedge trigger      H:In/Out
input [1:0]      rst        // a-asynchronous rst   H:
input [1:0]      ready      // Image in,            H:Ready -> Conv sending address to testfixture
input [20:0]     idata      // 4 bits MSB + 16 bits (Floating)LSB, Input pixels color signal. 
input [20:0]     cdata_rd   // 4 bits MSB + 16 bits (Floating)LSB, Memory Read signal, testure transfer memory signal to CONV circuit. 


output [1:0]    busy        // H: CONV ready signal  L: Every processing done.                    H:CONV ready signal, L: Output End->testfixture
output [12:0]   iaddr       // input pixel address, which pixel address.output [1:0]    
output [1:0]    crd         // Memory Read signal, If (crd = high & clk = posedge){memory = read}, testfeature put caddr_rd address to cdata-rd.
output [12:0]   caddr_rd    // Memory address Read signal, looking for the address in memory. 
output [1:0]    cwr         // Memory Write signal, If(cwr = high & clk = posedge)
output [20:0]   cdata_wr    // Memory Write_out signal, signed 4 bits MSB + 16 bits (float)LSB. All layers result output to testfixture.
output [12:0]   caddr_wr    // Memory address Write_in signal, All layers result output to testfixture. 
output [3:0]    csel        // hotfix code:　3'b000 : No select, 
"
3'b001: Write/Read L0 and process Convolutional, 
3'b010: Write/Read L0, proceed Convolutional. 
3'b011 Write/Read Layer 1, Kernal 0 convolutional then max-pooling. 
3'b100: Write/Read Layer 1, Kernal 1 convolutional then max-pooling
3'b101: Write/Read Layer 2, Flatten the result
"

"""



# Module CONV
"""
module CONV(
input           clk,
input           reset,
input           ready,
input [19:0]    idata,
input [19:0]    cdata_rd,

output          busy,
output [11:0]   iaddr,
output          cwr,
output [11:0]   caddr_wr
output [19:0]   cdata_wr,
output          crd,
output [11:0]   caddr_rd,
output          csel     
);
"""



#Zero-padding
def zero_padding(Imatrix,matrix_0s,rows,cols,padding_size):
    print("ZP Input",rows,"*",cols,"Matrix sample picture")
    for i in range(rows):
        for j in range(cols):
            matrix_0s[i+padding_size][j+padding_size] = Imatrix[i][j]

    
    return matrix_0s
                       
#Convolution
def conv(Imatrix,rows,cols,Maskmatrix,Mrows,Mcols,padding_size):
    print("CV Input",rows,"*",cols,"Matrix sample picture")
    print("CV Input",Mrows,"*",Mcols,"Matrix Mask")
    value_matrix = [[0 for _ in range(rows)] for _ in range(cols)]
    Mid_sum = 0
    for i in range (rows):
        for j in range(cols):
            for z in range(Mrows):
                for c in range(Mcols):
                    M1 = (Imatrix[z+i][c+j])
                    M2 = (Maskmatrix[z][c])
                    Mid_sum = Mid_sum + M1*M2
            
            value_matrix[i][j] = Mid_sum
            Mid_sum = 0 
    
    return value_matrix
## Conv_bias
def bias(Imatrix,rows,cols,bias0):
    for i in range(rows):
        for j in range(cols):
            Imatrix[i][j] = Imatrix[i][j] - bias0
        return Imatrix
#ReLU
def ReLU(Imatrix,rows,cols):
    for i in range(rows):
        for j in range(cols):
            if Imatrix[i][j] <= 0:
                Imatrix[i][j] = 0
            else:
                Imatrix[i][j] = Imatrix[i][j]
    return Imatrix
#Max-Pooling
MProws = 2
MPcols = 2
def Max_pooling(Imatrix,rows,cols,MProws,MPcols):
    max_value = 0
    MPmatrix =[[0 for _ in range(rows)] for _ in range(cols)]
    for i in range(rows):
        for j in range(cols):
            for z in range(MProws):
                for k in range(MPcols): #Max value searching
                    max_value = Imatrix[i][j]
                    if Imatrix[i][j]> max_value:
                        max_value = Imatrix[i][j]
                    else:
                        Imatrix[i][j] = Imatrix[i][j]
            MPmatrix[i][j] = max_value    
            max_value = 0
    return MPmatrix
                    
#Flatten
def Flatten(Imatrix1,Imatrix2,rows1,cols1,rows2,cols2):
    # Create a list to hold the flattened and interleaved values
    array_out = [0] * (rows1 * cols1 + rows2 * cols2)
    cnt1 = 0
    cnt2 = 0
    # Store the first matrix values in the odd indices of array_out
    for i in range(rows1):
        for j in range(cols1):
            array_out[2 * cnt1] = Imatrix1[i][j]
            cnt1 += 1

    # Store the second matrix values in the even indices of array_out
    for z in range(rows2):
        for k in range(cols2):
            array_out[2 * cnt2 + 1] = Imatrix2[z][k]
            cnt2 += 1
    return array_out


#main function calling:
##Declaration
###Matrix creating
rows = 64
cols = 64
matrix = []
### Populate a Testing matrix with random values of 0 ~ 128
for i in range(rows):
    row = []
    for j in range(cols):
        value = random.randint(0,128)  # Generate a random value of either 0 or 1
        row.append(value)
    matrix.append(row)



### Initialize a matrix filled with 0s for padding
    padding_size = 1
    rows0s = rows + padding_size*2
    cols0s = cols + padding_size*2
    matrix_0s = [[0] * cols0s for _ in range(rows0s)]

### Initialize a Testing matrix filled with 1s for padding
    matrix_1s = [[1] * rows for _ in range(cols)]

### Mask intialize
    Mcols = 3
    Mrows = 3
### Initialize two kernal of matrices.
Maskmatrix0 = [
    [0.658674, 0.573572, 0.42681],
    [0.0625617, -0.439696, -0.569037],
    [-0.34829, -0.217964, -0.327755]
]
Maskmatrix1 = [
    [-0.143247,0.162391,-0.212595],
    [0.31637,0.184082,0.125697],
    [0.23376,-0.17419,0.368789]
]
print("IMatrix \n",matrix_1s)
print("Maskmatrix0 \n",Maskmatrix0)
print("Maskmatrix1 \n",Maskmatrix1)
### bias for convolution
biask0 =  0.07446326
biask1 = -0.55241907  



###Functions###
Matrix_Input = []
Matrix_Input = matrix_1s
Mask_Input = []
Mask_Input1 = Maskmatrix0
Mask_Input2 = Maskmatrix1
print("Matrix Input:\n",Matrix_Input)
Matrix_Input = zero_padding(Matrix_Input,matrix_0s,rows,cols,padding_size)
print("Zero padding:\n",Matrix_Input)


K0Matrix = conv(Matrix_Input,rows,cols,Maskmatrix0,Mrows,Mcols,padding_size)
print("Kernal0 Convolution:\n",K0Matrix)

K1Matrix = conv(Matrix_Input,rows,cols,Maskmatrix1,Mrows,Mcols,padding_size)
print("Kernal1 Convolution:\n",K1Matrix)

K0Matrix = bias(K0Matrix,rows,cols,biask0)
print("Kernal0 BIAS:\n",K0Matrix)

K1Matrix = bias(K1Matrix,rows,cols,biask1)
print("Kernal1 BIAS:\n",K1Matrix)

K0relu = ReLU(K0Matrix,rows,cols)
print("Kernal0 Relu:\n",K0relu)

K1relu = ReLU(K1Matrix,rows,cols)
print("Kernal1 Relu:\n",K1relu)

K0maxpooling = Max_pooling(K0relu,rows,cols,MProws,MPcols)
print("Kernal0 maxpooling:\n",K0maxpooling)

K1maxpooling = Max_pooling(K1relu,rows,cols,MProws,MPcols)
print("Kernal1 maxpooling:\n",K1maxpooling)


Flatten_result = Flatten(K1maxpooling,K0maxpooling,rows,cols,rows,cols)
print("Flatten result \n",Flatten_result)