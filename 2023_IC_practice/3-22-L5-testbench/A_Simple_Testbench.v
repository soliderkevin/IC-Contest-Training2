//Test bench
module test_bench;
reg a,b,clk;
wire c
Test_bench_program U1(.in1(a),.in2(a),.clk(clk),.out1(c));
initial
begin //Test program
    test1();
    $finsih;
end
initial
    begin
        clk=0;
        forever #5 clk =~clk;
    end
initial
    begin //Monitor the simulation
        $dumpvars;
        $display("clk | in1 | in2 | out1|");
        $monitor("%b| %b | %b | `%b",clk,a,b,c)
    end    
endmodule  
//Test bench (auto)
module Test_bench_program(in1,in2,clk,out1);
input in1, in2;
input clk;
output reg out1;
    always@(posedge clk)
    out1 = in1^in2;
endmodule.
//Test pattern. (auto)
task test_bench_program();
    begin
           a = 0; b = 0;
    #10    a = 0; b = 1;
    #10    a = 1; b = 1;
    #10    a = 1; b = 0;
    end
endtask


