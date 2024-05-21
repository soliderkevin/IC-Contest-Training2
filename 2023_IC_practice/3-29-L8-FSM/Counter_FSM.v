module Counter1_table_based(clk,rst,out);
input rst,clk;
output[4:0] out;
reg [4:0] next;

    DFF #(5) count(clk,next,out) ; //5-bit counter

    always@(*) begin
        casez((rst,out))
            6'b100000: next = 0;
            6'b100001: next = 1;
            6'b1???10: next = 1;
            6'b1??100: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 1;
            6'b1?????: next = 0;
        endcase
    end
endmodule

module Counter_datapath_based(clk,rst,count);
parameter n = 5;
input rst,clk;
output[n-1:0] count;

wire [n-1:0] next = rst? 0: count +1;

    DFF#(n) count(clk,next,count);

endmodule


module Counter1_reference(); //synchronization reset
    input rst,clk;
    output [4:0]out;
    reg[4:0] next;
    DFF #(5) count(clk,next,out);

    always@(rst,out)
    begin
        case(rst)
            1'b1:next = 0;
            1'b0: next = out+1;
        endcase
    end
endmodule 


module Counter2_faster(clk,rst,out); //Asynchronization reset
input rst,clk;
output [4:0] out;
reg[4:0] next;
reg[4:0] out;
always@(posedge clk or posedge rst)
begin
    if(rst) 
    begin
        out <=0;  
    end
    else 
    begin
        out <= next;
    end
end
always (*) begin
    next = out+1;
end
endmodule



module a_simple_counter(
    output nextstate,
    input state,
    input rst,
);
    always@(rst)
    next_state = rst?0 : state+1;

endmodule