always #(CYCLE/) clk = ~clk; //no conditional executing

//=====/
//initial
//======
rst_n = 1'b1;
1n_valid =1'b0;
1n+data = 'dx;
initial begin
    rst_n = 1'b1;
    in_valid = 1'b0;
    in_data = 'dx;

    force clk = 0l;
    reset_task;
    repeat(1)@(negedge clk);
end


//reset part
#(2.0)

$display("FAIL");
$display("===================");
$display("Complete time %d",);
$display("===================");
$display("Complete time %d",);


