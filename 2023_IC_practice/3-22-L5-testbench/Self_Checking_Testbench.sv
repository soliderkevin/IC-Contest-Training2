//Every inputs given, checking answer.
module counter_self_checking_testbench();
    logic a,b,c;
    logic y;
    sillyfunction dut(a,b,c,y); //instantiate "dut"
    initial 
        begin //apply inputs, check results one at a time
            a=0;b=0;c=0; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=0;b=0;c=1; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=0;b=1;c=1; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=1;b=1;c=1; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=1;b=1;c=0; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=1;b=0;c=0; #10
            if( y!== 1) $display("0000 failed."); //check answer
            a=0;b=1;c=0; #10
            if( y!== 1) $display("0000 failed."); //check answer
        end
endmodule