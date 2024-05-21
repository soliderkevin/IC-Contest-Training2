module pattern(
    clk_p,
    rst_n,
    data_in,
    data_out
);
//parameter setting
parameter cycle = 10;
parameter Th = 2;
// I/O declaration
output clk_p;
output rst_n;
output [Width-1:0] data_in;
output [Width-1:0] data_out;
reg clk_p;
reg rst_n;
reg [Width-1:0] data_in;

//clock signal 
// always without any @ is unconditional executing.
//0~5 is unknown, and after 10/2 ns later will always change the signal value.1<->0
always begin
    #(cycle/2.0) clk_p = 1'b1;
    #(cycle/2.0) clk_p = 1'b0;
     
end


initial begin
    //rst
    rst_n = 1'b1;
    wait(clk_p! == 1'bx); /*avoid unknown stage*/
    @(negedge clk_p);
    rst_n = 1'b0;
    @(negedge clk_p);
    rst_n = 1'b1;

    //stimulus generation
    @(posedge clk_p)
    #(Th)
    data_in = 8'd8;  //1st cycle
    @(posedge clk_p)
    #(Th)
    data_in = 8'd2; //2nd cycle
    //2nd cycle

    $finish

end
endmodule