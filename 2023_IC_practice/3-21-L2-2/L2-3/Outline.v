/*
。Continus and procedural assignement statements are very different.
Continuous assignment are for naming, thus we can't have multiple assignment at the same wire.
Procedural assignment hold a value semantically, but it is important to distinguish this hardware state.
*/

/*correct proceudral
This one is allowed
They're Together and will not cause the problem*/
module correct(out,t0,t1,temp;)
always @(*)
begin
    temp = ~((counter_sel[1]&c)|(~counter_sel[1]&a));
    t0 = temp;
    temp = ~((counter_sel[1]&d)|(~counter_sel[1] & b));
    t1 = temp;
    out = ~((t0 | counter_sel[0] & (t1 | ~counter_sel[0])));
end

endmodule

/*incorrect proceudral
This one is not allowed
They're individual and will create combinational frequent loop*/*/

assign temp = ~((counter_sel[1]&c)|~(counter_sel[1]&c));
assign t0 = temp;
assign temp = ~((counter_sel[1]&d)|)
assign t1 = temp;
assign out = ~((t0 | counter_sel[0]) &)




/*。Hierachical Reference Names*/
/*Every Verilog description shall have a unique hierachical path name.
The hierachy of names can be viewed as a tree structure.
Hierarchical name referencing allows free data access to any object from any level in the hierachy.
*/

/* FOR_LOOP 
Verilog for for_loop only in always block.
for loop in verilog is DIFFERENT from loop block in C.
Try to expand for_loop in verilog to see if it matches whwat you think or not.

For example, for loop 1+...+10 in for loop is wrong.

Good for Bit reversal: 
Given a 100-bit input vector[99:0], reverse its bit ordering.
*/
/*correct use of bits*/
module top_module(
    in, out
)
    parameter Width = 100
    input[Width-1:0] in,
    output reg[Width-1:0] out

always @(*) 
    begin
        for(int i = 0;  i<$bits(out) ; i++) //*$bits to calculate how many bits inside.
            out[i] = in[$bits(out)-i-1]; //*$bits to calculate how many bits inside.
    end
endmodule


/*
Example of loop use 1:
Improper Loop use:

input[Width-1:0]a;
output[Width-1:0]b;
integer i;
reg [Width-1:0] b;
always @(a)begin
    for(i= 0;i<=N-1;i=i+1)
    b[i] = ~a[i];
end

/*Proper loop use:
input [N-1:0] a;
output [N-1:0] b;
assign b = ~a;

Example of loop use 2,Bus reversal:
/*Simulation speed loop overhead slower
input [15:0] a;
output [15:0] b;
integer i;
reg [15:0] b;
    always @(a)begin
        for(i = 0; i<=15;i=i+1)
        b[15-i] = a[i];
    end

/*Simulation speed loop overhead faster
input [15:0] a;
output [15:0] b;
assign b= {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15],}

/*。Parameterized Design*/
/*8 adders example*/ 
/*u[0].add.....u[1].add are generated*/
generate
        genvar i;
    for(i=0;i<=7;i=i+1)
    begin: u
        adder8 add(sum[(i*8)+:8],co[i+1],a[(i*8)+:8],b[(i*8)+:8],ci[i]);
    
    end
endgenerate
/*Multiplier example:*/
module multiplier(a,b,product);
parameter a_width = 8;
parameter b_width = 8;
localparam product_width = Width + Width;
input [a_width-1:0]a;
input[b_width-1:0] b;
output[product_width-1:0] product;
    generate
        if(( a_width<8)||(b_width<8))
            CLA_multiplier #(a_width,b_width) u1 (a,b,product);
        else
            WALLACE_multiplier #(a_width,b_width) u1 (a,b,product);
    endgenerate
endmodule


/*combinational logic:
initial value for CL will be igored for synthesiss
No assign block(legal but not synthesizable)

Not allowed:
wire[3:0]a;
wire[3:0]b;
assign a = b+a;

Allowed:
always_ff@(posedge clk)
a<= b+a;
/*generating the combinational feedback, creating oscillator.*/

/*。Multiple Drivers
    One variable can only be assigned in one always block or in one assign
    This will cause race conditions(actual values depends simulator scheduling)
    //Improper code:
    always_comb
    a=e+f;
    always_comb
    a=2;
    //proper code:
        always_comb bein
            a= e+f;
            a=2;
        end
*/


/*Same variable used in two loops running simulaneously*/
module twoloops;
integer i;
initial begin //start at time 0
    for( int i=0; i<=7; i = i+1) begin
        #5 $display("Entered 1st loopa t t= %0d, i = 
        %0d", $time, i);
    end
end

initial begin // start at time 0
    for ( int i = 0; i<= 7; i = i+1)begin
        #2 display ("Entered 2nd loop at t= %0d, i = %0d", time, i);
    end
end
endmodule

/*。How to find incomplete Case/if-else?
-Linting tools
-Synthesis tools: check "latch" keyword in the synthesis log. */
 
 /*。Combinational logic use "blocking", sequential logic use "non-blocking"*/

 /*Tri-state logic
 "inout[15:0] data_pad" use in on-chip bus or I/O pad
*/

/*All keywords in verilog:
always, begin... end, case... endcase, casez....endcase, if....else..., module...endmodule, input... output..., function(){}, reg .., wire..., logic..., default:.., posedge..., negedge.., parameter...,... or..., assign .., for.. 

*/