module test_prime;
reg[3:0] in;
wire isprime;

//instantiate module to test:
prime p0(in, isprime);
    initial begin
        in = 0;
        repeat(16) begin
            #100
            $display("in = %2d isprime = %1b", in, isprime);
            in = in+1;
        end
    end
endmodule