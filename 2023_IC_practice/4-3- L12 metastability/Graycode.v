//Mostly used when processing FIFO modules.
// Binary Code -> Gray
module gray2bin #(parameter SIZE = 4)
(output logic [SIZE-1:0] bin,
input logic [SIZE-1:0] gray
);
always@(*) 
begin
    for(int i = 0; i<SIZE; i++)
    bin[i] = ^(gray>>i);
end
endmodule


//binary back to gray code
module bin2gray #(parameter SIZE = 4)
(output logic [SIZE-1:)] gray,
input logic [SIZE - 1:0] bin);
    assign gray = (bin>>1)^bin;
endmodule