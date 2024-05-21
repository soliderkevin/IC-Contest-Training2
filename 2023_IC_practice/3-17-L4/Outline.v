//1. Prime number module, testbench and pattern.
//2. Decoder
/*One-hot representation, binary tranform to one-hot is common design.
Onehot is similar to shift left 1.
...000(binary)->...0001(onehot)
...001->...0010
...010->...0100
... and so on
*/
// 3. Encoder
/* From original code transfering into different bytes and save them.

//.4.Multiplexor
/* counter_sel the particular file and let it pass through, the rest get blocked.
There's two type of multiplexor.
1.AND-OR Structure
2.Tri-state structure.(Using tri gate)
Q. What's the different between AND-OR and Tri-state Structure implementations?
A.  Both can be multiplexor, 
    Area: AND-OR > Tri-State, but mostly using AND-OR structure, Why?
    A.Not using Tri-state even with smaller area and faster speed because it's strucutre is dangerous,when counter_selector has occured
    some errors will result in Tri-state circuit being burnt down.

When counter_selection signal isn't 1 bit, we'll add a decoder before counter_selecting, which is called 
"Binary counter_selection Multiplexor"

// Arbiters.
/*Arbiter handles requests from multiple devices to use a single resource
-For bus arbitration (bus分配)
-Normalization in floating point operations.
-不同值數要分配到同一格空間的值都會需要。

1- Bit/4-bit arbriters:
Bit-cell method:
    Advantage:
        1. Simplified look
        2. Symmetric
    Disadvantage:
        1.Area
        2.Speed is slow(Main problem),(Longest delay from Top to down.)
Q.How to boost the speed of Arbiters?
A.Using "look-ahead" method, expand the loop.
But "look-ahead"method need more area than "Bit-Cell" method.

*/