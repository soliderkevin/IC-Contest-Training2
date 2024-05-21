module Four_input_multiplexor(
    input a,b,c,d
    input [1:0] counter_sel; 
    output out;
)
    wire out,t0,t1;
    assign t0 = ~((counter_sel[1]&c)|(counter_sel[1]&a));
    assign t1 = ~((counter_sel[1]&b)|(counter_sel[1] &d));
    assign out = ~((t0&counter_sel[0])|(~t1 & counter_sel[0]));
endmodule