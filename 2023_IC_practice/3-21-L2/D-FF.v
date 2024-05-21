module sync_dff(
    Data,CLK,RST,Q
)
    parameter Width = 4;
    input [Width-1:0] Data;
    input CLK;
    input RST;
    output reg [Width-1:0]Q;


    always@(posedge CLK)
    begin
        if(~RST) begin
            Q <= 1'b0;
        end
        else begin
            Q <=  DATA;
        end
    end
endmodule 


module async_dff(
    Data,CLK,RST,Q
)
    parameter Width = 4;
    input [Width-1:0] Data;
    input CLK;
    input RST;
    output reg [Width-1:0]Q;


    always@(posedge CLK or negedge CLK)begin
        if(~RST) begin
            Q <= 1'b0;
        end
        else begin
            Q<=  DATA;
        end
    end
endmodule 